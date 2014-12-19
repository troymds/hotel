//
//  phoneView.h
//  PEM
//
//  Created by YY on 14-9-18.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface phoneView : NSObject

typedef void (^ACETelCallBlock)(NSTimeInterval duration);
typedef void (^ACETelCancelBlock)(void);
typedef void (^ACETelBackBlock)(void);

+ (BOOL)callPhoneNumber:(NSString *)phoneNumber
                   call:(ACETelCallBlock)callBlock
                 cancel:(ACETelCancelBlock)cancelBlock finish:(ACETelBackBlock)backBlock;

@end
