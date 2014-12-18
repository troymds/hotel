//
//  address_addView.h
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface address_addView : UIViewController<UITextFieldDelegate>
{
    UIView *backView;
}
@property(nonatomic ,retain)UITextField *nameField;
@property(nonatomic ,copy)NSString *nameStr;
@property(nonatomic ,copy)NSString *telStr;
@property(nonatomic ,copy)NSString *addressStr;


@end
