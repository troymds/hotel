//
//  MenuCategory.h
//  menuOrder
//
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuCategory : NSObject
@property (nonatomic, strong) NSString *ID; // 分类ID
@property (nonatomic, strong) NSString *name; //分类名称

- (instancetype) initWithDic:(NSDictionary *)dic;
@end
