#import <roioslib/ISDK.h>
#import <Photos/Photos.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "Reachability.h"
#include <sys/param.h>
#include <sys/mount.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import <CoreTelephony/CTCellularData.h>
#import "ToastView.h"

extern "C" {

char* cStringCopy(const char* string);

void _SavePhotoToSystem(Byte content[], int length){
    NSData *imgData = [[NSData alloc] initWithBytes:content length:length];
    UIImage *image = [UIImage imageWithData:imgData];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError *_Nullable error) {
        NSLog(@"JoyYouSDK ::: success = %d && error = %@", success, error);
    }];
}

long long _GetFreeDiskSpace(){
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return freespace;
}

const char* _GetNetworkType(){
    NSString *netconnType = @"";
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            netconnType = @"no network";
        }
            break;

        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;

        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];

            NSString *currentStatus = info.currentRadioAccessTechnology;

            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                netconnType = @"4G";
            }
        }
        break;

        default:
            break;
    }

    return cStringCopy([netconnType UTF8String]);
}

const char* _GetProvidersName(){
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    //NSLog(@"info = %@", info);
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString * str1;
    //NSLog(@"carrier = %@", carrier);
    if (carrier == nil) {
        str1 = @"不能识别";
        return cStringCopy([str1 UTF8String]);
    }
    NSString *code = [carrier mobileNetworkCode];
    if (code == nil) {
        str1 = @"不能识别";
        return cStringCopy([str1 UTF8String]);
    }
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        str1 = @"移动运营商";
    } else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
        str1 = @"联通运营商";
    } else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"]) {
        str1 = @"电信运营商";
    } else if ([code isEqualToString:@"20"]) {
        str1 = @"铁通运营商";
    }else{
        str1 = @"不能识别";
    }
    return cStringCopy([str1 UTF8String]);
    
}

const char* _AvailableSystemVersion(int version){
    NSString *ret = @"false";
    if(version == 9){
        if (@available(iOS 9.0, *)) ret = @"true";
    }
    else if(version == 10){
        if (@available(iOS 10.0, *)) ret = @"true";
    }
    else if(version == 11){
        if (@available(iOS 11.0, *)) ret = @"true";
    }
    else if(version == 12){
       if (@available(iOS 12.0, *)) ret = @"true";
    }
    else if(version == 13){
       if (@available(iOS 13.0, *)) ret = @"true";
    }
    else if(version == 14){
       if (@available(iOS 14.0, *)) ret = @"true";
    }
    return cStringCopy([ret UTF8String]);
}

void SendUnityMsg(NSString* callback, NSString* permission, NSString* ret){
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:permission forKey:@"permission"];
    [dict setObject:ret forKey:@"result"];
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"SendUnityMsg JsonData Got an error: %@", error);
    } else {
        NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"SendUnityMsg jsonStr = %@", jsonStr);
        [ISDK SendUnityMessage:callback withArgs:jsonStr];
    }
}

