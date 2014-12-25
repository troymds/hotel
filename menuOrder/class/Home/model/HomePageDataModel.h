//
//  HomePageDataModel.h
//  menuOrder
//  首页数据
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageDataModel : NSObject

@property (nonatomic, strong) NSArray *hotProductList; //id
@property (nonatomic, strong) NSString *adsImg; //展示图片

- (instancetype) initWithDic:(NSDictionary *)dic;

@end
