//
//  MeController.m
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MeController.h"
#import "ShareView.h"
#import "MysubscribeView.h"
#import "MyOrderView.h"
#import "AddressView.h"
#import "aboutOurView.h"
#import "SystemConfig.h"
#import "SuggestView.h"
#define HEADERWY 85
#define YYBODERY 11
#define BUTTONH 40
#define HearderImageH 170
#define MYBTNTAG 1000
@interface MeController ()
{
   
    UIScrollView *_backScrollView;
    NSString *_url;

}
@end

@implementation MeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"我的";
    
    [self addUIView];
}
-(void)addUIView{
    
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, kWidth, kHeight)];
//    if (IsIos6) {
//        _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
//
//    }
    if (kHeight==480) {

        _backScrollView.contentSize = CGSizeMake(kWidth,kHeight+70);

    }else{
        _backScrollView.contentSize = CGSizeMake(kWidth,kHeight);

    }
    _backScrollView.userInteractionEnabled=YES;
    [self.view addSubview:_backScrollView];
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    _backScrollView.backgroundColor = HexRGB(0xeeeeee);

//    背景图
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, HearderImageH)];
    [_backScrollView addSubview:headerImage];
    headerImage.image=[UIImage imageNamed:@"header"];
//    头像
    UIButton *headerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_backScrollView addSubview:headerBtn];
    headerBtn.frame=CGRectMake((kWidth-HEADERWY)/2, (HearderImageH-HEADERWY)/2, HEADERWY, HEADERWY);
    [headerBtn setImage:[UIImage imageNamed:@"heaar_img"] forState:UIControlStateNormal];
//    headerBtn.layer.cornerRadius=0;
//    headerBtn.layer.borderWidth=1.0;
//    headerBtn.layer.masksToBounds = YES;
    headerBtn.layer.borderColor=[UIColor colorWithRed:72.0/255.0 green:144.0/255.0 blue:5.0/255.0 alpha:1 ] .CGColor;
    
    NSArray *myTitle =@[@"   我的预约",@"   我的点餐",@"   地址管理",@"   分享渔府",@"   意见反馈",@"   关于我们",@"   检查更新"];
    for (int i=0; i<7; i++) {
       
//        按钮
        UIButton *myBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [myBtn setTitle:myTitle[i] forState:UIControlStateNormal];
        [myBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"meImage%d",i]] forState:UIControlStateNormal];
        myBtn .titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [myBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"meImage%d",i]] forState:UIControlStateHighlighted];

        myBtn.titleEdgeInsets =UIEdgeInsetsMake(0, -170, 0, 0);
        myBtn.imageEdgeInsets =UIEdgeInsetsMake(0, -170, 0, 0);

        [myBtn setTitleColor:HexRGB(0x605e5f) forState:UIControlStateNormal];
        [_backScrollView addSubview:myBtn];
        myBtn.frame=CGRectMake(0, HearderImageH+YYBODERY+i%7*BUTTONH, kWidth, BUTTONH);
        if (i==3) {
            myBtn.frame =CGRectMake(0, HearderImageH+YYBODERY*2+i%7*BUTTONH, kWidth, BUTTONH);
        }
        if (i==4) {
            myBtn.frame =CGRectMake(0, HearderImageH+YYBODERY*2+i%7*BUTTONH, kWidth, BUTTONH);
        }if (i==5) {
            myBtn.frame =CGRectMake(0, HearderImageH+YYBODERY*2+i%7*BUTTONH, kWidth, BUTTONH);
        }if (i==6) {
            
            UILabel *version=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-110, 0, 110, BUTTONH)];
            [myBtn addSubview:version];
            version.text=@"当前版本1.0";
            version.font =[UIFont systemFontOfSize:PxFont(16)];
            version.textColor=HexRGB(0x605e5f);
            version.backgroundColor =[UIColor clearColor];
            myBtn.frame =CGRectMake(0, HearderImageH+YYBODERY*2+i%7*BUTTONH, kWidth, BUTTONH);
        }
        myBtn.backgroundColor =[UIColor whiteColor];
        [myBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        myBtn.tag =MYBTNTAG+i;
//        返回图片
        UIImageView *returnImage =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-BUTTONH-YYBODERY+20, 10, 20, 20)];
        [myBtn addSubview:returnImage];
        returnImage.userInteractionEnabled=YES;
        returnImage.image=[UIImage imageNamed:@"reture_img"];
        
        
        
    }
    for (int l=0; l<9; l++) {
        UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, HearderImageH+YYBODERY-1+l%9*BUTTONH, kWidth, 1)];
        backView.backgroundColor =HexRGB(0xcacaca);

        if (l==4) {
            backView.frame=CGRectMake(0, HearderImageH+YYBODERY*2-1+l%10*BUTTONH, kWidth, 1);

        }if (l==5) {
            backView.frame=CGRectMake(0, HearderImageH+YYBODERY*2-1+l%10*BUTTONH, kWidth, 1);
            
        }if (l==6) {
            backView.frame=CGRectMake(0, HearderImageH+YYBODERY*2-1+l%10*BUTTONH, kWidth, 1);
            
        }if (l==7) {
            backView.frame=CGRectMake(0, HearderImageH+YYBODERY*2-1+l%10*BUTTONH, kWidth, 1);
            
        }
        if (l==8) {
            backView.frame=CGRectMake(0, HearderImageH+YYBODERY*2-1+3*BUTTONH, kWidth, 1);
            
        }
        [_backScrollView addSubview:backView];
    }
    
}

