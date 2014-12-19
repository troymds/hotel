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
@synthesize MeOrderImage,MeOrderTitle,backImage;
- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UIView *backCell=[[UIView alloc]initWithFrame:CGRectMake(YYBORDERW, 0, kWidth-YYBORDERW*2, 110)];
        backCell.backgroundColor =[UIColor whiteColor];
        [self addSubview:backCell];
        backCell.layer.cornerRadius=CORNERrADIUS;
        backCell.layer.masksToBounds=YES;
        
        backImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBORDERW, 0, kWidth-YYBORDERW*2, 110)];
        [self addSubview:backImage];

        for (int i=0; i<2; i++) {
            
            
            MeOrderImage = [[UIImageView alloc] initWithFrame:CGRectMake(2+YYBORDERW+i%2*(IMAGEWIDTH+11), 2, IMAGEWIDTH, 80)];
            [self addSubview:MeOrderImage];
            MeOrderImage.backgroundColor =[UIColor redColor];
            MeOrderImage.layer.cornerRadius=CORNERrADIUS;
            MeOrderImage.layer.masksToBounds=YES;
//            MeOrderImage.image=[UIImage imageNamed:@"header"];
            
            MeOrderTitle = [[UILabel alloc] initWithFrame:CGRectMake(2+YYBORDERW+i%2*((kWidth-YYBORDERW*2)/2), 82,(kWidth-YYBORDERW*2)/2, 24)];
            [self addSubview:MeOrderTitle];
            MeOrderTitle.font =[UIFont systemFontOfSize:PxFont(20)];
            MeOrderTitle.textAlignment=NSTextAlignmentCenter;
            MeOrderTitle.textColor = HexRGB(0x666666);
            MeOrderTitle.backgroundColor=[UIColor clearColor];
            MeOrderTitle.text=@"魏紫薇";

        }
          }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
