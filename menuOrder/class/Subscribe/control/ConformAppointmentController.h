//
//  ConformAppointmentController.h
//  menuOrder
//
//  Created by promo on 15-1-4.
//  Copyright (c) 2015年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class orderModel;

@interface ConformAppointmentController : UIViewController
@property (nonatomic,strong) orderModel* data;
@property (nonatomic, assign) int type;
@property (nonatomic,strong) NSString *oldTime;
@end
