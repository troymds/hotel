//
//  XWDataModelSingleton.h
//  XinNet
//
//  Created by tianj on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserItem.h"

@interface XWDataModelSingleton : NSObject<NSCoding>

@property (nonatomic,retain)UserItem *userItem;


//保存
- (BOOL)archive;

+ (XWDataModelSingleton *)shareInstance;


@end
