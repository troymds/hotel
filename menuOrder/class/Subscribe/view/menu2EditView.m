//
//  menu2EditView.m
//  menuOrder
//  外带取餐编辑页面
//  Created by promo on 14-12-29.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "menu2EditView.h"
#import "EditView.h"
#import "ZHPickView.h"

#define KRightOffset        20

@interface menu2EditView ()<UIScrollViewDelegate,EditViewDelegate>
{
    EditType editType;
    CGFloat keyBoardH;//键盘高度
    UITextField *_selectedField;
}
@property(nonatomic,strong)ZHPickView *pickview;
-(void)buileEditView:(NSArray *)placeHolds icons:(NSArray *)icons;

@end

@implementation menu2EditView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //底部UIScrollView
        
        UIScrollView *backScroll = [[UIScrollView alloc] initWithFrame:Rect(0, 0, kWidth, frame.size.height)];
        [self addSubview:backScroll];
        _backScroll = backScroll;
        backScroll.showsHorizontalScrollIndicator = NO;
        backScroll.showsVerticalScrollIndicator = NO;
        backScroll.pagingEnabled = NO;
        backScroll.bounces = NO;
        backScroll.scrollEnabled = YES;
        backScroll.userInteractionEnabled = YES;
        backScroll.delegate = self;
        //        backScroll.tag = 9999;
        backScroll.contentSize = CGSizeMake(kWidth, frame.size.height);
        
        NSArray *placeHolds = @[@"姓名",@"联系电话",@"就餐时间",@"其他就餐要求(选填)",];
        NSArray *icons = @[@"home_contacts_icon",@"home_phone_icon",@"home_time_icom",@"home_remark_icon"];
        
        [self buileEditView:placeHolds icons:icons];
    }
    return self;
}

-(void)buileEditView:(NSArray *)placeHolds icons:(NSArray *)icons
{
    CGFloat editW = kWidth - KRightOffset;
    CGFloat editH = 50;
    CGFloat h = 0.0;
    NSUInteger count = [placeHolds count];
    for (int i = 0; i < count; i++) {
        
        //1.1 编辑框
        CGFloat editY = (editH + 10)* i;
        EditView * edit = [[EditView alloc] initWithFrame:Rect(0, editY, editW, editH)];
        [_backScroll addSubview:edit];
        if (i == 1) {
            editType = EditNum;
        }else if(i == 2)
        {
            editType = EditTime;
        }else
        {
            editType = EditText;
        }
        [edit addEditView:i+1 placeHoldString:placeHolds[i] editIcon:icons[i] editType:editType];

        edit.delegate = self;
        edit.editTag = KEditStartTag + i + 1;
        
        //1.2 线框
        CGFloat lineFrameX = KEditLeftX * 2 + KEditCircleW;
        CGFloat lineFrameW = kWidth - lineFrameX - KRightOffset;
        CGFloat lineFrameY = editY + (editH + 10);
        UIImageView *lineFrame = [[UIImageView alloc] initWithFrame:Rect(0 + lineFrameX, lineFrameY, lineFrameW, 4)];
        lineFrame.image = LOADPNGIMAGE(@"enter");
        lineFrame.tag = KEditStartTag + i + 1;
        [_backScroll addSubview:lineFrame];
        if (i == (count - 1)) {
            h  = CGRectGetMaxY(lineFrame.frame);
        }
    }
    //3 提交订单
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.tag = 300;
    [submit setBackgroundImage:LOADPNGIMAGE(@"submit_ok_pre") forState:UIControlStateHighlighted];
    [submit setBackgroundImage:LOADPNGIMAGE(@"submit_ok") forState:UIControlStateNormal];
    submit.frame = Rect(KRightOffset + 5, h + 30, kWidth - KRightOffset * 2, 40);
    [_backScroll addSubview:submit];
    [submit addTarget:self action:@selector(summitDeal) forControlEvents:UIControlEventTouchUpInside];
    _contentHeight = CGRectGetMaxY(submit.frame) + 70;
    _backScroll.contentSize = CGSizeMake(kWidth, _contentHeight);

}

