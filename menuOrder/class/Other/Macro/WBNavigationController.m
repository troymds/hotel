
#import "WBNavigationController.h"
#import "UIImage+MJ.h"

@interface WBNavigationController ()

@end

@implementation WBNavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.appearance方法返回一个导航栏的外观对象
    // 修改了这个外观对象，相当于修改了整个项目中的外观
    UINavigationBar *bar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
    bar.backgroundColor =RGBNAVbackGroundColor;
    UIImage *navBack = [UIImage resizedImage:@"nav_bg"];
    if (IsIos7) {
        [bar setBackgroundImage:navBack forBarMetrics:UIBarMetricsDefault];

    }else{
        [bar setBackgroundImage:navBack forBarMetrics:UIBarMetricsDefault];

    }
    // 3.设置导航栏文字的主题
    [bar setTitleTextAttributes:@{
      UITextAttributeTextColor : [UIColor whiteColor],
      UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero] ,UITextAttributeFont:[UIFont systemFontOfSize:18]
     }];
    
    // 4.修改所有UIBarButtonItem的外观
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
        // 修改item上面的文字样式
    NSDictionary *dict = @{
                           UITextAttributeTextColor : [UIColor blackColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero]
                           };
    [barItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
    
    // 5.设置状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
}

@end
