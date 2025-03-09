#import "UnityAppController.h"
#import "UnityAppController+ViewHandling.h"
#import "UnityAppController+Rendering.h"
#import "iPhone_Sensors.h"

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CADisplayLink.h>
#import <Availability.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#include <mach/mach_time.h>

// MSAA_DEFAULT_SAMPLE_COUNT was moved to iPhone_GlesSupport.h
// ENABLE_INTERNAL_PROFILER and related defines were moved to iPhone_Profiler.h
// kFPS define for removed: you can use Application.targetFrameRate (30 fps by default)
// DisplayLink is the only run loop mode now - all others were removed

#include "CrashReporter.h"
#include "MoviePlayerViewController.h"

#include "UI/OrientationSupport.h"
#include "UI/UnityView.h"
#include "UI/Keyboard.h"
#include "UI/SplashScreen.h"
#include "Unity/InternalProfiler.h"
#include "Unity/DisplayManager.h"
#include "Unity/EAGLContextHelper.h"
#include "Unity/GlesHelper.h"
#include "Unity/ObjCRuntime.h"
#include "PluginBase/AppDelegateListener.h"

#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>

#import <roioslib/SDKManager.h>
#import <roioslib/IUnity.h>
#import <roioslib/ISDK.h>

// we assume that app delegate is never changed and we can cache it, instead of re-query UIApplication every time
UnityAppController* _UnityAppController = nil;

// Standard Gesture Recognizers enabled on all iOS apps absorb touches close to the top and bottom of the screen.
// This sometimes causes an ~1 second delay before the touch is handled when clicking very close to the edge.
// You should enable this if you want to avoid that delay. Enabling it should not have any effect on default iOS gestures.
#define DISABLE_TOUCH_DELAYS 1

// we keep old bools around to support "old" code that might have used them
bool _ios81orNewer = false, _ios82orNewer = false, _ios83orNewer = false, _ios90orNewer = false, _ios91orNewer = false;
bool _ios100orNewer = false, _ios101orNewer = false, _ios102orNewer = false, _ios103orNewer = false;
bool _ios110orNewer = false, _ios111orNewer = false, _ios112orNewer = false;

// was unity rendering already inited: we should not touch rendering while this is false
bool    _renderingInited        = false;
// was unity inited: we should not touch unity api while this is false
bool    _unityAppReady          = false;
// see if there's a need to do internal player pause/resume handling
//
// Typically the trampoline code should manage this internally, but
// there are use cases, videoplayer, plugin code, etc where the player
// is paused before the internal handling comes relevant. Avoid
// overriding externally managed player pause/resume handling by
// caching the state
bool    _wasPausedExternal      = false;
// should we skip present on next draw: used in corner cases (like rotation) to fill both draw-buffers with some content
bool    _skipPresent            = false;
// was app "resigned active": some operations do not make sense while app is in background
bool    _didResignActive        = false;

// was startUnity scheduled: used to make startup robust in case of locking device
static bool _startUnityScheduled    = false;

bool    _supportsMSAA           = false;

#if UNITY_SUPPORT_ROTATION
// Required to enable specific orientation for some presentation controllers: see supportedInterfaceOrientationsForWindow below for details
NSInteger _forceInterfaceOrientationMask = 0;
#endif

@implementation UnityAppController

@synthesize unityView               = _unityView;
@synthesize unityDisplayLink        = _displayLink;

@synthesize rootView                = _rootView;
@synthesize rootViewController      = _rootController;
@synthesize mainDisplay             = _mainDisplay;
@synthesize renderDelegate          = _renderDelegate;
@synthesize quitHandler             = _quitHandler;

#if UNITY_SUPPORT_ROTATION
@synthesize interfaceOrientation    = _curOrientation;
#endif

- (id)init
{
    if ((self = _UnityAppController = [super init]))
    {
        // due to clang issues with generating warning for overriding deprecated methods
        // we will simply assert if deprecated methods are present
        // NB: methods table is initied at load (before this call), so it is ok to check for override
        NSAssert(![self respondsToSelector: @selector(createUnityViewImpl)],
            @"createUnityViewImpl is deprecated and will not be called. Override createUnityView"
        );
        NSAssert(![self respondsToSelector: @selector(createViewHierarchyImpl)],
            @"createViewHierarchyImpl is deprecated and will not be called. Override willStartWithViewController"
        );
        NSAssert(![self respondsToSelector: @selector(createViewHierarchy)],
            @"createViewHierarchy is deprecated and will not be implemented. Use createUI"
        );
    }
    return self;
}

