

#import "MoviePlayerViewController.h"

@interface MoviePlayerViewController ()

@end

@implementation MoviePlayerViewController

- (BOOL)isManualClose
{
    return manualClose;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    manualClose = NO;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString * path = [bundle pathForResource:@"launch" ofType:@"mp4" inDirectory:@"Data/Raw/Movie"];
    NSLog(@"path is %@", path);
    NSURL * url = [NSURL fileURLWithPath:path];
    
    if(url == nil)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:url];
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    
    self.showsPlaybackControls = NO;
    [self setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    int width = [[UIScreen mainScreen] applicationFrame].size.width;
    int height = [[UIScreen mainScreen] applicationFrame].size.height;
    
    int size = width > height ? width : height;
    
    [self.player play];
}

-(void)avDidFinishPlaying:(NSNotification *) notification
{
    [self dismissViewControllerAnimated:NO completion:nil];
    UnitySendMessage("Game", "StartLogo", "");
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
