//
//  EditView.m
//  menuOrder
//  预约编辑栏
//  Created by promo on 14-12-17.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "EditView.h"


@implementation EditView


-(void)addEditView:(int )index placeHoldString:(NSString *)holdString editIcon:(NSString *)icon
{
    //1 竖线
    UIView *line = [[UIView alloc] init];
    CGFloat lineX = KEditLeftX + KEditCircleW/2;
    CGFloat lineY = 0;
    CGFloat lineW = 1;
    CGFloat lineH = KLineH;
    line.frame = Rect(lineX, lineY, lineW, lineH);
    line.backgroundColor = HexRGB(0xd8d8d8);
    [self addSubview:line];
    _line = line;
    
    //2 圆圈
    UIImageView *circle = [[UIImageView alloc] init];
    CGFloat circleX = KEditLeftX;
    CGFloat circleY = CGRectGetMaxY(line.frame) + 5;
    circle.frame = Rect(circleX, circleY, KEditCircleW, KEditCircleW);
    NSString *circleName = [NSString stringWithFormat:@"%d",index];
    circle.image = LOADPNGIMAGE(circleName);
    [self addSubview:circle];
    _cricle = circle;
    
    //3  textField
    UITextField *edit = [[UITextField alloc] init];
    CGFloat editX = CGRectGetMaxX(circle.frame) + KEditLeftX * 2;
    CGFloat editY = lineH;
    CGFloat editW = kWidth - editX - KEditLeftX;
    CGFloat editH = 30;
    edit.frame = Rect(editX, editY, editW, editH);
    [self addSubview:edit];
    edit.tag  = 200 + index;
    _edit = edit;
    edit.delegate = self;
    edit.clearButtonMode = UITextFieldViewModeWhileEditing;
    edit.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:LOADPNGIMAGE(icon)];
    edit.leftView = leftImg;
    edit.leftViewMode = UITextFieldViewModeAlways;
    edit.placeholder = holdString;
    
}

#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(textFieldBeganEditting:)]) {
        [self.delegate textFieldBeganEditting:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(textFieldEndEditting:)]) {
        [self.delegate textFieldEndEditting:textField];
    }
}
@end