- (void)setWindow:(id)object        {}
- (UIWindow*)window                 { return _window; }


- (void)shouldAttachRenderDelegate  {}
- (void)preStartUnity               {}


- (void)startUnity:(UIApplication*)application
{
    NSAssert(_unityAppReady == NO, @"[UnityAppController startUnity:] called after Unity has been initialized");

    UnityInitApplicationGraphics();

    // we make sure that first level gets correct display list and orientation
    [[DisplayManager Instance] updateDisplayListCacheInUnity];

    UnityLoadApplication();
    Profiler_InitProfiler();

    [self showGameUI];
    [self createDisplayLink];

    UnitySetPlayerFocus(1);
}

extern "C" void UnityDestroyDisplayLink()
{
    [GetAppController() destroyDisplayLink];
}

extern "C" void UnityRequestQuit()
{
    _didResignActive = true;
    if (GetAppController().quitHandler)
        GetAppController().quitHandler();
    else
        exit(0);
}

#if UNITY_SUPPORT_ROTATION

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    // No rootViewController is set because we are switching from one view controller to another, all orientations should be enabled
    if ([window rootViewController] == nil)
        return UIInterfaceOrientationMaskAll;

    // Some presentation controllers (e.g. UIImagePickerController) require portrait orientation and will throw exception if it is not supported.
    // At the same time enabling all orientations by returning UIInterfaceOrientationMaskAll might cause unwanted orientation change
    // (e.g. when using UIActivityViewController to "share to" another application, iOS will use supportedInterfaceOrientations to possibly reorient).
    // So to avoid exception we are returning combination of constraints for root view controller and orientation requested by iOS.
    // _forceInterfaceOrientationMask is updated in willChangeStatusBarOrientation, which is called if some presentation controller insists on orientation change.
    return [[window rootViewController] supportedInterfaceOrientations] | _forceInterfaceOrientationMask;
}

- (void)application:(UIApplication*)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
{
    // Setting orientation mask which is requested by iOS: see supportedInterfaceOrientationsForWindow above for details
    _forceInterfaceOrientationMask = 1 << newStatusBarOrientation;
}

#endif

- (void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    AppController_SendNotificationWithArg(kUnityDidReceiveLocalNotification, notification);
    UnitySendLocalNotification(notification);
}

// 注册远端推送
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"UnityAppController didRegisterForRemoteNotificationsWithDeviceToken");
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs]){
        [sdk onApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    }
    
    AppController_SendNotificationWithArg(kUnityDidRegisterForRemoteNotificationsWithDeviceToken, deviceToken);
    UnitySendDeviceToken(deviceToken);
}

// 注册远端推送失败
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"UnityAppController didFailToRegisterForRemoteNotificationsWithError");
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs])
        [sdk onApplication:application didFailToRegisterForRemoteNotificationsWithError:error];
}

// 应用在前台收到远端推送
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"UnityAppController Foreground didReceiveRemoteNotification");
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs]){
        [sdk onApplication:application didReceiveRemoteNotification:userInfo];
    }
    AppController_SendNotificationWithArg(kUnityDidReceiveRemoteNotification, userInfo);
    UnitySendRemoteNotification(userInfo);
}

