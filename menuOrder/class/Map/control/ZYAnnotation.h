//
//  ZYAnnotation.h
//  ZYAnnotationMaps
//
//  Created by wxg on 14-6-16.
//  Copyright (c) 2014年 wxg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface ZYAddress : NSObject
@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;
@property NSString *name;

@property NSString *address;
@end

@interface ZYAnnotation : NSObject <MKAnnotation>
@property ZYAddress *adress;
- (id)initWithAddress:(ZYAddress *)adress;
+ (id)annotationWithAdress:(ZYAddress *)adress;
@end

