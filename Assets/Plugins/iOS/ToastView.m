
#import "ToastView.h"

#define FLT_APP_WINDOW  [[UIApplication sharedApplication] keyWindow]

@implementation ToastView

+ (void)showToast:(NSString *)message withDuration:(NSUInteger)duration {
    [ToastView dismissToast];
    dispatch_async(dispatch_get_main_queue(), ^{
        // build the toast label
        UILabel *toast = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        toast.text = message;
        toast.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        toast.textColor = kCBToastTextColor;
        toast.numberOfLines = 1000;
        toast.tag = 1024;
        toast.textAlignment = NSTextAlignmentCenter;
        toast.lineBreakMode = NSLineBreakByWordWrapping;
        toast.font = [UIFont systemFontOfSize:16.0f];
        toast.layer.cornerRadius = kCBToastCornerRadius;
        toast.layer.masksToBounds = YES;

        // resize based on message
        CGSize maximumLabelSize = CGSizeMake(kCBToastMaxWidth, 9999);
        CGSize expectedLabelSize = [toast.text boundingRectWithSize:maximumLabelSize
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:toast.font}
                                                            context:nil].size;
        //adjust the label to the new height
        CGRect newFrame = toast.frame;
        newFrame.size = CGSizeMake(expectedLabelSize.width + kCBToastPadding,
                                   expectedLabelSize.height + kCBToastPadding);
        toast.frame = newFrame;

        // add the toast to the root window (so it overlays everything)
        if ([toast.text length] > 0) {
            [FLT_APP_WINDOW addSubview:toast];

            // get the window frame to determine placement
            CGRect windowFrame = FLT_APP_WINDOW.frame;

            // align the toast properly
            toast.center = CGPointMake(windowFrame.size.width / 2, windowFrame.size.height - toast.frame.size.height);

            // round the x/y coords so they aren't 'split' between values (would appear blurry)
            toast.frame = CGRectMake(round(toast.frame.origin.x),
                                     round(toast.frame.origin.y),
                                     toast.frame.size.width,
                                     toast.frame.size.height);

            // set up the fade-in
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:kCBToastFadeDuration];

            // values being aninmated
            toast.alpha = 1.0f;

            // perform the animation
            [UIView commitAnimations];

            // calculate the delay based on fade-in time + display duration
            NSTimeInterval delay = duration;

            // set up the fade out (to be performed at a later time)
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:delay];
            [UIView setAnimationDuration:kCBToastFadeDuration];
            [UIView setAnimationDelegate:toast];
            [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];

            // values being animated
            toast.alpha = 0.0f;

            // commit the animation for being performed when the timer fires
            [UIView commitAnimations];
        }
    });
}

+ (void)dismissToast {
    UIView *toast = (UIView *)FLT_APP_WINDOW.subviews.lastObject;

    if (toast.tag == 1024) {
        [toast removeFromSuperview];
    }
}

@end
