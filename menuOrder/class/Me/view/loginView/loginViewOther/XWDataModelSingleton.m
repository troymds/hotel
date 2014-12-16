//
//  XWDataModelSingleton.m
//  XinNet
//
//  Created by tianj on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "XWDataModelSingleton.h"

static XWDataModelSingleton *_instance;
static NSString *xwFileBaseDir = @"httd";
const static NSString *archiveFileName = @"XWihone.dat";

@implementation XWDataModelSingleton

+ (XWDataModelSingleton *)shareInstance
{
    @synchronized(self) {
        
        if (_instance == nil) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *dir = [paths objectAtIndex:0];
            dir = [dir stringByAppendingPathComponent:@"Caches"];
            dir = [dir stringByAppendingPathComponent:xwFileBaseDir];
            
            NSFileManager *fm = [NSFileManager defaultManager];
            BOOL isDir = YES;
            if (![fm fileExistsAtPath:dir isDirectory:&isDir]) {
                [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            NSString *documentDirectory = dir;
            NSString* archivePath =[documentDirectory stringByAppendingFormat:@"/%@", archiveFileName];
            _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        }
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}


- (BOOL)archive{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    dir = [dir stringByAppendingPathComponent:@"Caches"];
    dir = [dir stringByAppendingPathComponent:xwFileBaseDir];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if ([fm fileExistsAtPath:dir isDirectory:&isDir]) {
        [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSString *documentDirectory = dir;
    
    return [NSKeyedArchiver archiveRootObject:self
                                       toFile:[documentDirectory stringByAppendingFormat:@"/%@", archiveFileName]];
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userItem forKey:@"user"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.userItem = [aDecoder decodeObjectForKey:@"user"];
    }
    
    return self;
}


@end
