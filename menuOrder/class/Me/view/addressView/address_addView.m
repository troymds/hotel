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
- (void)viewDidLoad {
    self.title=@"新增地址";
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_ok-1" highlightedSearch:@"nav_ok-1" target:(self) action:@selector(categoryBtnClick)];
    self.view.backgroundColor=HexRGB(0xeeeeee);
    
    [self addLoadStatus];

}
-(void)addLoadStatus{
    [addAdressTool statusesWithSuccess:^(NSArray *statues) {
        [self addAdressUI];

    } uid_ID:@"uid" ContentStr:addressStr TelStr:telStr ContactStr:nameStr failure:^(NSError *error) {
        
    }];
}
-(void)addAdressUI{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(YYBORDERW, 80, kWidth-YYBORDERW*2, 150)];
    backView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:backView];
    backView.layer.cornerRadius=8;
    backView.layer.masksToBounds=YES;
    
    for (int i=0; i<3; i++) {
        _nameField =[[UITextField alloc]initWithFrame:CGRectMake(10, i%3*50, kWidth-YYBORDERW*2-10, 50)];
        [backView addSubview:_nameField];
        _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        _nameField.tag=TEXTFIDLDTAG+i;
        switch (_nameField.tag) {
            case TEXTFIDLDTAG:
                _nameField.placeholder=@"请输入联系人姓名";
                nameStr=_nameField.text;
                NSLog(@"%@----%@",_nameField.text,nameStr);
                break;
            case TEXTFIDLDTAG+1:
                _nameField.placeholder=@"请输入联系人联系电话";
                telStr=_nameField.text;

                break;
            case TEXTFIDLDTAG+2:
                _nameField.placeholder=@"请输入联系人详细地址";
                addressStr=_nameField.text;

                break;
                
            default:
                break;
        }
        
        UIImageView *writeView =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-YYBORDERW*5, 15, 20, 20)];
        [_nameField addSubview:writeView];
        writeView.image=[UIImage imageNamed:@"me_write_enter"];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 50+i%2*50, kWidth-YYBORDERW*2, 1)];
        lineView.backgroundColor =HexRGB(0xcacaca);
        [backView addSubview:lineView];
        
        
    }
    

 
}
-(void)categoryBtnClick{
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nameField resignFirstResponder];

}


@end
