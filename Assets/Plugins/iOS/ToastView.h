// 参考博客： https://www.jianshu.com/p/0c0ba195420d

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TOAST_LONG  2000
#define TOAST_SHORT 1000

#define kCBToastPadding         20
#define kCBToastMaxWidth        500
#define kCBToastCornerRadius    5.0
#define kCBToastFadeDuration    0.5
#define kCBToastTextColor       [UIColor whiteColor]
#define kCBToastBottomPadding   30

@interface ToastView : NSObject

+ (void)showToast:(NSString *)message withDuration:(NSUInteger)duration;

@end
