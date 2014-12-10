//
//  AdaptationSize.m
//  PEM
//
//  Created by tianj on 14-9-18.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "AdaptationSize.h"

@implementation AdaptationSize


+(CGSize)getSizeFromString:(NSString *)str Font:(UIFont *)font withHight:(CGFloat)height withWidth:(CGFloat)width
{
    CGSize size;
    if (IsIos7) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    }else{
        size = [str sizeWithFont:font constrainedToSize:CGSizeMake(width, height)];
    }
    
    return size;
}






@end
