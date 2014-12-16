//
//  addressListModel.h
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addressListModel : NSObject
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *addressId;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *addressUid;
- (instancetype)initWithDictionaryForAddress:(NSDictionary *)dict;

@end
