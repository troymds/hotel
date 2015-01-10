//
//  EditView.m
//  menuOrder
//  预约编辑栏
//  Created by promo on 14-12-17.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "EditView.h"
#import "ZHPickView.h"

@interface EditView()<ZHPickViewDelegate>{
    UITextField *oldField;
    UIView *babaView;
}

@property (nonatomic,assign)  NSInteger oldEditTag;
@property (nonatomic,strong)  ZHPickView *pickview;
@end
@implementation EditView

-(void)addEditView:(int )index placeHoldString:(NSString *)holdString editIcon:(NSString *)icon editType:(EditType )editType
{
    self.oldEditTag = KEditStartTag + index;
    [[NSUserDefaults standardUserDefaults] setInteger:self.oldEditTag forKey:@"oldUItext"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.edtype = editType;
    //1 竖线
    //当第一个线，减半
    CGFloat lineY ;
    CGFloat lineH ;
    if (index == 1) {
       lineY = KLineH / 2 - 5;
        lineH = KLineH / 2 + 5;
    }else
    {
        lineY = 0;
        lineH = KLineH;
    }
    UIView *line = [[UIView alloc] init];
    CGFloat lineX = KEditLeftX + KEditCircleW/2;
    CGFloat lineW = 1;
    line.frame = Rect(lineX, lineY, lineW, lineH);
    line.backgroundColor = HexRGB(0xd8d8d8);
    [self addSubview:line];
    _line = line;
    
    //2 圆圈
    UIImageView *circle = [[UIImageView alloc] init];
    CGFloat circleX = KEditLeftX;
    CGFloat circleY = KLineH + 5;
    circle.frame = Rect(circleX, circleY, KEditCircleW, KEditCircleW);
    NSString *circleName = [NSString stringWithFormat:@"%d",index];
    circle.image = LOADPNGIMAGE(circleName);
    [self addSubview:circle];
    _cricle = circle;
    
    //3  textField
    UITextField *edit = [[UITextField alloc] init];

    CGFloat editX = CGRectGetMaxX(circle.frame) + KEditLeftX * 2;
    CGFloat editY = KLineH;
    CGFloat editW = kWidth - editX - KEditLeftX;
    CGFloat editH = 30;
    edit.frame = Rect(editX, editY, editW, editH);
    
    if (editType == EditNum) {
        edit.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:edit];
    }else if (editType == EditAddress)
    {
        [self addSubview:edit];
        //后面加地址button
        UIButton *addressSelecte = [UIButton buttonWithType:UIButtonTypeCustom];
        [addressSelecte setBackgroundImage:LOADPNGIMAGE(@"输入送餐地址") forState:UIControlStateNormal];
        [addressSelecte setBackgroundImage:LOADPNGIMAGE(@"输入送餐地址_pre") forState:UIControlStateHighlighted];
        addressSelecte.frame = Rect(kWidth - 100, editY, 74, editH);
        [addressSelecte addTarget:self action:@selector(addaddress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addressSelecte];
    }else if(editType == EditTime)
    {
        ////        [_pickview remove];
        NSDate *date = [NSDate date];
        _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
        _pickview.delegate = self;
        _pickview.translatesAutoresizingMaskIntoConstraints = NO;
        
        edit.inputView = _pickview;
        [self addSubview:edit];
    }else
    {
        [self addSubview:edit];
    }

    
    edit.tag  = KEditStartTag + index;
    _edit = edit;
    edit.delegate = self;
    edit.returnKeyType = UIReturnKeyDone;
    edit.clearButtonMode = UITextFieldViewModeWhileEditing;
    edit.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:LOADPNGIMAGE(icon)];
    edit.leftView = leftImg;
    edit.leftViewMode = UITextFieldViewModeAlways;
    edit.placeholder = holdString;
    
}

-(void)addaddress
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"address" object:nil];
}

#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _selectedText  = textField;
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    _selectedText = textField;
    if ([self.delegate respondsToSelector:@selector(textshouleBeginEditting::withstring:)]) {
        [self.delegate textshouleBeginEditting:self :_selectedText withstring:string];
    }
    
    if(self.edtype == EditTime)
    {//显示时间时，禁止输入
        return NO;
    }else
    {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _selectedText = textField;
    _pickview.hidden = NO;
    if ([self.delegate respondsToSelector:@selector(textFieldBeganEditting::)]) {
        [self.delegate textFieldBeganEditting:self :_selectedText];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _selectedText = textField;
    if ([self.delegate respondsToSelector:@selector(textFieldEndEditting::)]) {
        [self.delegate textFieldEndEditting:self :_selectedText];
    }
}

#pragma mark ZhpickVIewDelegate 时间选择器
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString timestamp:(NSString *)timestamp{
    _selectedText.text = resultString;
    [_selectedText resignFirstResponder];
//    pickView.hidden = YES;
    if ([_delegate respondsToSelector:@selector(updateHilightStatus:withTextfield:)]) {
        [_delegate updateHilightStatus:self withTextfield:_selectedText];
    }
}

@end
