//
//  menu3EditView.m
//  menuOrder
//  外卖服务编辑页面
//  Created by promo on 14-12-29.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "menu3EditView.h"
#import "ZHPickView.h"
#import "AddressView.h"
#import "subscribeViewViewController.h"
#import "addressListModel.h"
#import "SystemConfig.h"

#define KRightOffset        20

@interface menu3EditView ()<UIScrollViewDelegate,EditViewDelegate>
{
    EditType editType;
    CGFloat keyBoardH;//键盘高度
    UITextField *_selectedField;
    BOOL isSelectedAddress;//是否已经选取了地址
}
@property(nonatomic,strong)ZHPickView *pickview;
-(void)buileEditView:(NSArray *)placeHolds icons:(NSArray *)icons;

@end


@implementation menu3EditView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //底部UIScrollView
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"update" object:nil];
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
        backScroll.contentSize = CGSizeMake(kWidth, frame.size.height);
        
        NSArray *placeHolds = @[@"地址",@"送达时间",@"其他就餐要求(选填)"];
        NSArray *icons = @[@"home_address_icon",@"home_time_icom",@"home_remark_icon"];
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
        CGFloat editY = (editH + 10)* i - 15;
        EditView * edit = [[EditView alloc] initWithFrame:Rect(0, editY, editW, editH)];
        
        
        if (i == 0) {
            edit.edtype = EditAddress;

        }else if(i == 1)
        {
            edit.edtype = EditTime;
        }else if (i == 2)
        {
        }
        [edit addEditView:i+1 placeHoldString:placeHolds[i] editIcon:icons[i] editType:edit.edtype];

        edit.delegate = self;
        edit.editTag = KEditStartTag + i + 1;
        [_backScroll addSubview:edit];
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

-(void)builEditView:(NSArray *)placeHolds icons:(NSArray *)icons withaddressData:(addressListModel *)address
{
    isSelectedAddress = YES;
    CGFloat editW = kWidth - KRightOffset;
    CGFloat editH = 50;
    CGFloat h = 0.0;
    NSUInteger count = [placeHolds count];
    
    for (int i = 0; i < count; i++) {
        
        //1.1 编辑框
        CGFloat editY = (editH + 10)* i - 15;;
        EditView * edit = [[EditView alloc] initWithFrame:Rect(0, editY, editW, editH)];
        [_backScroll addSubview:edit];
        
        if (i == 2) {
            edit.edtype = EditAddress;
            [edit addEditView:i+1 placeHoldString:placeHolds[i] editIcon:placeHolds[i] editType:edit.edtype];
            edit.edit.text = address.content;
        }else if(i == 3)
        {
            edit.edtype = EditTime;
            [edit addEditView:i+1 placeHoldString:placeHolds[i] editIcon:placeHolds[i] editType:edit.edtype];
        }else if (i == 1)
        {
            edit.edtype = EditNum;
            [edit addEditView:i+1 placeHoldString:placeHolds[i] editIcon:placeHolds[i] editType:edit.edtype];
            edit.edit.text = address.tel;
        }else if (i == 0)
        {
            [edit addEditView:i+1 placeHoldString:placeHolds[i] editIcon:placeHolds[i] editType:edit.edtype];
            edit.edit.text = address.contact;
        }else
        {
            [edit addEditView:i+1 placeHoldString:placeHolds[i] editIcon:placeHolds[i] editType:edit.edtype];
        }
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
        [self updateHilightStatus:edit withTextfield:edit.edit];
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

#pragma mark 准备选餐
- (void)choseArddress
{
    if ([_delegate2 respondsToSelector:@selector(startChoseAddress)]) {
        [_delegate2 startChoseAddress];
    }
}

#pragma mark 增加姓名和电话，地址
-(void)upDateAddress:(addressListModel *)address
{
    addressListModel * data = address;
    
    [_backScroll removeFromSuperview];
    UIScrollView *backScroll = [[UIScrollView alloc] initWithFrame:Rect(0, 0, kWidth, KBackScroolViewH)];
    [self addSubview:backScroll];
    _backScroll = backScroll;
    backScroll.showsHorizontalScrollIndicator = NO;
    backScroll.showsVerticalScrollIndicator = NO;
    backScroll.pagingEnabled = NO;
    backScroll.bounces = NO;
    backScroll.scrollEnabled = YES;
    backScroll.userInteractionEnabled = YES;
    backScroll.delegate = self;
    backScroll.contentSize = CGSizeMake(kWidth, KBackScroolViewH);
    NSArray *placeHolds = @[@"姓名",@"联系电话",@"地址",@"送达时间",@"其他就餐要求(选填)"];
    NSArray *icons = @[@"home_contacts_icon",@"home_phone_icon",@"home_address_icon",@"home_time_icom",@"home_remark_icon"];
    
    [self builEditView:placeHolds icons:icons withaddressData:data];
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
                    NSString *lightImg = [NSString stringWithFormat:@"%d_pre",editView.editTag - KEditStartTag];
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
                        [_backScroll setContentOffset:CGPointMake(0, editViewY + 15) animated:YES];
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
                NSString *lightImg = [NSString stringWithFormat:@"%d_pre",editview.editTag - KEditStartTag];
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
                        [_backScroll setContentOffset:CGPointMake(0, editViewY + 15) animated:YES];
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
                    NSString *lightImg = [NSString stringWithFormat:@"%d_pre",editview.editTag - KEditStartTag];
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
                    NSString *lightImg = [NSString stringWithFormat:@"%d_pre",editview.editTag - KEditStartTag];
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
    [UIView animateWithDuration:0.6 animations:^{
        [_backScroll setContentSize:CGSizeMake(kWidth, _contentHeight)];
        [_backScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}

- (BOOL)isValidPhoneNum:(NSString *)phoneNum{
    NSString *phoneRegex  =  @"((0\\d{2,3}-\\d{7,8})|(^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0-9]))\\d{8}))$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNum];
}

-(void)summitDeal
{
    NSMutableArray *data = [NSMutableArray array];
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
    // 判断是否可以提交,只有至少填了4项
    if (data.count >= 4) {
        BOOL isnull = NO;// 是否为空
        BOOL isValidPhone = YES;//是否是正确的手机号
        BOOL isNameLengthEnough = YES;//名称长度要>=2
        for (int i = 0; i < 4; i++) {
            NSString *str = data[i];
            
            if (i == 0) {
                if(str.length < 2)
                {
                    isNameLengthEnough = NO;
                }
            }
            
            if (i == 1) {
                if (![self isValidPhoneNum:str]) {//错误的手机号
                    isValidPhone = NO;
                    break;
                }
            }
            if (str.length == 0) {
                //不能提交
                isnull = YES;
                break;
            }
        }
        if (!isnull && isValidPhone && isNameLengthEnough) {
            [SystemConfig sharedInstance].menuType = 2;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"submit" object:data];
            if ([_delegate2 respondsToSelector:@selector(menu3EditView:withArray:)]) {
                [_delegate2 menu3EditView:self withArray:data];
            }
        }else
        {
            if (!isNameLengthEnough) {
                [RemindView showViewWithTitle:@"请将姓名填写完整，亲！" location:MIDDLE];
            }
            else if (!isValidPhone) {
                [RemindView showViewWithTitle:@"请输入正确的手机号，亲！" location:MIDDLE];
            }else
            {
                [RemindView showViewWithTitle:@"请填写完信息，亲！" location:MIDDLE];
            }
        }
    }else
    {
        [RemindView showViewWithTitle:@"请填写完信息，亲！" location:MIDDLE];
    }
}
@end
