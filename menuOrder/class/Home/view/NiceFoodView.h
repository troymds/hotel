//
//  NiceFoodView.h
//  menuOrder
//
//  Created by promo on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NiceFoodModel;

typedef void(^NiceFoodViewClickedBlock)(NiceFoodModel* data);

@interface NiceFoodView : UIView

@property (nonatomic, strong) NiceFoodModel * data;
@property (nonatomic, assign) int type;//图片在左边还是右边(0:左边 1:右边)

- (id) initWithBlock:(NiceFoodViewClickedBlock)block;
@end
