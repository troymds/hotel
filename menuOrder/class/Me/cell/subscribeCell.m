//
//  subscribeCell.m
//  menuOrder
//
//  Created by YY on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "subscribeCell.h"
#define YYBORDERW 14
#define IMAGEWIDTH 143
@implementation subscribeCell
@synthesize MeSubscribeCategoryLabel,MeSubscribeImage,MeSubscribeNumLabel,MeSubscribeTimeLabel;
- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *backCell=[[UIView alloc]initWithFrame:CGRectMake(YYBORDERW, 6, kWidth-YYBORDERW*2, 84)];
        backCell.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:backCell];
        backCell.layer.cornerRadius=CORNERrADIUS;
        backCell.layer.masksToBounds=YES;
        
        MeSubscribeImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, IMAGEWIDTH, 80)];
        [backCell addSubview:MeSubscribeImage];
        MeSubscribeCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(IMAGEWIDTH+YYBORDERW, 5, kWidth-YYBORDERW*4-IMAGEWIDTH, 20)];
        MeSubscribeCategoryLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [backCell addSubview:MeSubscribeCategoryLabel];
        MeSubscribeCategoryLabel.backgroundColor=[UIColor clearColor];
        MeSubscribeCategoryLabel.textColor=HexRGB(0x666666);
        MeSubscribeImage.layer.cornerRadius=CORNERrADIUS;
        MeSubscribeImage.layer.masksToBounds=YES;
        
        
        
        
        MeSubscribeNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(IMAGEWIDTH+YYBORDERW, YYBORDERW*2+3, kWidth-YYBORDERW*4-IMAGEWIDTH, 20)];
        [backCell addSubview:MeSubscribeNumLabel];
        MeSubscribeNumLabel.numberOfLines = 0;
        MeSubscribeNumLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        MeSubscribeNumLabel.textColor=HexRGB(0x666666);
        MeSubscribeNumLabel.backgroundColor=[UIColor clearColor];
        
        MeSubscribeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(IMAGEWIDTH+YYBORDERW, YYBORDERW*4+3,kWidth-YYBORDERW*4-IMAGEWIDTH, 20)];
        [backCell addSubview:MeSubscribeTimeLabel];
        MeSubscribeTimeLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        MeSubscribeTimeLabel.textColor = HexRGB(0x666666);
        MeSubscribeTimeLabel.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
