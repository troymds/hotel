//
//  SuggestView.m
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "SuggestView.h"
#define YYBORDER 9
@interface SuggestView ()

@end

@implementation SuggestView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"意见反馈";
    self.view.backgroundColor =HexRGB(0xeeeeee);
    [self addUIView];
}

-(void)addUIView
{
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBORDER, YYBORDER*2+64, kWidth-YYBORDER*2, 70)];
    [self.view addSubview:headerImage];
    headerImage.image =[UIImage imageNamed:@"suggest_banner"];
    
    UITextView *suggestText =[[UITextView alloc]initWithFrame:CGRectMake(YYBORDER, YYBORDER*4+64+70, kWidth-18, 200)];
    [self.view addSubview:suggestText];
    suggestText.backgroundColor =[UIColor whiteColor];
    
    
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
