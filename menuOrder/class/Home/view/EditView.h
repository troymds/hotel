//
//  EditView.h
//  menuOrder
//
//  Created by promo on 14-12-17.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KEditLeftX 20
#define KLineH 30
#define KEditCircleW 18

#define KNameEdit 201
#define KPhoneEdit 202
#define KPersonsEdit 203
#define KTimeEdit 204
#define KOthersEdit 205

@protocol EditViewDelegate <NSObject>

@optional
- (void)textFieldBeganEditting:(UITextField *)textField;

- (void)textFieldEndEditting:(UITextField *)textField;
@end

@interface EditView : UIView<UITextFieldDelegate>
@property (nonatomic, strong) UIView *line; //竖线
@property (nonatomic, strong) UIImageView *cricle; //圆圈图片
@property (nonatomic, strong) UITextField *edit;//编辑

@property (nonatomic, weak) id<EditViewDelegate> delegate;
-(void)addEditView:(int )index placeHoldString:(NSString *)holdString editIcon:(NSString *)icon;
@end
