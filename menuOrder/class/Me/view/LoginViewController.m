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
#define YYBORDER 20
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self addUIView];
}
- (void)viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}


-(void)addUIView{
    //    背景图
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kWidth, HearderImageH)];
    [self.view addSubview:headerImage];
    headerImage.image=[UIImage imageNamed:@"header"];
    headerImage.userInteractionEnabled=YES;
    
    
    //    返回
    UIButton *return_Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [headerImage addSubview:return_Btn];
    return_Btn.frame=CGRectMake(10, 10, 44, 44);
    [return_Btn setImage:[UIImage imageNamed:@"nav_returnimg"] forState:UIControlStateNormal];
    [return_Btn setImage:[UIImage imageNamed:@"nav_returnimg_pre"] forState:UIControlStateHighlighted];
    
    [return_Btn addTarget:self action:@selector(return_btnClick) forControlEvents:UIControlEventTouchUpInside];

    //    头像
    UIButton *headerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [headerImage addSubview:headerBtn];
    headerBtn.frame=CGRectMake((kWidth-HEADERWY)/2, HearderImageH-(HEADERWY)/2, HEADERWY, HEADERWY);
    [headerBtn setImage:[UIImage imageNamed:@"heaar_img"] forState:UIControlStateNormal];
    [headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    headerBtn.layer.cornerRadius=0;
    headerBtn.layer.borderWidth=2.0;
    headerBtn.layer.masksToBounds = YES;
    headerBtn.layer.borderColor=[UIColor colorWithRed:72.0/255.0 green:144.0/255.0 blue:5.0/255.0 alpha:1 ] .CGColor;
    
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
    if (login.tag ==LOGINTAG+2) {
        SinaView *SinaVc=[[SinaView alloc]init];
        [self.navigationController pushViewController:SinaVc animated:YES];
    }else{
        QQView *qqVC=[[QQView alloc]init];
        [self.navigationController pushViewController:qqVC animated:YES];    }
}
-(void)return_btnClick{
    [self.navigationController popViewControllerAnimated:YES];
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
