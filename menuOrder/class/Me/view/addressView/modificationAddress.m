//
//  modificationAddress.m
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "modificationAddress.h"
#import "addAdressTool.h"
#define YYBORDERW 15
#define TEXTFIDLDTAG 300
@interface modificationAddress ()

@end



@implementation modificationAddress
@synthesize updateAddressStr,updateIndex,updateNameStr,updateTelStr;
- (void)viewDidLoad
{
    self.title=@"新增地址";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_ok" highlightedSearch:@"nav_ok_pre" target:(self) action:@selector(navSaveContentClick)];
    self.view.backgroundColor=HexRGB(0xeeeeee);
    [self addAdressUI];
    
    
}

-(void)addAdressUI
{
    backView = [[UIView alloc]initWithFrame:CGRectMake(YYBORDERW, 9, kWidth-YYBORDERW*2, 150)];
    backView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:backView];
    backView.layer.cornerRadius=CORNERrADIUS;
    backView.layer.masksToBounds=YES;
    
    for (int i=0; i<3; i++)
    {
        
        NSArray *placeArray =@[@"联系人姓名",@"联系电话",@"详细地址"];
        NSArray *updateArray =@[updateNameStr,updateTelStr,updateAddressStr];
        UILabel *placeHoderLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 30+i%3*50, kWidth-YYBORDERW*2-10, 18)];
        [backView addSubview:placeHoderLabel];
        placeHoderLabel.text =placeArray[i];
        placeHoderLabel.font =[UIFont systemFontOfSize:PxFont(12)];
        placeHoderLabel.textColor=HexRGB(0xa6a6a6);
        [backView addSubview:placeHoderLabel];

        _updateNameField =[[UITextField alloc]initWithFrame:CGRectMake(10, i%3*50, kWidth-YYBORDERW*2-60, 35)];
        [backView addSubview:_updateNameField];
        _updateNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _updateNameField.text=updateArray[i];
        _updateNameField.tag = TEXTFIDLDTAG+i;

        UIImageView *writeView =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-YYBORDERW*5, 15, 20, 20)];
        [_updateNameField addSubview:writeView];
        writeView.image=[UIImage imageNamed:@"me_write_enter"];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 50+i%2*50, kWidth-YYBORDERW*2, 1)];
        lineView.backgroundColor =HexRGB(0xcacaca);
        [backView addSubview:lineView];
        
    }
    
}
-(void)navSaveContentClick
{
    for (int i = 0 ; i < 3; i++)
    {
        UITextField *current = (UITextField *)[backView viewWithTag:TEXTFIDLDTAG +i];
        
        switch (current.tag)
        {
            case TEXTFIDLDTAG:
                updateNameStr = current.text;
                break;
            case TEXTFIDLDTAG+1:
                
                updateTelStr = current.text;
                
                break;
            case TEXTFIDLDTAG+2:
                
                updateAddressStr = current.text;
                
                break;
                
            default:
                break;
        }
        
        
    }
    if ([updateNameStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人姓名不能为空" location:MIDDLE];
    }else if ([updateTelStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人联系电话不能为空" location:MIDDLE];
        
    }else if ([updateAddressStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人详细地址不能为空" location:MIDDLE];
        
    }else{
        [self addLoadStatus];
        
    }
    
}

-(void)addLoadStatus
{
    
    [addAdressTool updateAddressID:updateIndex ContentStr:updateAddressStr TelStr:updateTelStr ContactStr:updateNameStr statusesWithSuccess:^(NSArray *statues) {
        [self disMissVC];
    } failure:^(NSError *error) {
        
    }];

}

- (void)disMissVC
{
    if ([updateNameStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人姓名不能为空" location:MIDDLE];
    }else if ([updateTelStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人姓名不能为空" location:MIDDLE];
        
    }else if ([updateAddressStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人姓名不能为空" location:MIDDLE];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_updateNameField resignFirstResponder];
    
}
@end