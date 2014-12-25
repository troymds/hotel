//
//  MyOrderCell.m
//  menuOrder
//
//  Created by YY on 14-12-12.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MyOrderCell.h"
#define YYBORDERW 11
#define IMAGEWIDTH 141
@implementation MyOrderCell
@synthesize firMeOrderImage,firMeOrderTitle,secMeOrderImage,secMeOrderTitle,backImage;
- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        
        UIView *backCell=[[UIView alloc]initWithFrame:CGRectMake(YYBORDERW, 0, kWidth-YYBORDERW*2, 110)];
        backCell.backgroundColor =[UIColor whiteColor];
        [self addSubview:backCell];
        backCell.layer.cornerRadius=CORNERrADIUS;
        backCell.layer.masksToBounds=YES;
        
        backImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBORDERW, 0, kWidth-YYBORDERW*2, 110)];
        [self addSubview:backImage];


            firMeOrderImage = [[UIImageView alloc] initWithFrame:CGRectMake(2+YYBORDERW+0%2*(IMAGEWIDTH+11), 2, IMAGEWIDTH, 80)];
            [self addSubview:firMeOrderImage];
            firMeOrderImage.backgroundColor =[UIColor clearColor];
            firMeOrderImage.layer.cornerRadius=CORNERrADIUS;
            firMeOrderImage.layer.masksToBounds=YES;
            firMeOrderImage.userInteractionEnabled =YES;
            
            firMeOrderTitle = [[UILabel alloc] initWithFrame:CGRectMake(2+YYBORDERW+0%2*((kWidth-YYBORDERW*2)/2), 82,(kWidth-YYBORDERW*2)/2, 24)];
            [self addSubview:firMeOrderTitle];
            firMeOrderTitle.font =[UIFont systemFontOfSize:PxFont(20)];
            firMeOrderTitle.textAlignment=NSTextAlignmentCenter;
            firMeOrderTitle.textColor = HexRGB(0x666666);
            firMeOrderTitle.backgroundColor=[UIColor clearColor];

            
            secMeOrderImage = [[UIImageView alloc] initWithFrame:CGRectMake(2+YYBORDERW+1%2*(IMAGEWIDTH+11), 2, IMAGEWIDTH, 80)];
            [self addSubview:secMeOrderImage];
            secMeOrderImage.backgroundColor =[UIColor clearColor];
            secMeOrderImage.layer.cornerRadius=CORNERrADIUS;
            secMeOrderImage.layer.masksToBounds=YES;
            secMeOrderImage.userInteractionEnabled =YES;

        
            secMeOrderTitle = [[UILabel alloc] initWithFrame:CGRectMake(2+YYBORDERW+1%2*((kWidth-YYBORDERW*2)/2), 82,(kWidth-YYBORDERW*2)/2, 24)];
            [self addSubview:secMeOrderTitle];
            secMeOrderTitle.font =[UIFont systemFontOfSize:PxFont(20)];
            secMeOrderTitle.textAlignment=NSTextAlignmentCenter;
            secMeOrderTitle.textColor = HexRGB(0x666666);
            secMeOrderTitle.backgroundColor=[UIColor clearColor];

        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
