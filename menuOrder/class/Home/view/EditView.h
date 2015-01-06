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

#define KEditStartTag 200
typedef enum {
    EditNum = 1,
    EditText = 2,
    EditTime = 3,
    EditAddress
} EditType;

@class EditView;
@protocol EditViewDelegate <NSObject>

@optional
- (void)updateHilightStatus:(EditView *)view withTextfield:(UITextField *)field;//更新点亮状态

- (void)textshouleBeginEditting:(EditView *)view :(UITextField *)textField withstring:(NSString *)str;
- (void)textFieldBeganEditting:(EditView *)view :(UITextField *)textField;
- (void)textFieldEndEditting:(EditView *)view :(UITextField *)textField;
@end

@interface EditView : UIView<UITextFieldDelegate>
@property (nonatomic, strong) UIView *line; //竖线
@property (nonatomic, strong) UIImageView *cricle; //圆圈图片
@property (nonatomic, strong) UITextField *edit;//编辑
@property (nonatomic, assign) int editTag;//自己的tag
@property (nonatomic, assign) bool isTime;//是否是时间控件
@property (nonatomic, weak) id<EditViewDelegate> delegate;
@property (nonatomic, assign) EditType edtype;
@property (nonatomic,strong) UITextField *selectedText;

-(void)addEditView:(int )index placeHoldString:(NSString *)holdString editIcon:(NSString *)icon editType:(EditType )editType;
@end
