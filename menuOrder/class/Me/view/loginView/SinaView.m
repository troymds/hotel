//
//  SinaView.m
//  menuOrder
//
//  Created by YY on 14-12-11.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "SinaView.h"
#import "ZYOAuthConfig.h"
#import "AccountTool.h"
#import "MainController.h"
#import "SinaTool.h"
@interface SinaView ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    
}
@end

@implementation SinaView

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.加载登录页面（获取未授权的Request Token）
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    //1.
    //webview加载一个request请求
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&response_type=code&redirect_uri=%@&scope=all", ZYAuthorizeUrl, ZYAppKey, ZYAppRedirectUri]]]];
}
#pragma mark 当webView请求完毕就会调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
#pragma mark 拦截webView的所有请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1.获得全路径
    NSString *urlStr = request.URL.absoluteString;
    
    // 2.查找code=的范围
    NSRange range = [urlStr rangeOfString:@"code="];
    
    if (range.length != 0) { // 跳到“回调地址”，说明已经授权成功
        int index = range.location + range.length;
        NSString *requestToken = [urlStr substringFromIndex:index];
        
//         3.换取accessToken
                [self getAccessToken:requestToken];
      

        return NO;
    }
    return YES;
}


#pragma mark - webview代理方法
#pragma mark 当webView开始加载请求就会调用
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载中...";
    hud.dimBackground = YES;
}
#pragma mark 换取accessToken
- (void)getAccessToken:(NSString *)requestToken
{
    [SinaTool postWithPath:@"oauth2/access_token" params:@{
       @"client_id" : ZYAppKey,
       @"client_secret" : ZYAppSecret,
       @"grant_type" : @"authorization_code",
       @"redirect_uri" : ZYAppRedirectUri,
       @"code" : requestToken
       } success:^(id JSON) {
           // 保存账号信息
           Account *account = [[Account alloc] init];
           account.accessToken = JSON[@"access_token"];
           account.uid = JSON[@"uid"];
           [[AccountTool sharedAccountTool] saveAccount:account];
           
           // 回到主页面
           self.view.window.rootViewController = [[MainController alloc] init];
            // 清除指示器
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
       } failure:^(NSError *error) {
           // 清除指示器
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
       }];
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
