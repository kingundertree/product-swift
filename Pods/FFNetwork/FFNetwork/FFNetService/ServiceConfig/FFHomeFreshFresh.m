//
//  FFMusicForBaidu.m
//  FFMusic
//
//  Created by xiazer on 14/10/19.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "FFHomeFreshFresh.h"
#import "FFAppContext.h"

@implementation FFHomeFreshFresh

- (BOOL)isOnline
{
    return [[FFAppContext sharedInstance] isApiOnline];
}

- (NSString *)onlineApiBaseUrl
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = self.versionWithPathDic[version];
    if (versionStr && versionStr.length > 0) {
        return [NSString stringWithFormat:@"http://www.freshfresh.com/mobile/%@/index/uri/",versionStr];
    } else {
        return [NSString stringWithFormat:@"http://www.freshfresh.com/mobile/%@/index/uri/",@"1.0"];
    }
}

- (NSString *)onlineApiVersion
{
    return @"";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)onlinePublicKey
{
    return @"";;
}

- (NSString *)offlineApiBaseUrl
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = self.versionWithPathDic[version];
    if (versionStr && versionStr.length > 0) {
        return [NSString stringWithFormat:@"http://test.freshfresh.com/fresh2014/mobile/%@/index/uri/",versionStr];
    } else {
        return [NSString stringWithFormat:@"http://test.freshfresh.com/fresh2014/mobile/%@/index/uri/",@"1.0"];
    }
}

- (NSString *)offlineApiVersion
{
    return @"";
}

- (NSString *)offlinePrivateKey
{
    return @"";
}

- (NSString *)offlinePublicKey
{
    return @"";
}

@end
