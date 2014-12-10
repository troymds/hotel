//
//  DimensionalCodeViewController.m
//  Teddybear
//
//  Created by lifei on 14-10-20.
//  Copyright (c) 2014年 chunxi. All rights reserved.
//

#import "DimensionalCodeViewController.h"

@interface DimensionalCodeViewController ()
{
    UIWebView *_web;
}
@property (nonatomic, strong) NSString * useAgent;
@end

@implementation DimensionalCodeViewController

//返回
- (void)setBackNaviItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 0,12, 15);
    [button setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)backBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"二维码说明";
   
    [self setBackNaviItem];
}

-(void)viewWillAppear:(BOOL)animated{
    _web =[[UIWebView alloc] initWithFrame:CGRectMake(0,0, kWidth, kHeight-64)];
    _web.delegate=self;
    _web.scrollView.bounces = NO;
    [self.view addSubview:_web];
    
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    self.useAgent = [userAgent stringByAppendingString:@"/ebingoo"];

    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"UserAgent"].length == 0) {
        NSDictionary *dictionnary = [[NSDictionary alloc]initWithObjectsAndKeys:self.useAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    NSURLRequest *request =[[NSURLRequest alloc] initWithURL:self.url];
    [_web loadRequest:request];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (webView == _web) {
        return YES;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
