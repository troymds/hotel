//
//  ShowHotelController.h
//  menuOrder
//
//  Created by promo on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    KNext,
    KForward
} annimoType;

@interface ShowHotelController : UIViewController
@property (nonatomic, assign) annimoType type;
@end
