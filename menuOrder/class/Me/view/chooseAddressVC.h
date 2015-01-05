//
//  chooseAddressVC.h
//  menuOrder
//
//  Created by YY on 14-12-31.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class addressListModel;
@protocol chooseAddressDelegate <NSObject>

@optional
- (void)passAddress:(addressListModel *)address;
@end
@interface chooseAddressVC : UIViewController
@property (nonatomic, weak)id<chooseAddressDelegate> delegate;
@end
