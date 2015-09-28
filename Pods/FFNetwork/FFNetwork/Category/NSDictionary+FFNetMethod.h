//
//  NSDictionary+FFNetMethod.h
//  FFMusic
//
//  Created by xiazer on 14/10/21.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FFNetMethod)
- (NSString *)FFNet_urlParamsStringSignature:(BOOL)isForSignature;
- (NSString *)FFNet_jsonString;
- (NSArray *)FFNet_transformedUrlParamsArraySignature:(BOOL)isForSignature;

@end
