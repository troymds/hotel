//
//  aboutOurView.m
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "aboutOurView.h"
#import "aboutTool.h"
#define YYBODERY 9
#define BUTTONH 30
#define HearderImageH 170
@interface aboutOurView ()

@end

@implementation aboutOurView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=HexRGB(0xeeeeee);
    self.title=@" 关于我们";

    [self addUIView];
    [self addLoadStatus];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
-(void)addLoadStatus{
    [aboutTool statusesWithSuccess:^(NSArray *statues) {
        
    }  failure:^(NSError *error) {
        
    }];
}
-(void)addUIView{
    //    背景图
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, HearderImageH)];
    [self.view addSubview:headerImage];
    headerImage.image=[UIImage imageNamed:@"header"];
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(YYBODERY, 80+HearderImageH, kWidth-YYBODERY*2, 170)];
    backView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:backView];
    backView.layer.cornerRadius=CORNERrADIUS;
    backView.layer.masksToBounds=YES;
    
    for (int i=0; i<5; i++) {
        NSArray *aboutArray=@[@"紫金渔府",@"人均：￥200",@"营业时间：10：00-23：00",@"地址：江苏省",@"电话：12458798745"];
        UILabel *aboutLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBODERY,10+ i%5*BUTTONH, kWidth-YYBODERY*4, BUTTONH)];
        [backView addSubview:aboutLabel];
        aboutLabel.text=aboutArray[i];
        if (i==0) {
            aboutLabel.font=[UIFont systemFontOfSize:PxFont(25)];
            aboutLabel.textColor=HexRGB(0x605e5f);
            
        }else{
            aboutLabel.font=[UIFont systemFontOfSize:PxFont(20)];
            aboutLabel.textColor=HexRGB(0x605e5f);
        }
        
    }
    
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
