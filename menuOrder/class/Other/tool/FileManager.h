//
//  FileManager.h
//  PEM
//
//  Created by tianj on 14-9-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef  enum
{
    DocumentType,
    CacheType
}directoryType;

@interface FileManager : NSObject

+ (NSString *)getPathForDocuments;


+(NSString *)getPathForChche;

+ (void)creteDirectory:(NSString *)path;


+ (void)writeDictionary:(NSDictionary *)data toPath:(NSString *)path;

+(void)writeArray:(NSArray *)data toPath:(NSString *)path;

+ (NSArray *)readArrayFromPath:(NSString *)path;

+ (NSDictionary *)readDictionaryFromPath:(NSString *)path;

+ (BOOL)fileExistAtPath:(NSString *)path;


@end
