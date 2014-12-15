//
//  AppDelegate.m
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "NewfeatureController.h"
#import "SSKeychain.h"
#import "SystemConfig.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "HttpTool.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import "MeController.h"
#import "AccountTool.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //获取用户uuid
    NSString *retrieveuuid = [SSKeychain passwordForService:@"cn.chinapromo.userinfo" account:@"uuid"];
    if (retrieveuuid == nil || [retrieveuuid isEqualToString:@""]) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid!=NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        retrieveuuid = [NSString stringWithFormat:@"%@",uuidStr];
        [SSKeychain setPassword:retrieveuuid forService:@"cn.chinapromo.userinfo" account:@"uuid"];
    }
    [SystemConfig sharedInstance].uuidStr = retrieveuuid;
    
    
    //    NSString *key = (NSString *)kCFBundleVersionKey;
    NSString *key = @"CFBundleShortVersionString";
    // 1.从Info.plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    // 2.从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (saveVersion) {
        [self checkVersion];
    }
    
    if ([version isEqualToString:saveVersion]) { // 不是第一次使用这个版本
        // 显示状态栏
        application.statusBarHidden = NO;
         self.window.rootViewController = [[MainController alloc] init];
//        if ([AccountTool sharedAccountTool].account) {
//            self.window.rootViewController = [[MainController alloc] init];
//        } else {
//            self.window.rootViewController = [[MeController alloc] init];
//        }
       } else { // 版本号不一样：第一次使用新版本
        // 将新版本号写入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 显示版本新特性界面
        application.statusBarHidden = YES;
        self.window.rootViewController = [[NewFeatureController alloc] init];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
     [self shareRegister];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)checkVersion
{
    __weak AppDelegate *weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"os", nil];
    [HttpTool postWithPath:@"getNewestVersion" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            NSString *key = @"CFBundleShortVersionString";
            NSString *version = [NSBundle mainBundle].infoDictionary[key];
            NSString *current = [dic objectForKey:@"version"];
            if (![current isEqualToString:version]) {
                weakSelf.updateUrl = [dic objectForKey:@"url"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:nil delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"立即升级", nil];
                [alertView show];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)shareRegister
{
    //分享
    [ShareSDK registerApp:shareAppKey];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                              redirectUri:@"http://www.sharesdk.cn"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:WXAppId
                           wechatCls:[WXApi class]];
    
    //短信分享
    [ShareSDK connectSMS];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.updateUrl&&self.updateUrl.length!=0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