// 参考 https://www.jianshu.com/p/27e57922232b
void _CheckPermission(const char* string){
    static NSString *ret = @"None";
    NSString *permission = [NSString stringWithUTF8String:string];
    if([permission isEqualToString:@"Location"]){        // 位置
        if (![CLLocationManager locationServicesEnabled]) {
            ret = @"Denied";
        } else {
            CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
            switch (CLstatus) {
                case kCLAuthorizationStatusAuthorizedAlways:
                case kCLAuthorizationStatusAuthorizedWhenInUse:
                    ret = @"Authorized";
                    break;
                case kCLAuthorizationStatusDenied:
                case kCLAuthorizationStatusRestricted:
                    ret = @"Denied";
                    break;
                case kCLAuthorizationStatusNotDetermined:
                    ret = @"NotDetermined";
                    break;
                default:
                    break;
            }
        }
        SendUnityMsg(@"CheckPermissionCallBack", permission, ret);
    }
    else if([permission isEqualToString:@"Notification"]){        // 推送
        if (@available(iOS 10, *)){
            [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                switch (settings.authorizationStatus) {
                    case UNAuthorizationStatusNotDetermined:{
                        ret = @"NotDetermined";
                        break;
                    }
                    case UNAuthorizationStatusDenied:
                        ret = @"Denied";
                        break;
                    case UNAuthorizationStatusAuthorized:
                    case UNAuthorizationStatusProvisional:
                        ret = @"Authorized";
                        break;
                    default:
                        break;
                }
                SendUnityMsg(@"CheckPermissionCallBack", permission, ret);
            }];
        } else if (@available(iOS 8, *)) {
            UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
                switch (settings.types) {
                    case UIUserNotificationTypeNone:
                        ret = @"Denied";
                        break;
                    case UIUserNotificationTypeAlert:
                    case UIUserNotificationTypeBadge:
                    case UIUserNotificationTypeSound:
                        ret = @"Authorized";
                        break;
                    default:
                        break;
                }
                SendUnityMsg(@"CheckPermissionCallBack", permission, ret);
        }
    } else if([permission isEqualToString:@"Camera"]){        // 相机
        AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (AVstatus) {
            case AVAuthorizationStatusAuthorized:
                ret = @"Authorized";
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                ret = @"Denied";
                break;
            case AVAuthorizationStatusNotDetermined:
                ret = @"NotDetermined";
                break;
            default:
                break;
        }
        SendUnityMsg(@"CheckPermissionCallBack", permission, ret);
    } else if([permission isEqualToString:@"Photos"]){        // 相册
        if (@available(iOS 8, *)) {
            PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
            switch (photoAuthorStatus) {
                case PHAuthorizationStatusAuthorized:
                    ret = @"Authorized";
                    break;
                case PHAuthorizationStatusDenied:
                case PHAuthorizationStatusRestricted:
                    ret = @"Denied";
                    break;
                case PHAuthorizationStatusNotDetermined:
                    ret = @"NotDetermined";
                    break;
                default:
                    break;
            }
            SendUnityMsg(@"CheckPermissionCallBack", permission, ret);
        }
    } else if([permission isEqualToString:@"Microphone"]){        // 麦克风
        if (@available(iOS 8, *)) {
            AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
            switch (permissionStatus) {
                case AVAudioSessionRecordPermissionGranted:
                    ret = @"Authorized";
                    break;
                case AVAudioSessionRecordPermissionDenied:
                    ret = @"Denied";
                    break;
                case AVAudioSessionRecordPermissionUndetermined:
                    ret = @"NotDetermined";
                    break;
                default:
                    break;
            }
            SendUnityMsg(@"CheckPermissionCallBack", permission, ret);
        }
    } else if([permission isEqualToString:@"Network"]){        // 检测应用中是否有联网权限
        if (@available(iOS 9, *)) {
            CTCellularData *cellularData = [[CTCellularData alloc] init];
            cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
                switch (state) {
                    case kCTCellularDataRestricted:
                        ret = @"Denied";
                        break;
                    case kCTCellularDataNotRestricted:
                        ret = @"Authorized";
                        break;
                    case kCTCellularDataRestrictedStateUnknown:
                        ret = @"Denied";
                        break;
                    default:
                        break;
                }
                SendUnityMsg(@"CheckPermissionCallBack", permission, ret);
            };
        }
    }
}

void _ReqPermission(const char* string){
    static NSString *ret = @"None";
    NSString *permission = [NSString stringWithUTF8String:string];
    if([permission isEqualToString:@"Location"]){        // 位置
        CLLocationManager *manager = [[CLLocationManager alloc] init];
        [manager requestWhenInUseAuthorization];//使用的时候获取定位信息
        SendUnityMsg(@"RequestPermissionCallBack", permission, @"Denied");
    }
    else if([permission isEqualToString:@"Notification"]){        // 推送
        if (@available(iOS 10, *)){
            UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
            SendUnityMsg(@"RequestPermissionCallBack", permission, @"Denied");
        }
    } else if([permission isEqualToString:@"Camera"]){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                ret = @"Authorized";
            } else{
                ret = @"Denied";
            }
            SendUnityMsg(@"RequestPermissionCallBack", permission, ret);
        }];
    } else if([permission isEqualToString:@"Photos"]){
        if (@available(iOS 8, *)) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                switch (status) {
                    case PHAuthorizationStatusNotDetermined:
                        ret = @"NotDetermined";
                        break;
                    case PHAuthorizationStatusRestricted:
                    case PHAuthorizationStatusDenied:
                        ret = @"Denied";
                        break;
                    case PHAuthorizationStatusAuthorized:
                        ret = @"Authorized";
                        break;
                    default:
                        break;
                }
                SendUnityMsg(@"RequestPermissionCallBack", permission, ret);
            }];
        }
    } else if([permission isEqualToString:@"Microphone"]){
        if (@available(iOS 8, *)) {
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (granted) {
                    ret = @"Authorized";
                } else{
                    ret = @"Denied";
                }
                SendUnityMsg(@"RequestPermissionCallBack", permission, ret);
            }];
        }
    } else if([permission isEqualToString:@"Network"]){
        SendUnityMsg(@"RequestPermissionCallBack", permission, @"Authorized");
    }
}

void _OpenSettingPermission(){
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

void _NativeToast(const char* string){
    NSString *str = [NSString stringWithUTF8String:string];
    [ToastView showToast:str withDuration:2.0];
}

void _QuitApplication(){
    exit(0);
}

char* cStringCopy(const char* string){
    if (string == NULL)
    return NULL;
    
    char* res = (char*)malloc(strlen(string) + 1);
    strcpy(res, string);
    
    return res;
}

}
