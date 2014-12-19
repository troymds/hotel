//
//  modificationAddress.h
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface modificationAddress : UIViewController<UITextFieldDelegate>
{
     UIView *backView;
}
@property(nonatomic ,retain)UITextField *updateNameField;
@property(nonatomic,retain )NSString *updateIndex;
@property(nonatomic ,copy)NSString *updateNameStr;
@property(nonatomic ,copy)NSString *updateTelStr;
@property(nonatomic ,copy)NSString *updateAddressStr;


@end
