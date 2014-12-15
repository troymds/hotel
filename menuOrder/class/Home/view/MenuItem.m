//
//  MenuItem.m
//  menuOrder
//  飘香菜单左侧菜单栏item
//  Created by promo on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MenuItem.h"

#define KLineW 3
#define KTextSpaceFromLine  8

@implementation MenuItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1 背景色
        self.backgroundColor = HexRGB(0xe0e0e0);
        //2 菜色
        UILabel *text = [[UILabel alloc] init];
        text.frame = Rect(KLineW + KTextSpaceFromLine, 0, frame.size.width - KLineW - KTextSpaceFromLine, frame.size.height);
        text.font = [UIFont systemFontOfSize:PxFont(20)];
        text.text = @"飘香菜单";
        text.textColor = [UIColor blackColor];
        [self addSubview:text];
        _contentLabel = text;
        //3 划线
        UIView *line = [[UIView alloc] initWithFrame:Rect(0, 0, 3, frame.size.height)];
        line.backgroundColor = HexRGB(0x56b001);
        [self addSubview:line];
        line.hidden = YES;
        _line = line;
    }
    return self;
}

#pragma mark 被选中状态UI改变
- (void)setIsSelected:(BOOL)isSelected
{
    if (isSelected) {//选中状态
        // 字体颜色变HexRGB(0x56b001)，背景变白,划线显示
        _contentLabel.textColor = HexRGB(0x56b001);
        self.backgroundColor  = [UIColor whiteColor];
        _line.hidden = NO;
    }else
    {
        _contentLabel.textColor = [UIColor blackColor];
        self.backgroundColor  = HexRGB(0xe0e0e0);
        _line.hidden = YES;
    }
}

#pragma mark 点击item事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(menuItemClieked:)]) {
        [_delegate menuItemClieked:self];
    }
}

@end
