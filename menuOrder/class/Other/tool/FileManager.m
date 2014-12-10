//
//  FileManager.m
//  PEM
//
//  Created by tianj on 14-9-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager



+ (NSString *)getPathForDocuments
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [path objectAtIndex:0];
}

+(NSString *)getPathForChche
{
    NSArray *path =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",path);
    return [path objectAtIndex:0];
}


+ (void)writeDictionary:(NSDictionary *)data toPath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [fm createFileAtPath:path contents:nil attributes:nil];
    }
    [data writeToFile:path atomically:YES];
}

+(void)writeArray:(NSArray *)data toPath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [fm createFileAtPath:path contents:nil attributes:nil];
    }
    [data writeToFile:path atomically:YES];
}

+ (NSArray *)readArrayFromPath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]){
        return nil;
    }
    return [NSArray arrayWithContentsOfFile:path];
}

+ (NSDictionary *)readDictionaryFromPath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]){
        return nil;
    }
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (BOOL)fileExistAtPath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

+ (void)creteDirectory:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fm fileExistsAtPath:path isDirectory:&isDir]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}



@end
