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
    self.title=@"修改地址";
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

        _updateNameField =[[UITextField alloc]initWithFrame:CGRectMake(10, i%3*50, kWidth-YYBORDERW*2-50, 35)];
        [backView addSubview:_updateNameField];
        _updateNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _updateNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _updateNameField.delegate =self;
        _updateNameField.text=updateArray[i];
        _updateNameField.tag = TEXTFIDLDTAG+i;

        if (_updateNameField.tag ==TEXTFIDLDTAG+1) {
            _updateNameField.keyboardType = UIKeyboardTypeNumberPad;
            
        }

        UIImageView *writeView =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-YYBORDERW*4, 15+i%3*50, 20, 20)];
        [backView addSubview:writeView];
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
        
    }else if(![self isValidateMobile:updateTelStr]){
        [RemindView showViewWithTitle:@"请输入正确的手机号码" location:MIDDLE];
        
    }else{
        [self addLoadStatus];
        
    }
    
}
-(BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
-(void)addLoadStatus
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.dimBackground = NO;
    [addAdressTool updateAddressID:updateIndex ContentStr:updateAddressStr TelStr:updateTelStr ContactStr:updateNameStr statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];

        [self disMissVC];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
 
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


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView resignFirstResponder];
        }else{
            for (UIView  *view in subView.subviews) {
                if ([view isKindOfClass:[UITextField class]]) {
                    [view resignFirstResponder];
                }
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
