//
//  addressListModel.m
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "addressListModel.h"

@implementation addressListModel
@synthesize tel,contact,content,addressId,addressUid;
- (instancetype)initWithDictionaryForAddress:(NSDictionary *)dict{
    if ([super self ])
    {
        self.tel =dict[@"tel"];
        self.content =dict[@"content"];
        self.contact =dict[@"contact"];
        self.addressUid =dict[@"uid"];
        self.addressId =dict[@"id"];
    }
    return self;
}
@end