#pragma mark textField 点击return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mrak 正在编辑中
- (void)textshouleBeginEditting:(EditView *)view :(UITextField *)textField withstring:(NSString *)str
{
    _selectedField = textField;
    //根据textField的tag拿到EditView
    for (UIView *view in _backScroll.subviews ) {
        if ([view isKindOfClass:[EditView class]]) {
            EditView *editView = (EditView *)view;
            if (textField.tag == editView.editTag) {
                
                //只要str 或者field有值，则点亮圆圈和线框
                if (str.length > 0 || textField.text.length > 0) {
                    // 圆圈
                    NSString *lightImg = [NSString stringWithFormat:@"%d.pre",editView.editTag - KEditStartTag];
                    editView.cricle.image = LOADPNGIMAGE(lightImg);
                    //线框
                    for (UIView *view in _backScroll.subviews) {
                        if ([view isKindOfClass:[UIImageView class]]) {
                            UIImageView *frame = (UIImageView *)view;
                            if (frame.tag == editView.editTag) {
                                frame.image = LOADPNGIMAGE(@"enter_pre");
                            }
                        }
                    }
                }else
                {
                    NSString *darkImg = [NSString stringWithFormat:@"%d",editView.editTag - KEditStartTag];
                    editView.cricle.image = LOADPNGIMAGE(darkImg);
                    //线框
                    for (UIView *view in _backScroll.subviews) {
                        if ([view isKindOfClass:[UIImageView class]]) {
                            UIImageView *frame = (UIImageView *)view;
                            if (frame.tag == editView.editTag) {
                                frame.image = LOADPNGIMAGE(@"enter");
                            }
                        }
                    }
                }
                //选择后，改变位置
                CGFloat editViewY = editView.frame.origin.y;
                
                [UIView animateWithDuration:0.25 animations:^{
                    if (textField.tag == 201) {
                        [_backScroll setContentOffset:CGPointMake(0, editViewY) animated:YES];
                    }else{
                        [_backScroll setContentOffset:CGPointMake(0, editViewY - 30) animated:YES];
                    }
                    
                    [_backScroll setContentSize:CGSizeMake(kWidth, _contentHeight + 253)];
                } completion:^(BOOL finished) {
                }];
                break;
            }
        }
    }
}

#pragma mark 开始编辑
- (void)textFieldBeganEditting:(EditView *)view :(UITextField *)textField
{
    _selectedField = textField;

    //根据textField的tag拿到EditView
    for (UIView *view in _backScroll.subviews ) {
        if ([view isKindOfClass:[EditView class]]) {
            EditView *editview = (EditView *)view;

            UITextField *field = editview.edit;
            if (field.text.length > 0) {
                // 圆圈
                NSString *lightImg = [NSString stringWithFormat:@"%d.pre",editview.editTag - KEditStartTag];
                editview.cricle.image = LOADPNGIMAGE(lightImg);
                //线框
                for (UIView *view in _backScroll.subviews) {
                    if ([view isKindOfClass:[UIImageView class]]) {
                        UIImageView *frame = (UIImageView *)view;
                        if (frame.tag == editview.editTag ) {
                            frame.image = LOADPNGIMAGE(@"enter_pre");
                        }
                    }
                }
            }else
            {
                NSString *lightImg = [NSString stringWithFormat:@"%d",editview.editTag - KEditStartTag];
                editview.cricle.image = LOADPNGIMAGE(lightImg);
                
                //线框
                for (UIView *view in _backScroll.subviews) {
                    if ([view isKindOfClass:[UIImageView class]]) {
                        UIImageView *frame = (UIImageView *)view;
                        if (frame.tag == editview.editTag) {
                            frame.image = LOADPNGIMAGE(@"enter");
                        }
                    }
                }
            }
            for (UIView *view in _backScroll.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    UIImageView *frame = (UIImageView *)view;
                    if (frame.tag == _selectedField.tag) {
                        frame.image = LOADPNGIMAGE(@"enter_pre");
                    }
                }
            }
            
            //选择后，改变位置
            if (editview.editTag == textField.tag) {
                CGFloat editViewY = editview.frame.origin.y;
                
                [UIView animateWithDuration:0.25 animations:^{
                    if (textField.tag == 201) {
                        [_backScroll setContentOffset:CGPointMake(0, editViewY) animated:YES];
                    }else{
                        [_backScroll setContentOffset:CGPointMake(0, editViewY - 30) animated:YES];
                    }
                    
                    [_backScroll setContentSize:CGSizeMake(kWidth, _contentHeight + 253)];
                } completion:^(BOOL finished) {
                }];
            }
        }
    }
}

