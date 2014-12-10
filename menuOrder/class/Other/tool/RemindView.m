//
//  RemindView.m
//  PEM
//
//  Created by tianj on 14-9-18.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "RemindView.h"
#import "AdaptationSize.h"


@implementation RemindView

+ (void)showViewWithTitle:(NSString *)title location:(LocationType)location
{
    CGSize size = [AdaptationSize getSizeFromString:title Font:[UIFont systemFontOfSize:13] withHight:25 withWidth:CGFLOAT_MAX];
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width+15, 30)];
    CGPoint center = CGPointMake(kWidth/2, kHeight-90);
    if (location == TOP) {
        center = CGPointMake(kWidth/2, 80);
    }
    if (location == MIDDLE) {
        center = CGPointMake(kWidth/2, kHeight/2);
    }
    remindLabel.text = title;
    remindLabel.textAlignment = NSTextAlignmentCenter;
    remindLabel.font = [UIFont systemFontOfSize:13];
    remindLabel.backgroundColor = [UIColor blackColor];
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.center = center;
    [[UIApplication sharedApplication].keyWindow addSubview:remindLabel];
    [UIView animateWithDuration:3 animations:^{
        remindLabel.alpha = 0;
    }];
}



@end
