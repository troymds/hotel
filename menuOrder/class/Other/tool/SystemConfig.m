//
//  SystemConfig.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SystemConfig.h"

@implementation SystemConfig

+ (SystemConfig *)sharedInstance{
    static SystemConfig *config = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        config = [[self alloc] init];
    });
    return config;
}

@end