// 应用在后台收到远端推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    NSLog(@"UnityAppController Background didReceiveRemoteNotification");
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs]){
        [sdk onApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    }
    //msdk_xg_push
    AppController_SendNotificationWithArg(kUnityDidReceiveRemoteNotification, userInfo);
    UnitySendRemoteNotification(userInfo);
    if (completionHandler)
    {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

// iOS 10 新增回调 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 在后台弹通知需要调用这个接口
- (void)onPushUserNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
    withCompletionHandler:(void (^)(void))completionHandler
    {
        NSLog(@"UnityAppController Background onPushUserNotificationCenter");
        //通知SDK
        for(ISDK * sdk in [SDKManager SDKs]){
            [sdk onUserNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
        }
        //msdk_xg_push_ios10_background
        completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)onPushUserNotificationCenter:(UNUserNotificationCenter *)center
     willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
         {
            NSLog(@"UnityAppController Foreground onPushUserNotificationCenter");
            //通知SDK
            for(ISDK * sdk in [SDKManager SDKs]){
                [sdk onUserNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
            }
            //msdk_xg_push_ios10_foreground
            completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

//应用打开Url
// UIApplicationOpenURLOptionsKey was added only in ios10 sdk, while we still support ios9 sdk
- (BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary<NSString*, id>*)options
{
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs]){
        [sdk onApplicationOpenUrl:app url:url options:options];
    }
    
    id sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey], annotation = options[UIApplicationOpenURLOptionsAnnotationKey];

    NSMutableDictionary<NSString*, id>* notifData = [NSMutableDictionary dictionaryWithCapacity: 3];
    if (url) notifData[@"url"] = url;
    if (sourceApplication) notifData[@"sourceApplication"] = sourceApplication;
    if (annotation) notifData[@"annotation"] = annotation;

    AppController_SendNotificationWithArg(kUnityOnOpenURL, notifData);
    return YES;
}

 //应用收到Url
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
 {
     //通知SDK
     for(ISDK * sdk in [SDKManager SDKs])
         [sdk onApplicationHandleUrl:application url:url];

     return YES;
 }

- (BOOL)application:(UIApplication*)application willFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    AppController_SendNotificationWithArg(kUnityWillFinishLaunchingWithOptions, launchOptions);
    return YES;
}

bool _isFirebaseConfigure = false;
//应用启动
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    ::printf("-> applicationDidFinishLaunching()\n");
    
    [SDKManager SetApplication:application];
    [SDKManager SetUnity:self];
    //通知SDK应用启动
    for(ISDK * sdk in [SDKManager SDKs]){
        if(!_isFirebaseConfigure && ([sdk->SDKName isEqualToString:@"ROOverSea"] || [sdk->SDKName isEqualToString:@"ROFirebase"])){
            // 由于都接入了firebase，所有都需要初始化，但只需要初始化一次
            //firebase_config_insert
            _isFirebaseConfigure = true;
        }
        [sdk onApplicationFinishLaunching:application withOptions:launchOptions];
    }
    
    //firebase_messageing_insert
    if ([UNUserNotificationCenter class] != nil) {
      // iOS 10 or later
      // For iOS 10 display notification (sent via APNS)
      [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
          UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter]
          requestAuthorizationWithOptions:authOptions
          completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
          }];
    } else {
      // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
      UIUserNotificationType allNotificationTypes =
      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
      UIUserNotificationSettings *settings =
      [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
      [application registerUserNotificationSettings:settings];
    }
    [application registerForRemoteNotifications];

    //msdk_xg_push_register

    // send notfications
#if !PLATFORM_TVOS
    if (UILocalNotification* notification = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey])
        UnitySendLocalNotification(notification);

    if ([UIDevice currentDevice].generatesDeviceOrientationNotifications == NO)
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
#endif

    UnityInitApplicationNoGraphics([[[NSBundle mainBundle] bundlePath] UTF8String]);

    [self selectRenderingAPI];
    [UnityRenderingView InitializeForAPI: self.renderingAPI];

    _window         = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    _unityView      = [self createUnityView];

    [DisplayManager Initialize];
    _mainDisplay    = [DisplayManager Instance].mainDisplay;
    [_mainDisplay createWithWindow: _window andView: _unityView];

    [self createUI];
    [self preStartUnity];

    // if you wont use keyboard you may comment it out at save some memory
    [KeyboardDelegate Initialize];

#if !PLATFORM_TVOS && DISABLE_TOUCH_DELAYS
    for (UIGestureRecognizer *g in _window.gestureRecognizers)
    {
        g.delaysTouchesBegan = false;
    }
#endif

    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(userDidTakeScreenshot:)
        name:UIApplicationUserDidTakeScreenshotNotification
      object:nil];

    return YES;
}

#pragma mark - 用户截屏通知事件
- (void)userDidTakeScreenshot:(NSNotification *)notification {
    NSLog(@"userDidTakeScreenshot");
    [ISDK SendUnityMessage:@"OnScreenShot" withArgs:@""];
}

//应用进入后台
- (void)applicationDidEnterBackground:(UIApplication*)application
{
    ::printf("-> applicationDidEnterBackground()\n");
    
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs]){
        [sdk onApplicationDidEnterBackground:application];
    }
}

//应用即将回到前台
- (void)applicationWillEnterForeground:(UIApplication*)application
{
    ::printf("-> applicationWillEnterForeground()\n");
    
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs]){
        [sdk onApplicationWillEnterforeground:application];
    }

    // applicationWillEnterForeground: might sometimes arrive *before* actually initing unity (e.g. locking on startup)
    if (_unityAppReady)
    {
        // if we were showing video before going to background - the view size may be changed while we are in background
        [GetAppController().unityView recreateRenderingSurfaceIfNeeded];
    }
}