-(void)myBtnClick:(UIButton *)sender{
    
//    if ([SystemConfig sharedInstance ].isUserLogin) {
        if (sender.tag==MYBTNTAG) {
            MysubscribeView *mySubscriVc =[[MysubscribeView alloc]init];
            [self.navigationController pushViewController:mySubscriVc animated:YES];
        }if (sender.tag==MYBTNTAG+1) {
            MyOrderView *MyOrderVC=[[MyOrderView alloc]init];
            [self.navigationController pushViewController:MyOrderVC animated:YES];
        }
        if (sender.tag==MYBTNTAG+2) {
            AddressView *addressVC=[[AddressView alloc]init];
            [self.navigationController pushViewController:addressVC animated:YES];
        }
        if (sender.tag==MYBTNTAG+3) {
            [ShareView showViewWithTitle:@"分享" content:@"这是一段紫金渔府的分享" description:@"这是一段紫金渔府的分享"  url:@"chinapromo.cn" delegate:self];
        }
    if (sender.tag==MYBTNTAG+4) {
        SuggestView *suggestVc=[[SuggestView alloc]init];
        [self.navigationController pushViewController:suggestVc animated:YES];
    }
        if (sender.tag==MYBTNTAG+5) {
            aboutOurView *aboutVC=[[aboutOurView alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    if (sender.tag==MYBTNTAG+6) {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"version",@"version", nil];
        [HttpTool postWithPath:@"getNewestVersion" params:param success:^(id JSON) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [[result objectForKey:@"response"]objectForKey:@"data"];
            if (dic) {
                NSString *key = (NSString *)kCFBundleVersionKey;
                NSString *version = [NSBundle mainBundle].infoDictionary[key];
                NSString *current = [dic objectForKey:@"version"];
                NSLog(@"--ggggggg-%@",current);
                if ([current isEqualToString:version]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:@"您当前已是最新版本" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    alertView.tag = 1000;
                    [alertView show];
                }else{
                    _url = [dic objectForKey:@"url"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即升级", nil];
                    alertView.tag = 1001;
                    [alertView show];
                }
            }
        } failure:^(NSError *error) {
            
        }];

    }
        else{
            return;
        }
 
//    }else{
//        LoginViewController *loginVC=[[LoginViewController alloc]init];
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //版本更新
    openURL(_url);
    NSLog(@"%@",_url);
}
#pragma mark 控件将要显示
- (void)viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

@end
