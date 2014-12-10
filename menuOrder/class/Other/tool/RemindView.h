//
//  RemindView.h
//  PEM
//
//  Created by tianj on 14-9-18.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    TOP = 0,
    MIDDLE,
    BELLOW
    
}LocationType;


@interface RemindView : NSObject

+ (void)showViewWithTitle:(NSString *)title location:(LocationType)location;

@end