//应用将要进入激活状态
- (void)applicationDidBecomeActive:(UIApplication*)application
{
    ::printf("-> applicationDidBecomeActive()\n");
    
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs]){
        [sdk onApplicationDidBecomeActive:application];
    }

    [self removeSnapshotView];

    if (_unityAppReady)
    {
        if (UnityIsPaused() && _wasPausedExternal == false)
        {
            UnityWillResume();
            UnityPause(0);
        }
        if (_wasPausedExternal)
        {
            if (UnityIsFullScreenPlaying())
                TryResumeFullScreenVideo();
        }
        UnitySetPlayerFocus(1);
    }
    else if (!_startUnityScheduled)
    {
        _startUnityScheduled = true;
        [self performSelector: @selector(startUnity:) withObject: application afterDelay: 0];
    }

    _didResignActive = false;
}

- (void)removeSnapshotView
{
    // do this on the main queue async so that if we try to create one
    // and remove in the same frame, this always happens after in the same queue
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_snapshotView)
        {
            [_snapshotView removeFromSuperview];
            _snapshotView = nil;
        }
    });
}

//应用将要进入非激活状态
- (void)applicationWillResignActive:(UIApplication*)application
{
    ::printf("-> applicationWillResignActive()\n");
    
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs]){
        [sdk onApplicationWillResignActive:application];
    }

    if (_unityAppReady)
    {
        UnitySetPlayerFocus(0);

        _wasPausedExternal = UnityIsPaused();
        if (_wasPausedExternal == false)
        {
            // Pause Unity only if we don't need special background processing
            // otherwise batched player loop can be called to run user scripts.
            if (!UnityGetUseCustomAppBackgroundBehavior())
            {
                // Force player to do one more frame, so scripts get a chance to render custom screen for minimized app in task manager.
                // NB: UnityWillPause will schedule OnApplicationPause message, which will be sent normally inside repaint (unity player loop)
                // NB: We will actually pause after the loop (when calling UnityPause).
                UnityWillPause();
                [self repaint];
                UnityPause(1);

                // this is done on the next frame so that
                // in the case where unity is paused while going
                // into the background and an input is deactivated
                // we don't mess with the view hierarchy while taking
                // a view snapshot (case 760747).
                dispatch_async(dispatch_get_main_queue(), ^{
                    // if we are active again, we don't need to do this anymore
                    if (!_didResignActive)
                    {
                        return;
                    }

                    _snapshotView = [self createSnapshotView];
                    if (_snapshotView)
                        [_rootView addSubview: _snapshotView];
                });
            }
        }
    }

    _didResignActive = true;
}

//应用受到内存警告
- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    ::printf("WARNING -> applicationDidReceiveMemoryWarning()\n");
    
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs]){
        [sdk onApplicationDidReceiveMemoryWarning:application];
    }
    
    UnityLowMemory();
}

//应用将关闭
- (void)applicationWillTerminate:(UIApplication*)application
{
    ::printf("-> applicationWillTerminate()\n");
    
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs]){
        [sdk onApplicationWillTerminate:application];
    }

    Profiler_UninitProfiler();
    UnityCleanup();

    extern void SensorsCleanup();
    SensorsCleanup();
}

- (void)application:(UIApplication*)application handleEventsForBackgroundURLSession:(nonnull NSString *)identifier completionHandler:(nonnull void (^)())completionHandler
{
    NSDictionary* arg = @{identifier: completionHandler};
    AppController_SendNotificationWithArg(kUnityHandleEventsForBackgroundURLSession, arg);
}

//后台刷新数据
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    ::printf("-> performFetchWithCompletionHandler()\n");
    
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs])
        [sdk onApplication:application performFetchWithCompletionHandler:completionHandler];
}

//实现IUnity接口，向Unity发送消息
- (void) SendUnityMessageWithObject:(NSString *)obj andName:(NSString *)name andArgs:(NSString *)args
{
    NSLog(@"ios send unity message, obj :%@, name : %@, args : %@", obj, name, args);
    
    const char * cobj = obj != nil ? [obj UTF8String] : [@"" UTF8String];
    const char * cname = name != nil ? [name UTF8String] : [@"" UTF8String];
    const char * cargs = args != nil ? [args UTF8String] : [@"" UTF8String];
    
    UnitySendMessage(cobj, cname, cargs);
}

