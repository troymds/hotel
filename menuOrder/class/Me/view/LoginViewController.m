//
//  LoginViewController.m
//  menuOrder
//
//  Created by YY on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewController.h"
#import "SinaView.h"
#import "QQView.h"
#define HEADERWY 85
#define HearderImageH 170
#define LOGINTAG 2000
#define NAVHEIGHT 64
#define YYBORDER 35
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self addUIView];
}
-(void)addUIView{
    //    背景图
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, kWidth, HearderImageH)];
    [self.view addSubview:headerImage];
    headerImage.image=[UIImage imageNamed:@"header"];
    //    头像
    UIButton *headerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [headerImage addSubview:headerBtn];
    headerBtn.frame=CGRectMake((kWidth-HEADERWY)/2, (HearderImageH-HEADERWY)/2, HEADERWY, HEADERWY);
    [headerBtn setImage:[UIImage imageNamed:@"header_img"] forState:UIControlStateNormal];
    [headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(YYBORDER, HearderImageH+YYBORDER+NAVHEIGHT, 200, YYBORDER)];
    [self.view addSubview:lab];
    lab.text =@"使用以下账号登录";
    lab.font=[UIFont systemFontOfSize:PxFont(18)];
    lab.textColor=HexRGB(0x808080);
    for (int i=0; i<3; i++) {
        UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:loginBtn];
        loginBtn.frame=CGRectMake(YYBORDER, HearderImageH+YYBORDER*3+NAVHEIGHT+i%3*60, kWidth-YYBORDER*2, 40);
        [loginBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_imageBtn%d.png",i ]] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(LoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        loginBtn.tag =LOGINTAG+i;
    }
    

}
#pragma mark---登录
-(void)LoginBtnClick:(UIButton *)login{
    if (login.tag ==LOGINTAG) {
        SinaView *SinaVc=[[SinaView alloc]init];
        [self.navigationController pushViewController:SinaVc animated:YES];
    }else{
        QQView *qqVC=[[QQView alloc]init];
        [self.navigationController pushViewController:qqVC animated:YES];    }
}
-(void)headerBtnClick:(UIButton *)head{
   }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
