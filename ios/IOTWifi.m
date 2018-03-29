#import "IOTWifi.h"
#if !TARGET_OS_SIMULATOR
#import <NetworkExtension/NetworkExtension.h>
#endif
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation IOTWifi
    RCT_EXPORT_MODULE();
    RCT_EXPORT_METHOD(isAvaliable:(RCTResponseSenderBlock)callback) {
#if TARGET_OS_SIMULATOR
        callback(@[@NO]);
#else
        NSNumber *available = @NO;
        if (@available(iOS 11.0, *)) {
            available = @YES;
        }
        callback(@[available]);
#endif
    }
    
#if !TARGET_OS_SIMULATOR
    RCT_EXPORT_METHOD(connect:(NSString*)ssid
                      lifeTimeInDays:(nonnull NSNumber*)lifeTimeInDays
                      joinOnce:(BOOL)joinOnce   
                      callback:(RCTResponseSenderBlock)callback) {
        if (@available(iOS 11.0, *)) {
            NEHotspotConfiguration* configuration = [[NEHotspotConfiguration alloc] initWithSSID:ssid];
            configuration.joinOnce = joinOnce;
            configuration.lifeTimeInDays = lifeTimeInDays;
            
            [[NEHotspotConfigurationManager sharedManager] applyConfiguration:configuration completionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    callback(@[@"Error while configuring WiFi"]);
                } else {
                    callback(@[[NSNull null]]);
                }
            }];
            
        } else {
            callback(@[@"Not supported in iOS<11.0"]);
        }
    }
    
    RCT_EXPORT_METHOD(forceWifiUsage:(BOOL)force) {
    }
    
    RCT_EXPORT_METHOD(connectSecure:(NSString*)ssid
                      withPassphrase:(NSString*)passphrase
                      isWEP:(BOOL)isWEP
                      lifeTimeInDays:(nonnull NSNumber*)lifeTimeInDays
                      joinOnce:(BOOL)joinOnce   
                      callback:(RCTResponseSenderBlock)callback) {
        
        if (@available(iOS 11.0, *)) {
            NEHotspotConfiguration* configuration = [[NEHotspotConfiguration alloc] initWithSSID:ssid passphrase:passphrase isWEP:isWEP];
            configuration.joinOnce = joinOnce;
            configuration.lifeTimeInDays = lifeTimeInDays;
            
            [[NEHotspotConfigurationManager sharedManager] applyConfiguration:configuration completionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    callback(@[@"Error while configuring WiFi"]);
                } else {
                    callback(@[[NSNull null]]);
                }
            }];
            
        } else {
            callback(@[@"Not supported in iOS<11.0"]);
        }
    }
    
    RCT_EXPORT_METHOD(removeSSID:(NSString*)ssid
                      callback:(RCTResponseSenderBlock)callback) {
        
        if (@available(iOS 11.0, *)) {
            [[NEHotspotConfigurationManager sharedManager] getConfiguredSSIDsWithCompletionHandler:^(NSArray<NSString *> *ssids) {
                if (ssids != nil && [ssids indexOfObject:ssid] != NSNotFound) {
                    [[NEHotspotConfigurationManager sharedManager] removeConfigurationForSSID:ssid];
                }
                callback(@[[NSNull null]]);
            }];
        } else {
            callback(@[@"Not supported in iOS<11.0"]);
        }
        
    }
    
    RCT_REMAP_METHOD(getSSID,
                     callback:(RCTResponseSenderBlock)callback) {
        
        NSString *kSSID = (NSString*) kCNNetworkInfoKeySSID;
        
        NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
        for (NSString *ifnam in ifs) {
            NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            NSString *ssid = info[kSSID];
            if (ssid) {
                callback(@[ssid]);
                return;
            }
        }
        
        callback(@[@"Cannot detect SSID"]);
    }
    
    RCT_EXPORT_METHOD(useWifiRequests:(BOOL)useRequests
                      resolver:(RCTPromiseResolveBlock)resolve
                      rejecter:(RCTPromiseRejectBlock)reject) {
        resolve([NSNumber numberWithBool:false]);
    }
    
    RCT_EXPORT_METHOD(request:(NSString*)urlString
                      resolver:(RCTPromiseResolveBlock)resolve
                      rejecter:(RCTPromiseRejectBlock)reject) {
        reject(@"no_implementation", @"There are no implementation on iOS", [NSError errorWithDomain:@"com.iotwifi" code:-1 userInfo:nil]);
    }
    
#endif
    @end

