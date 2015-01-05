//
//  AddressCell.h
//  menuOrder
//
//  Created by YY on 14-12-12.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property (copy, nonatomic)  UILabel *nameLabel;
@property (copy, nonatomic)  UILabel *numberLabel;
@property (copy, nonatomic)  UILabel *addressLabel;
@property (copy, nonatomic)  UIButton *delegateBtn;
@property (copy, nonatomic)  UIView *lineView;


@end
