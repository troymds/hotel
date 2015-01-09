//
//  CarTool.m
//  menuOrder
//
//  Created by promo on 14-12-24.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "CarTool.h"
#import "MenuModel.h"

@interface CarTool()
{
    NSMutableArray *_menuArray;//记录购物车里的物品
}

@end

@implementation CarTool
singleton_implementation(CarTool)

- (id)init
{
    if (self = [super init]) {
        // 1.加载沙盒中的购物车数据
        _totalCarMenu = [NSKeyedUnarchiver unarchiveObjectWithFile:kFilePath];
        
        // 2.第一次没有购物车数据
        if (_totalCarMenu == nil) {
            _totalCarMenu = [NSMutableArray array];
        }
    }
    return self;
}

#pragma mark 增加购物车菜品
-(void)addMenu:(MenuModel *) menu
{
    if (_totalCarMenu) {
        BOOL alreadyExist = NO;
        for (int i = 0; i < _totalCarMenu.count; i++) {
            MenuModel *data = _totalCarMenu[i];
            if ([menu.ID isEqualToString:data.ID]) {
                //如果找到了，直接把数量＋1
                data.foodCount++;
//                NSLog(@"已经存在的增加的ID为%@的数量%d",data.ID,data.foodCount);
                alreadyExist = YES;
            }
        }
        if (!alreadyExist) {
            menu.foodCount++;
            menu.isChosen = YES;
//            NSLog(@"第一次增加的ID为%@的数量%d",menu.ID,menu.foodCount);
            [_totalCarMenu addObject:menu];
        }
        
        [NSKeyedArchiver archiveRootObject:_totalCarMenu toFile:kFilePath];
    }
}

#pragma mark 减少购物车菜品
-(void)plusMenu:(MenuModel *) menu
{
    if (_totalCarMenu) {
        
        BOOL alreadyExist = NO;
        for (int i = 0; i < _totalCarMenu.count; i++) {
            MenuModel *data = _totalCarMenu[i];
            if ([menu.ID isEqualToString:data.ID]) {//注意，减少的一定是_totalCarMenu里面的data，不然就歇菜拉拉
                alreadyExist = YES;
                data.foodCount--;
//                NSLog(@"已经存在的减完后ID%@的数量%d",menu.ID,menu.foodCount);
                if (data.foodCount == 0) {
//                   NSLog(@"已经存在的减完后ID为0%@的数量%d",menu.ID,menu.foodCount);
                    [_totalCarMenu removeObject:data];
                }
            }
        }
        [NSKeyedArchiver archiveRootObject:_totalCarMenu toFile:kFilePath];
    }
}

#pragma mark 计算
- (NSMutableArray *)totalCarMenu
{
    
    return _totalCarMenu;
}
@end
