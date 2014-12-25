//
//  FoodCarController.h
//  menuOrder
//
//  Created by promo on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeControllerDelegate.h"

@interface FoodCarController : UIViewController<ChangeControllerDelegate>

@property (nonatomic,weak) id <ChangeControllerDelegate> delegate;
@end