- (void) playMovie
{
    [self PlayMovieWithName:nil andArgs:nil];
}

//播放动画
- (void) PlayMovieWithName : (NSString *)name andArgs : (NSString*) args
{
    //播放动画
    MoviePlayerViewController * mp = [[MoviePlayerViewController alloc] init];
    
    //IOS8.0以下的版本不支持AVPlayer控件，必须使用MPMoviePlayerController播放，以后再改
    if(mp == nil)
    {
        NSLog(@"avplayer can not be found , skip the movie");
        UnitySendMessage("Game", "StartLogo", "");
        return;
    }
    else
    {
        [self.rootViewController presentViewController:mp animated:NO completion:nil];
    }
}

@end


void AppController_SendNotification(NSString* name)
{
    [[NSNotificationCenter defaultCenter] postNotificationName: name object: GetAppController()];
}

void AppController_SendNotificationWithArg(NSString* name, id arg)
{
    [[NSNotificationCenter defaultCenter] postNotificationName: name object: GetAppController() userInfo: arg];
}

void AppController_SendUnityViewControllerNotification(NSString* name)
{
    [[NSNotificationCenter defaultCenter] postNotificationName: name object: UnityGetGLViewController()];
}

extern "C" UIWindow*            UnityGetMainWindow()
{
    return GetAppController().mainDisplay.window;
}

extern "C" UIViewController*    UnityGetGLViewController()
{
    return GetAppController().rootViewController;
}

extern "C" UIView*              UnityGetGLView()
{
    return GetAppController().unityView;
}

extern "C" ScreenOrientation    UnityCurrentOrientation()   { return GetAppController().unityView.contentOrientation; }


bool LogToNSLogHandler(LogType logType, const char* log, va_list list)
{
    NSLogv([NSString stringWithUTF8String: log], list);
    return true;
}

static void AddNewAPIImplIfNeeded();

// From https://stackoverflow.com/questions/4744826/detecting-if-ios-app-is-run-in-debugger
static bool isDebuggerAttachedToConsole(void)
// Returns true if the current process is being debugged (either
// running under the debugger or has a debugger attached post facto).
{
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;

    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.

    info.kp_proc.p_flag = 0;

    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.

    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();

    // Call sysctl.

    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);

    // We're being debugged if the P_TRACED flag is set.

    return ((info.kp_proc.p_flag & P_TRACED) != 0);
}

void UnityInitTrampoline()
{
    InitCrashHandling();

    NSString* version = [[UIDevice currentDevice] systemVersion];
#define CHECK_VER(s) [version compare: s options: NSNumericSearch] != NSOrderedAscending
    _ios81orNewer  = CHECK_VER(@"8.1"),  _ios82orNewer  = CHECK_VER(@"8.2"),  _ios83orNewer  = CHECK_VER(@"8.3");
    _ios90orNewer  = CHECK_VER(@"9.0"),  _ios91orNewer  = CHECK_VER(@"9.1");
    _ios100orNewer = CHECK_VER(@"10.0"), _ios101orNewer = CHECK_VER(@"10.1"), _ios102orNewer = CHECK_VER(@"10.2"), _ios103orNewer = CHECK_VER(@"10.3");
    _ios110orNewer = CHECK_VER(@"11.0"), _ios111orNewer = CHECK_VER(@"11.1"), _ios112orNewer = CHECK_VER(@"11.2");

#undef CHECK_VER

    AddNewAPIImplIfNeeded();

#if !TARGET_IPHONE_SIMULATOR
    // Use NSLog logging if a debugger is not attached, otherwise we write to stdout.
    if (!isDebuggerAttachedToConsole())
        UnitySetLogEntryHandler(LogToNSLogHandler);
#endif
}

extern "C" bool UnityiOS81orNewer() { return _ios81orNewer; }
extern "C" bool UnityiOS82orNewer() { return _ios82orNewer; }
extern "C" bool UnityiOS90orNewer() { return _ios90orNewer; }
extern "C" bool UnityiOS91orNewer() { return _ios91orNewer; }
extern "C" bool UnityiOS100orNewer() { return _ios100orNewer; }
extern "C" bool UnityiOS101orNewer() { return _ios101orNewer; }
extern "C" bool UnityiOS102orNewer() { return _ios102orNewer; }
extern "C" bool UnityiOS103orNewer() { return _ios103orNewer; }
extern "C" bool UnityiOS110orNewer() { return _ios110orNewer; }
extern "C" bool UnityiOS111orNewer() { return _ios111orNewer; }
extern "C" bool UnityiOS112orNewer() { return _ios112orNewer; }

