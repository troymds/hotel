//
//  modificationAddress.m
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "modificationAddress.h"
#define YYBORDERW 15
#define TEXTFIDLDTAG 200
@interface modificationAddress ()

@end



@implementation modificationAddress

- (void)viewDidLoad {
    self.title=@"修改地址";

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_ok-1" highlightedSearch:@"nav_ok-1" target:(self) action:@selector(categoryBtnClick)];
    self.view.backgroundColor=HexRGB(0xeeeeee);
    
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
                _nameField.placeholder=@"联系人姓名";
                
                break;
            case TEXTFIDLDTAG+1:
                _nameField.placeholder=@"联系电话";
                
                break;
            case TEXTFIDLDTAG+2:
                _nameField.placeholder=@"详细地址";
                
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
