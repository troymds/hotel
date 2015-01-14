//
//  menu3EditView.h
//  menuOrder
//
//  Created by promo on 14-12-29.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditView.h"

#define KEditLeftX 20
#define KLineH 30
#define KEditCircleW 18

#define KNameEdit 201
#define KPhoneEdit 202
#define KPersonsEdit 203
#define KTimeEdit 204
#define KOthersEdit 205

#define KEditStartTag 200

@class menu3EditView;
@protocol menu3Delegate <NSObject>

@optional

-(void)menu3EditView:(menu3EditView *)view withArray:(NSArray *)array;
@end


@interface menu3EditView : UIView<EditViewDelegate,menu3Delegate>
@property (nonatomic, strong) UIView *line; //竖线
@property (nonatomic, strong) UIImageView *cricle; //圆圈图片
@property (nonatomic, strong) UITextField *edit;//编辑
@property (nonatomic, assign) int editTag;//自己的tag
@property (nonatomic, assign) bool isTime;//是否是时间控件
@property (nonatomic, weak) id<EditViewDelegate> delegate;
@property (nonatomic, weak) id<menu3Delegate> delegate2;
@property (nonatomic, strong) UIScrollView *backScroll; //最底层的ScrollView
@property (nonatomic, assign) CGFloat contentHeight;//动态高度
@end