// sometimes apple adds new api with obvious fallback on older ios.
// in that case we simply add these functions ourselves to simplify code
static void AddNewAPIImplIfNeeded()
{
    if (![[CADisplayLink class] instancesRespondToSelector: @selector(setPreferredFramesPerSecond:)])
    {
        IMP CADisplayLink_setPreferredFramesPerSecond_IMP = imp_implementationWithBlock(^void(id _self, NSInteger fps) {
            typedef void (*SetFrameIntervalFunc)(id, SEL, NSInteger);
            UNITY_OBJC_CALL_ON_SELF(_self, @selector(setFrameInterval:), SetFrameIntervalFunc, (int)(60.0f / fps));
        });
        class_replaceMethod([CADisplayLink class], @selector(setPreferredFramesPerSecond:), CADisplayLink_setPreferredFramesPerSecond_IMP, CADisplayLink_setPreferredFramesPerSecond_Enc);
    }

    if (![[UIScreen class] instancesRespondToSelector: @selector(maximumFramesPerSecond)])
    {
        IMP UIScreen_MaximumFramesPerSecond_IMP = imp_implementationWithBlock(^NSInteger(id _self) {
            return 60;
        });
        class_replaceMethod([UIScreen class], @selector(maximumFramesPerSecond), UIScreen_MaximumFramesPerSecond_IMP, UIScreen_maximumFramesPerSecond_Enc);
    }

    if (![[UIView class] instancesRespondToSelector: @selector(safeAreaInsets)])
    {
        IMP UIView_SafeAreaInsets_IMP = imp_implementationWithBlock(^UIEdgeInsets(id _self) {
            return UIEdgeInsetsZero;
        });
        class_replaceMethod([UIView class], @selector(safeAreaInsets), UIView_SafeAreaInsets_IMP, UIView_safeAreaInsets_Enc);
    }
}

#if defined(__cplusplus)
extern "C" {
#endif

//开始播放开场动画
void iosPlayMovie()
{
    NSLog(@"ios play movie");
    
    UnityAppController * app = (UnityAppController *)[SDKManager GetUnity];
    [app performSelectorOnMainThread:@selector(playMovie) withObject:app waitUntilDone:NO];
}

//实现接收到Unity消息接口
void iOSCallNativeVoidFunc(const char * name, const char * args)
{
    //封装参数
    NSString * nName = [NSString stringWithUTF8String:name];
    NSString * nArgs = [NSString stringWithUTF8String:args];
    
    NSLog(@"ios receive unity message, name : %@, args : %@", nName, nArgs);
    
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs])
        [sdk handleUnityMessage:nName withArgs:nArgs];
}

//实现接收到Unity数据接口
void iOSCallNativeBytesFunc(const char * name, const char * args, const char** data, const int length)
{
    //封装参数
    NSString * nName = [NSString stringWithUTF8String:name];
    NSString * nArgs = [NSString stringWithUTF8String:args];
    NSData * nData = [NSData dataWithBytes:(const void *)data length:(sizeof(unsigned char) * length)];
    
    NSLog(@"ios receive unity data, name : %@, args : %@", nName, nArgs);
    
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs])
        [sdk handleUnityData:nName withArgs:nArgs andData:nData];
    
}

//实现接收到Unity消息接口 并返回string
char* iOSCallNativeReturnFunc(const char * name, const char * args){
    //封装参数
    NSString * nName = [NSString stringWithUTF8String:name];
    NSString * nArgs = [NSString stringWithUTF8String:args];
    
    NSLog(@"ios getargs unity data, name : %@, args : %@", nName, nArgs);
    
    NSString* ret = @"";
    //通知SDK
    for(ISDK * sdk in [SDKManager SDKs]){
        ret = [sdk handleUnityGetArgs:nName withArgs:nArgs];
        if (![ret isEqualToString:@""]) break;
    }
    
    NSLog(@"iOSCallNativeReturnFunc : %@", ret);
    char* res = (char*)malloc([ret lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 1);
    strcpy(res, [ret UTF8String]);
    return res;
}

//实现原生通知unity的object
void InitNativeCallBackObj(const char * name)
{
    //封装参数
    NSString * nName = [NSString stringWithUTF8String:name];
    [SDKManager InitCallBackObj:nName];
}

#if defined(__cplusplus)
}
#endif
