
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MoviePlayerViewController : AVPlayerViewController
{
    BOOL manualClose;
}

-(BOOL) isManualClose;
@end

