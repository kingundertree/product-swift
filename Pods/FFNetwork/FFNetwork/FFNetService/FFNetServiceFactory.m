//
//  FFNetServiceFactory.m
//  FFMusic
//
//  Created by xiazer on 14/10/21.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "FFNetServiceFactory.h"
#import "FFNetWorkingHeader.h"
#import "FFHomeFreshFresh.h"
#import "FFFlashBuyService.h"
#import "FFFresh2014HomeService.h"

@interface FFNetServiceFactory ()
@property(nonatomic, strong) NSMutableDictionary *serviceStorage;
@end

@implementation FFNetServiceFactory

- (NSMutableDictionary *)serviceStorage{
    if (!_serviceStorage) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    
    return _serviceStorage;
}

+ (id)shareInstance{
    static dispatch_once_t pred;
    static FFNetServiceFactory *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[FFNetServiceFactory alloc] init];
    });
    return sharedInstance;
}

- (FFNetService<FFNetServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier{
    if (!self.serviceStorage[identifier]) {
        self.serviceStorage[identifier] = [self newServiceWithIdentify:identifier];
    }
    
    return self.serviceStorage[identifier];
}

- (FFNetService<FFNetServiceProtocal> *)newServiceWithIdentify:(NSString *)identify{
    if ([identify isEqualToString:FFNetworkingGetServiceIDForFreshFresh] || [identify isEqualToString:FFNetworkingPostServiceIDForFreshFresh]) {
        return [[FFHomeFreshFresh alloc] init];
    } else if ([identify isEqualToString:FFNetworkingGetServiceIDForFlashBuy] || [identify isEqualToString:FFNetworkingPostServiceIDForFlashBuy]) {
        return [[FFFlashBuyService alloc] init];
    } else if ([identify isEqualToString:FFNetworkingGetServiceIDForFresh2014] || [identify isEqualToString:FFNetworkingPostServiceIDForFresh2014]) {
        return [[FFFresh2014HomeService alloc] init];
    }

    return nil;
}


@end
