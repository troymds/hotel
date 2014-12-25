//
//  PhotoListModel.h
//  menuOrder
//
//  Created by promo on 14-12-23.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoListModel : NSObject

@property (nonatomic, strong) NSString *img;

- (instancetype) initWithDic:(NSDictionary *)dic;
@end
