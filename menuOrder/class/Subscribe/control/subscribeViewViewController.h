//
//  subscribeViewViewController.h
//  menuOrder
//
//  Created by promo on 14-12-29.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KMenuH      40
#define KBackScroolViewH KAppHeight - 44 - KMenuH
@class addressListModel;

@protocol subscribeDelefgate <NSObject>

@optional
-(void) upDateAddress:(addressListModel *)address;
@end

@interface subscribeViewViewController : UIViewController<subscribeDelefgate>
@property (nonatomic, weak) id<subscribeDelefgate> delegate;
@end
