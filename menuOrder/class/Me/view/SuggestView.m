//
//  SuggestView.m
//  menuOrder
//
//  Created by YY on 14-12-15.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "SuggestView.h"
#import "suggestTool.h"
#define YYBORDER 9
@interface SuggestView ()<UITextViewDelegate>
{
    UILabel *placeholderLabel;
    UITextView *suggestText;
}
@end

@implementation SuggestView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"意见反馈";
    self.view.backgroundColor =HexRGB(0xeeeeee);
    [self addUIView];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

-(void)addLoadStatus{
    [suggestTool statusesWithSuccess:^(NSArray *statues) {
        
    } uid_ID:@"uid" contentStr:suggestText.text failure:^(NSError *error) {
        
    }];
}
-(void)addUIView
{
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBORDER, YYBORDER*2, kWidth-YYBORDER*2, 70)];
    [self.view addSubview:headerImage];
    headerImage.image =[UIImage imageNamed:@"suggest_banner"];
    
    suggestText =[[UITextView alloc]initWithFrame:CGRectMake(YYBORDER, YYBORDER*4+70, kWidth-YYBORDER*2, 200)];
    [self.view addSubview:suggestText];
    suggestText.font =[UIFont systemFontOfSize:PxFont(20)];
    suggestText.delegate =self;
    suggestText.backgroundColor =[UIColor whiteColor];
    suggestText.textColor=HexRGB(0x605e5f);
    suggestText.layer.cornerRadius=CORNERrADIUS;
    suggestText.layer.borderWidth=1.0;
    suggestText.layer.masksToBounds = YES;
    suggestText.layer.borderColor=[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1 ] .CGColor;
    
    
    
    placeholderLabel=[[UILabel alloc]initWithFrame:CGRectMake(YYBORDER+10, YYBORDER*4+70,  kWidth-YYBORDER*2, 30)];
    placeholderLabel.text=@"请输入您对我们的宝贵意见!";
    placeholderLabel.textColor=HexRGB(0x9a9a9a);
    placeholderLabel.font =[UIFont systemFontOfSize:PxFont(20)];
    placeholderLabel.enabled = NO;
    placeholderLabel.backgroundColor =[UIColor clearColor];
    [self.view addSubview:placeholderLabel];
    
    UIButton *commintBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:commintBtn];
    [commintBtn setImage:[UIImage imageNamed:@"suggest_ok.png"] forState:UIControlStateNormal];
    [commintBtn setImage:[UIImage imageNamed:@"suggest_ok_pre.png"] forState:UIControlStateHighlighted];
    commintBtn.frame =CGRectMake(YYBORDER, YYBORDER*4+70+225, kWidth-YYBORDER*2, 40) ;
    [commintBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [suggestText resignFirstResponder];
    
}


#pragma mark 意见反馈
-(void)commitBtnClick{
    [self addLoadStatus];
    if (suggestText.text.length==0) {
        [RemindView showViewWithTitle:@"内容不能为空！" location:MIDDLE];
    }else{
        [RemindView showViewWithTitle:@"已收到您的宝贵意见，我们会尽快改善！" location:MIDDLE];
        placeholderLabel.text=@"请输入您对我们的宝贵意见!";
        suggestText.text =@"";
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length==0) {
        placeholderLabel.text=@"请输入您对我们的宝贵意见!";


    }else{
        placeholderLabel.text =@"";

    }
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
