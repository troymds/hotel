//
//  ZYAnnotation.m
//  ZYAnnotationMaps
//
//  Created by wxg on 14-6-16.
//  Copyright (c) 2014年 wxg. All rights reserved.
//

#import "ZYAnnotation.h"

@implementation ZYAnnotation

- (id)initWithAddress:(ZYAddress *)adress
{
    self = [super init];
    if (self) {
        self.adress = adress;
    }
    return self;
}
+ (id)annotationWithAdress:(ZYAddress *)adress
{
    return [[self alloc] initWithAddress:adress];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D tempCoordinate;
    tempCoordinate.latitude = self.adress.latitude;
    tempCoordinate.longitude = self.adress.longitude;
    return tempCoordinate;
}

- (NSString *)title
{
    return self.adress.name;
}
- (NSString *)subtitle
{
    return self.adress.address;
}

@end

@implementation ZYAddress
@end
