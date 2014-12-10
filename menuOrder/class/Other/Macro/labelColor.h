//
//  labelColor.h
//  PEM
//
//  Created by YY on 14-10-9.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface labelColor : UIView
typedef enum _MutiTextAlignmentType
{
    Muti_Alignment_Left_Type = 0x20,
    Muti_Alignment_Mid_Type = 0x21,
    Muti_Alignment_Right_Type = 0x22,
}MutiTextAlignmentType;
@property(nonatomic)MutiTextAlignmentType alignmentType;

-(void)setShowText:(NSString*)text Setting:(NSArray*)setDictionary;

@end
