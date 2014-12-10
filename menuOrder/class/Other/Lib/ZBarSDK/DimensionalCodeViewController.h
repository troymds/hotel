//
//  DimensionalCodeViewController.h
//  Teddybear
//
//  Created by lifei on 14-10-20.
//  Copyright (c) 2014年 chunxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DimensionalCodeViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic,strong) NSURL* url;
@property (nonatomic,copy) NSString* titleL;
@end
