//
//  AdaptationSize.h
//  PEM
//
//  Created by tianj on 14-9-18.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdaptationSize : NSObject

+(CGSize)getSizeFromString:(NSString *)str Font:(UIFont *)font withHight:(CGFloat)height withWidth:(CGFloat)width;


@end
