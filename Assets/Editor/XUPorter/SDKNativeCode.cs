using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

class CommonNativeCode
{
    public static readonly string IOS_SRC_HEADER = @"#import <roioslib/ISDK.h>";
    public static readonly string IOS_HEADER = @"
@interface UnityAppController () <IUnity, UNUserNotificationCenterDelegate>
@end
";
    public static readonly string IOS_SRC_SDK_MANAGER_LOAD = @"[SDKManager SetUnity:self];";
    public static readonly string IOS_SDK_MANAGER_LOAD = @"    [SDKManager Load:@""need_replace""];";

    public static readonly string IOS_SRC_HOME_INDICATOR = @"preferredScreenEdgesDeferringSystemGestures(\n.*?)+return res;";
    public static readonly string IOS_TARGET_HOME_INDICATOR = @"preferredScreenEdgesDeferringSystemGestures{  return UIRectEdgeAll;";
}

class LebianNativeCode
{
    public static readonly string IOS_SRC_LEBIAN_HEADER = @"#include ""PluginBase/AppDelegateListener.h""";

    public static readonly string IOS_SRC_LEBIAN_FINISH =
@"- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{";

    public static readonly string IOS_LEBIAN_HEADER = @"#import <LBSDK/LBInit.h>";

    public static readonly string IOS_LEBIAN_FINISH = @"
    // 请务必在方法的最前面调用该接口，否则很容易出问题
    if ([[LBInit sharedInstance] LBSDKShouldInitWithLaunchOptions:launchOptions]) {
        return YES;
    }
";
}

class KoreaSDKNativeCode
{
    public static readonly string IOS_SRC_KOREA_HEADER = @"#import <roioslib/ISDK.h>";
    public static readonly string IOS_KOREA_HEADER = @"
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <FirebaseMessaging/FIRMessaging.h>
@interface UnityAppController () <IUnity, UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
";
    
    public static readonly string IOS_KOREA_FIR_CONFIG = @"          [FIRApp configure];";

    public static readonly string IOS_KOREA_FIR_MESSAGEING = @"
    [FIRMessaging messaging].delegate = self;";
}


class MsdkNativeCode
{
    public static readonly string IOS_SRC_HEADER = @"#import <roioslib/ISDK.h>";

    public static readonly string IOS_SRC_FINISH =
@"- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{";

    public static readonly string IOS_SRC_OPENURL_9_0 =
@"- (BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary<NSString*, id>*)options";

    public static readonly string IOS_SRC_REGISTER =
@"- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{";

    public static readonly string IOS_SRC_REGISTER_FAIL =
@"- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{";

    public static readonly string IOS_SRC_RECEIVE =
@"- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{";

    public static readonly string IOS_SRC_ACTIVE = @"- (void)applicationDidBecomeActive:(UIApplication*)application
{";

    public static readonly string IOS_XG_PUSH_DETAIL = @"
    [[ROXGPush defaultManager] reportXGNotificationInfo:userInfo];";

    public static readonly string IOS_XG_PUSH_iOS10_FORE_DETAIL = @"
        [[ROXGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];";

    public static readonly string IOS_XG_PUSH_iOS10_BACK_DETAIL = @"
    [[ROXGPush defaultManager] reportXGNotificationResponse:response];";

    public static readonly string IOS_HEADER = @"
#import <MSDK/MSDK.h>
#import <MSDKAdapter/UnityObserver.h>
#include ""XGPush.h""
@interface UnityAppController () <IUnity, UNUserNotificationCenterDelegate, ROXGPushDelegate>
@end
";

    public static readonly string IOS_HANDLE_URL = @"
    // 处理平台拉起游戏
    NSLog(@""MSDK handle url == %@"",url);
    WGPlatform::GetInstance();
    return [WGInterface HandleOpenURL:url];";

    public static readonly string IOS_XG_REGISTER = @"    // 注册信鸽推送
	[[ROXGPush defaultManager] startXGWithAppID:2200311109 appKey:@""I639NKPB68CY"" delegate:self];";

    public static readonly string IOS_XG_SUCC = @"    // 注册信鸽成功
    NSLog(@""deviceToken = %@"",deviceToken);
    //[MSDKXG WGSuccessedRegisterdAPNSWithToken:deviceToken];";

    public static readonly string IOS_XG_FAIL = @"    // 注册信鸽失败
    NSLog(@""regisger failed:%@"",[error description]);
    //[MSDKXG WGFailedRegisteredAPNS];";

    public static readonly string IOS_XG_RECEIVE = @"    // 接收信鸽推送消息
    NSLog(@""userinfo:%@"",userInfo);
    //[MSDKXG WGReceivedMSGFromAPNSWithDict:userInfo];";

    public static readonly string IOS_XG_CLEAR = @"    // 清空应用桌面图标右上角的推送条目
    [MSDKXG WGCleanBadgeNumber];";

    public static readonly string IOS_BECAME_ACTIVE = @"    // 自动登录&验证本地票据
    // static bool msdkAppfirstLaunch = true;
    // LoginRet loginRet;
    // if(msdkAppfirstLaunch == true){
    //     WGPlatform::GetInstance()->WGGetLoginRecord(loginRet);
    //     WGPlatform::GetInstance()->WGLogin();
    //     msdkAppfirstLaunch = false;
    //     NSLog(@""MSDK autologin"");
    // }";
}