#pragma mark  结束编辑
- (void)textFieldEndEditting:(EditView *)view :(UITextField *)textField
{
    _selectedField = textField;
    //收回键盘
    [textField resignFirstResponder];
    //点亮圆圈和线框
    for (UIView *view in _backScroll.subviews ) {
        if ([view isKindOfClass:[EditView class]]) {
            EditView *editview = (EditView *)view;
            
            if (textField.tag == editview.editTag) {
                UITextField *field = editview.edit;
                if (field.text.length > 0) {
                    // 圆圈
                    NSString *lightImg = [NSString stringWithFormat:@"%d.pre",editview.editTag - KEditStartTag];
                    editview.cricle.image = LOADPNGIMAGE(lightImg);
                    //线框
                    for (UIView *view in _backScroll.subviews) {
                        if ([view isKindOfClass:[UIImageView class]]) {
                            UIImageView *frame = (UIImageView *)view;
                            if (frame.tag == editview.editTag ) {
                                frame.image = LOADPNGIMAGE(@"enter_pre");
                            }
                        }
                    }
                }else
                {
                    NSString *lightImg = [NSString stringWithFormat:@"%d",editview.editTag - KEditStartTag];
                    editview.cricle.image = LOADPNGIMAGE(lightImg);
                    
                    //线框
                    for (UIView *view in _backScroll.subviews) {
                        if ([view isKindOfClass:[UIImageView class]]) {
                            UIImageView *frame = (UIImageView *)view;
                            if (frame.tag == editview.editTag) {
                                frame.image = LOADPNGIMAGE(@"enter");
                            }
                        }
                    }
                }
            }
            //选择后，改变位置
            if (editview.editTag == textField.tag) {
                CGFloat editViewY = editview.frame.origin.y;
                
                [UIView animateWithDuration:0.25 animations:^{
                    if (textField.tag == 201) {
                        [_backScroll setContentOffset:CGPointMake(0, editViewY) animated:YES];
                    }else{
                        [_backScroll setContentOffset:CGPointMake(0, editViewY - 30) animated:YES];
                    }
                    
                    [_backScroll setContentSize:CGSizeMake(kWidth, _contentHeight + 253)];
                } completion:^(BOOL finished) {
                }];
            }
        }
    }
    //通知view
}

#pragma mark 收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_selectedField resignFirstResponder];
    if (_pickview) {
        [_pickview remove];
    }
    
    [UIView animateWithDuration:0.6 animations:^{
        [_backScroll setContentSize:CGSizeMake(kWidth, _contentHeight)];
        [_backScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}

#pragma mark - 键盘边框大小变化
- (void)keyboardChange:(NSNotification *)notification
{
    // 1. 获取键盘的目标区域
    NSDictionary *info = notification.userInfo;
    CGRect rect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    keyBoardH = rect.size.height;
    // 2. 根据rect的orgion.y可以判断键盘是开启还是关闭
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        // 键盘已经关闭
        [UIView animateWithDuration:duration animations:^{
            [_backScroll setContentSize:CGSizeMake(kWidth, _contentHeight)];
            [_backScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
    } else {
        // 键盘打开
    }
}

#pragma mark 点亮状态
- (void)updateHilightStatus:(EditView *)view withTextfield:(UITextField *)field
{
    //点亮圆圈和线框
    for (UIView *view in _backScroll.subviews) {
        if ([view isKindOfClass:[EditView class]]) {
            EditView *editview = (EditView *)view;
            if (editview.editTag == field.tag) {
                
                if (field.text.length > 0) {
                    // 圆圈
                    NSString *lightImg = [NSString stringWithFormat:@"%d.pre",editview.editTag - KEditStartTag];
                    editview.cricle.image = LOADPNGIMAGE(lightImg);
                    //线框
                    for (UIView *view in _backScroll.subviews) {
                        if ([view isKindOfClass:[UIImageView class]]) {
                            UIImageView *frame = (UIImageView *)view;
                            if (frame.tag == editview.editTag) {
                                frame.image = LOADPNGIMAGE(@"enter_pre");
                            }
                        }
                    }
                }
                else
                {
                    NSString *darkImg = [NSString stringWithFormat:@"%d",editview.editTag - KEditStartTag];
                    editview.cricle.image = LOADPNGIMAGE(darkImg);
                    //线框
                    for (UIView *view in _backScroll.subviews) {
                        if ([view isKindOfClass:[UIImageView class]]) {
                            UIImageView *frame = (UIImageView *)view;
                            if (frame.tag == editview.editTag) {
                                frame.image = LOADPNGIMAGE(@"enter");
                            }
                        }
                    }
                }
            }
        }
    }
}

-(void)summitDeal
{
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:5];
    for (UIView *view in _backScroll.subviews) {
        if ([view isKindOfClass:[EditView class]]) {
            EditView *vi = (EditView *)view;
            UITextField *text = vi.edit;
            if (text.text == nil) {
                text.text = @"";
            }
            [data addObject:text.text];
        }
    }
    // 判断是否可以提交
    BOOL canSubmit = YES;
    for (int i = 0; i < 3; i++) {
        NSString *str = data[i];
        if (str.length == 0) {
            //不能提交
            canSubmit = NO;
            break;
        }
    }
    if (canSubmit) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"submit" object:data];
    }else
    {
        [RemindView showViewWithTitle:@"请填写完信息，亲！" location:MIDDLE];
    }
}
@end
