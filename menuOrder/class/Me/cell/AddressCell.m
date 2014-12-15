//
//  AddressCell.m
//  menuOrder
//
//  Created by YY on 14-12-12.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "AddressCell.h"
#define YYBORDERW 9
#define YYBORDERWw 13

@implementation AddressCell
@synthesize nameLabel,numberLabel,delegateBtn,addressLabel;
- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *backCell=[[UIView alloc]initWithFrame:CGRectMake(YYBORDERW, 6, kWidth-YYBORDERW*2, 80)];
        backCell.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:backCell];
        backCell.layer.cornerRadius=8;
        backCell.layer.masksToBounds=YES;
        
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(YYBORDERWw, YYBORDERWw, 60, 20)];
        [backCell addSubview:nameLabel];
        nameLabel.font =[UIFont systemFontOfSize:PxFont(23)];
        nameLabel.textColor=HexRGB(0x666666);
        nameLabel.backgroundColor=[UIColor redColor];
        
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(YYBORDERWw+100,YYBORDERWw, 150, 20)];
        [backCell addSubview:numberLabel];
        numberLabel.font =[UIFont systemFontOfSize:PxFont(23)];
        numberLabel.textColor = HexRGB(0x666666);
        numberLabel.backgroundColor=[UIColor cyanColor];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(YYBORDERWw, YYBORDERWw, kWidth-YYBORDERW*2-YYBORDERWw*2, 20)];
        [backCell addSubview:addressLabel];
        addressLabel.numberOfLines = 0;
        addressLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        addressLabel.textColor=HexRGB(0x666666);
        addressLabel.backgroundColor=[UIColor purpleColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
