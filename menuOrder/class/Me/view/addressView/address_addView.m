//
//  address_addView.m
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "address_addView.h"
#import "addAdressTool.h"
#define YYBORDERW 15
#define TEXTFIDLDTAG 200
@interface address_addView ()

@end
@implementation address_addView
@synthesize nameStr,telStr,addressStr;
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
    NSArray *placeHoderArray =@[@"请输入联系人姓名",@"请输入联系人联系电话",@"请输入联系人详细地址"];
    for (int i=0; i<3; i++)
    {
        
        _nameField =[[UITextField alloc]initWithFrame:CGRectMake(10, i%3*50, kWidth-YYBORDERW*2-10, 50)];
        [backView addSubview:_nameField];
        _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        _nameField.tag = TEXTFIDLDTAG+i;
        _nameField.placeholder =placeHoderArray[i];
        
        UIImageView *writeView =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-YYBORDERW*5, 15, 20, 20)];
        [_nameField addSubview:writeView];
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
                nameStr = current.text;
                break;
            case TEXTFIDLDTAG+1:
                
                telStr = current.text;
                
                break;
            case TEXTFIDLDTAG+2:
                
                addressStr = current.text;
                
                break;
                
            default:
                break;
        }

        
    }
    if ([nameStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人姓名不能为空" location:MIDDLE];
    }else if ([telStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人联系电话不能为空" location:MIDDLE];
        
    }else if ([addressStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人详细地址不能为空" location:MIDDLE];
        
    }else{
        [self addLoadStatus];
        
    }
    
}

-(void)addLoadStatus
{
    
    [addAdressTool statusesWithSuccess:^(NSArray *statues) {
        
        [self disMissVC];
        
    } uid_ID:@"uid" ContentStr:addressStr TelStr:telStr ContactStr:nameStr failure:^(NSError *error) {
        
        NSLog(@"增添新地址失败！ ---- >%@",error);
        
    }];
    

}

- (void)disMissVC
{
    if ([nameStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人姓名不能为空" location:MIDDLE];
    }else if ([telStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人姓名不能为空" location:MIDDLE];

    }else if ([addressStr isEqualToString:@""]) {
        [RemindView showViewWithTitle:@"联系人姓名不能为空" location:MIDDLE];

    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nameField resignFirstResponder];

}


@end
