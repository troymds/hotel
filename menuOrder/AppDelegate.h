//
//  AppDelegate.h
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"

#define QQAPPID @"1103300585"
#define QQAPPKEY @"0utta5zCiZfvGdDX"
#define shareAppKey @"35fea059bde0"
#define SinaAppKey @"531851719"
#define SinaAppSecret @"a3498ee96939375894170b4746f6d79b"
#define TencentAppKey @"1103300585"
#define TencentAppSecret @"0utta5zCiZfvGdDX"
#define RenrenAppId @"272485"
#define RenrenAppKey @"6789fb614d8941a1a64add0dbb8b70ae"
#define RenrenAppSecret @"3d2a59b71ad145e8b7a5f14256a3be55"
#define WXAppId @"wx4868b35061f87885"
#define WXAppSecret @"b18295032d38ad3da43acad2539b56a7"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSString *updateUrl;
@property (nonatomic,strong) MainController *mainCtl;
@end
