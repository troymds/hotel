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
        
        _nameField =[[UITextField alloc]initWithFrame:CGRectMake(10, i%3*50, kWidth-YYBORDERW*2-50, 50)];
        [backView addSubview:_nameField];
        _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.delegate =self;
        _nameField.tag = TEXTFIDLDTAG+i;
        _nameField.placeholder =placeHoderArray[i];
        
        UIImageView *writeView =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-YYBORDERW*4, 15+i%3*50, 20, 20)];
        [backView addSubview:writeView];
        writeView.image=[UIImage imageNamed:@"me_write_enter"];
        if (_nameField.tag ==TEXTFIDLDTAG+1) {
            _nameField.keyboardType = UIKeyboardTypeNumberPad;

        }

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
        
    }else if(![self isValidateMobile:telStr]){
        [RemindView showViewWithTitle:@"手机号不合法" location:TOP];

    }
    else{
        [self addLoadStatus];
        
    }
    
}

-(void)addLoadStatus
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.dimBackground = NO;
    [addAdressTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];

        [self disMissVC];
        
    } uid_ID:@"uid" ContentStr:addressStr TelStr:telStr ContactStr:nameStr failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];

       
        
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

-(BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [_nameField resignFirstResponder];
//
//}
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
