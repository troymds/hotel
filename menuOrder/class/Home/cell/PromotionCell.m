//
//  PromotionCell.m
//  menuOrder
//  优惠活动cell
//  Created by promo on 14-12-16.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "PromotionCell.h"
#import "ActivityModel.h"

#define KLeftX    5
#define KStartX   4
#define KImgWHRace   2
#define KImgW       120
#define KimgH   (KImgW/KImgWHRace)
#define KCellHeight  (((KLeftX + KStartX) *2) + KimgH)
#define KbackViewH   (KCellHeight - KLeftX * 2)
#define KBackViewW   (kWidth - KLeftX * 2)

@implementation PromotionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HexRGB(0xe0e0e0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 1 白色背景
        UIView *whiteBackView = [[UIView alloc] init];
        whiteBackView.backgroundColor = [UIColor whiteColor];
        whiteBackView.layer.cornerRadius = 4;
        whiteBackView.frame = Rect(KLeftX, KLeftX, KBackViewW, KbackViewH);
        [self.contentView addSubview:whiteBackView];
        
        //1 美食图片
        UIImageView *foodimg = [[UIImageView alloc] init];
        foodimg.frame = CGRectZero;
        [whiteBackView addSubview:foodimg];
        foodimg.image = LOADPNGIMAGE(@"home_banner");
        foodimg.layer.masksToBounds = YES;
        foodimg.layer.cornerRadius = 4;
        //foodimg.contentMode = UIViewContentModeScaleAspectFit;
        _foodImg = foodimg;
        
        //2 标题名
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectZero;
        title.font = [UIFont systemFontOfSize:PxFont(20)];
        title.textColor = HexRGB(0x605e5f);
        title.backgroundColor = [UIColor clearColor];
        title.text = @"优惠大酬宾";
        [whiteBackView addSubview:title];
        _title = title;
        
        //3 细节
        UILabel *detail = [[UILabel alloc] init];
        detail.frame = CGRectZero;
        detail.font = [UIFont systemFontOfSize:PxFont(16)];
        detail.textColor = HexRGB(0x605e5f);
        detail.backgroundColor = [UIColor clearColor];
        detail.numberOfLines = 0;
        detail.text = @"天天半价拉啦拉啦拉啦拉啦拉啦拉啦拉啦";
        [whiteBackView addSubview:detail];
        _detail = detail;
    }
    return self;
}

-(void)setData:(ActivityModel *)data
{
    _data = data;
    
    //1 美食图片
    CGFloat imgX = KStartX;
    CGFloat imgY = KStartX;
    _foodImg.frame = Rect(imgX, imgY, KImgW, KimgH);
    [_foodImg setImageWithURL:[NSURL URLWithString:data.cover] placeholderImage:placeHoderImage2];
    
   //2 标题名
    CGFloat titleX = CGRectGetMaxX(_foodImg.frame) + 10;
    CGFloat titleY = KLeftX;
    _title.frame = Rect(titleX, titleY, 100, 30);
    _title.text  = data.title;
    //3 细节
    CGFloat detailY = CGRectGetMaxY(_title.frame);
    CGFloat detailW = KBackViewW - titleX - KLeftX;
    
    _detail.frame = Rect(titleX, detailY, detailW, 30);
    _detail.text = data.content;
//    NSLog(@"view H %f",KCellHeight) ;
}
@end


