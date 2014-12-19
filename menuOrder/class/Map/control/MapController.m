//
//  MapController.m
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MapController.h"
#import <MapKit/MapKit.h>
#import "phoneView.h"
@interface MapController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView *_mapView;
    UIImageView *routeView;
    MKPolyline *routeLine;
    MKPolygonView *routeLineView;
}


@end

@implementation MapController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"地图";
    self.view.backgroundColor = [UIColor orangeColor];
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    _mapView =[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_mapView];
    _mapView.delegate =self;
    _mapView.showsUserLocation = YES;
    _mapView.userLocation.title = @"当前位置";

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"定位" forState:UIControlStateNormal];
    [button setTitleColor:HexRGB(0x899c02) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(220, 20, 100, 50);
    [_mapView addSubview:button];
    
    UIButton *phoneTel = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneTel.backgroundColor =[UIColor clearColor];
    [phoneTel setImage:[UIImage imageNamed:@"Tel"] forState:UIControlStateNormal];
    [phoneTel setImage:[UIImage imageNamed:@"Tel_rep"] forState:UIControlStateHighlighted];

    [phoneTel addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    phoneTel.frame = CGRectMake(kWidth-85, kHeight-210, 55, 73);
    [self.view addSubview:phoneTel];
    [self.view bringSubviewToFront:phoneTel];

    for (int i=0; i<100; i++) {
        ZYAddress *address = [[ZYAddress alloc] init];
        address.latitude = 118.772698 + i*0.001;
        address.longitude = 32.074764 + i*0.001;
        address.name = [NSString stringWithFormat:@"紫金渔府%d", i];
        address.address = [NSString stringWithFormat:@"江苏南京鼓楼水佐岗鼓楼区水佐岗老菜市%d路", i];
        
        ZYAnnotation *annotation = [ZYAnnotation annotationWithAdress:address];
        [_mapView addAnnotation:annotation];
    }
    
    
    //一个经纬度的结构体数组
    CLLocationCoordinate2D  points[4];
    points[0] = CLLocationCoordinate2DMake(41.000512, -109.050116);
    points[1] = CLLocationCoordinate2DMake(41.002371, -102.052066);
    points[2] = CLLocationCoordinate2DMake(36.993076, -102.041981);
    points[3] = CLLocationCoordinate2DMake(36.99892, -109.045267);

    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager.delegate=self;//设置代理
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    locationManager.distanceFilter=1000.0f;//设置距离筛选器
    [locationManager startUpdatingLocation];//启动位置管理器
    MKCoordinateSpan theSpan;
    //    //地图的范围 越小越精确
    theSpan.latitudeDelta=0.05;
    theSpan.longitudeDelta=0.05;
    MKCoordinateRegion theRegion;
    theRegion.center=[[locationManager location] coordinate];
    theRegion.span=theSpan;
    [_mapView setRegion:theRegion];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)phoneBtnClick{
    [phoneView callPhoneNumber:@"13913008373" call:^(NSTimeInterval duration) {
        
    } cancel:^{
        
    } finish:^{
        
    }];
}
//如果要想覆盖物显示出来，那么必须实现该协议方法，而且需要创建对应的渲染器进行渲染（创建对应的画笔，把该图形绘制出来）
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        //创建一个多边形渲染器
        MKPolygonRenderer* aRenderer = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon*)overlay];
        //填充色
        aRenderer.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        //边框的颜色，线条的颜色
        aRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        //线条的宽度
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    else if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer *aRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        //填充色
        aRenderer.fillColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];
        //边框的颜色，线条的颜色
        aRenderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        //线条的宽度
        aRenderer.lineWidth = 3;
        
        return aRenderer;
    }
    
    else if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        //边框的颜色，线条的颜色
        aRenderer.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        //线条的宽度
        aRenderer.lineWidth = 3;
        
        return aRenderer;
    }
    
    return nil;
}

- (void)buttonClick:(id)sender
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_mapView.userLocation.coordinate, 1000, 1000);
    MKCoordinateRegion newRegion = [_mapView regionThatFits:region];
    [_mapView setRegion:newRegion animated:YES];
}

//该协议方法可实现也可不实现，如果return nil就相当于没是实现
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    static NSString *identifier = @"AnnotationView";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (nil == annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    //用户所在的位置使用默认的蓝点，其他地方使用自定义大头针
    if (mapView.userLocation == annotation) {
        //用户当前的位置
        //return nil就相当于你没写这个协议方法
        return nil;
    }
    
    //更改大头针的图片
    annotationView.image = [UIImage imageNamed:@"heaar_img"];
    //更改大头针的颜色
    annotationView.pinColor = MKPinAnnotationColorPurple;
    
    //如果实现该协议方法，默认不会显示气泡
    annotationView.canShowCallout = YES;
    
    //添加右视图
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = button;
    
    //添加左视图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imgTask6.png"]];
    imageView.bounds = CGRectMake(0, 0, 30, 30);
    annotationView.leftCalloutAccessoryView = imageView;
    
    return annotationView;
}

//当点击气泡的时候会调用该协议方法
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
}


- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [_mapView setVisibleMapRect:[routeLine boundingMapRect]];
    [_mapView addOverlay:routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
}

//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay
//{
//    if(overlay == routeLine) {
//        if(nil == routeLineView) {
//            routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine];
//            routeLineView.fillColor = [UIColor redColor];
//            routeLineView.strokeColor = [UIColor redColor];
//            routeLineView.lineWidth = 5;
//        }
//        return routeLineView;
//    }
//    return nil;
//}
@end
