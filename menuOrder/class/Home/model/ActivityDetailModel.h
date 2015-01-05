//
//  ActivityDetailModel.h
//  menuOrder
//
//  Created by YY on 14-12-31.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityDetailModel : NSObject
@property (nonatomic, strong) NSString *content; //内容
@property (nonatomic, strong) NSString *end_date; //结束时间
@property (nonatomic, strong) NSString *start_date; //开始时间
@property (nonatomic, strong) NSString *title; //名字
@property (nonatomic, strong) NSString *cover; //美食图片


@end
