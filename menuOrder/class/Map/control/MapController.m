//
//  MapController.m
//  menuOrder
//
//  Created by YY on 15-1-13.
//  Copyright (c) 2015年 promo. All rights reserved.
//

#import "MapController.h"
#import <MapKit/MapKit.h>
#import "mapTool.h"
#import "phoneView.h"
#define KStartY 20
@interface MapController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationCoordinate2D _coordinate;
    CLLocationManager *locationManager;
    CGFloat starY;
    BOOL catClickFlage;
    
    
}
@property (strong, nonatomic)  MKMapView *mapView;
@property(nonatomic,assign)CGFloat fishLong;
@property(nonatomic,assign)CGFloat fishLat;
@property(nonatomic,copy)NSString * fishTel;
@property(nonatomic,copy)NSString *fishshop_name;
@property(nonatomic,copy)NSString *fishaddress;
@property (nonatomic,strong)  MKPointAnnotation   *currentPoint;

@property (nonatomic,assign) BOOL       locChange;



@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        starY = KStartY;
    }else
    {
        starY = 0;
    }
    
    [self addLoadStatus];
    locationManager = [[CLLocationManager alloc] init];
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization]; // 永久授权
        [locationManager requestWhenInUseAuthorization]; //使用中授权
    }
    [locationManager startUpdatingLocation];
    NSLog(@"3333%f-----%f",_coordinate.latitude,_coordinate.longitude);
    
    catClickFlage =YES;
    NSLog(@"ffffffffff;");
    
}

//#pragma mark ----加载数据
-(void)addLoadStatus
{
    [mapTool mapStatusesWithSuccess:^(NSArray *statues) {
        NSDictionary *dict =[statues objectAtIndex:0];
        _fishLat =[[dict objectForKey:@"lat"]floatValue];
        _fishLong =[[dict objectForKey:@"long"]floatValue];
        _fishTel=[dict objectForKey:@"tel"];
        _fishaddress=[dict objectForKey:@"address"];
        _fishshop_name=[dict objectForKey:@"shop_name"];
        NSLog(@"bbbbbbbbb;");
        [self addUIView];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)addUIView
{NSLog(@"ssssssssss;");
    self.mapView =[[MKMapView alloc]initWithFrame:CGRectMake(0, starY, kWidth, kHeight-starY)];
    [self.view addSubview:self.mapView];
    self.mapView.delegate =self;
    
    self.mapView.showsUserLocation = YES;
    
    
    UIButton *phoneTel = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneTel.backgroundColor =[UIColor clearColor];
    [phoneTel setImage:[UIImage imageNamed:@"Tel"] forState:UIControlStateNormal];
    [phoneTel setImage:[UIImage imageNamed:@"Tel_rep"] forState:UIControlStateHighlighted];
    
    [phoneTel addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    phoneTel.frame = CGRectMake(kWidth-85, kHeight-150, 55, 73);
    [self.view addSubview:phoneTel];
    [self.view bringSubviewToFront:phoneTel];
    //设置起始点
    
    CLLocationManager *locationManager1 = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager1.delegate=self;//设置代理
    locationManager1.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    locationManager1.distanceFilter=1000.0f;//设置距离筛选器
    [locationManager1 startUpdatingLocation];//启动位置管理器
    
    MKCoordinateRegion theRegion1 = { _coordinate.latitude,  _coordinate.latitude };
    theRegion1.center=[[locationManager1 location] coordinate];
    
    [self.mapView setRegion:theRegion1 animated:YES];
    
    CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(_fishLat, _fishLong);
    MKPointAnnotation *annotation2=[[MKPointAnnotation alloc]init];
    annotation2.title=_fishshop_name;
    
    annotation2.subtitle=[NSString stringWithFormat:@"地址：%@",_fishaddress ];
    annotation2.coordinate=location2;
    [_mapView addAnnotation:annotation2];
}
#pragma mark ---设置起始点
-(void)addStarPoint{
    CLLocationCoordinate2D location=_coordinate;
    MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
    annotation.title=@"当前位置";
    annotation.coordinate=location;
    [_mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    MKPinAnnotationView *pinView = nil;
    if(annotation != self.mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        if (annotation.coordinate.latitude==_fishLat)
        {
            [pinView setImage:[UIImage imageNamed:@"end_img.png"]];
            //            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            //            pinView.RightCalloutAccessoryView = imageView;
            //            imageView.image = [UIImage imageNamed:@"heaar_img"];
        }
        else
        {
            pinView.pinColor=MKPinAnnotationColorGreen;
            [pinView setImage:[UIImage imageNamed:@"star_img.png"]];
            
        }
        
        
        
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    }
    else {
        [self.mapView.userLocation setTitle:@"当前位置"];
        [self goSearch];
        
    }
    return pinView;
}
#pragma mark 打电话
-(void)phoneBtnClick{
    [phoneView callPhoneNumber:_fishTel call:^(NSTimeInterval duration) {
    } cancel:^{
        
    } finish:^{
        
    }];
}


- (void)goSearch {
    CLLocationCoordinate2D fromCoordinate = _coordinate;
    
    CLLocationCoordinate2D toCoordinate   = CLLocationCoordinate2DMake(_fishLat,_fishLong);
    
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate
                                                       addressDictionary:nil];
    
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toCoordinate
                                                       addressDictionary:nil];
    
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    [self findDirectionsFrom:fromItem
                          to:toItem];
    NSLog(@"888888%f-----%f",_coordinate.latitude,_coordinate.longitude);
    
}

#pragma mark - Private

- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
         if (error) {
             
             NSLog(@"error:%@", error);
         }
         else {
             
             MKRoute *route = response.routes[0];
             
             [self.mapView addOverlay:route.polyline];
         }
     }];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;
    renderer.strokeColor = HexRGB(0x7c9de4);
    return renderer;
    NSLog(@"77777%f-----%f",_coordinate.latitude,_coordinate.longitude);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _coordinate.latitude = userLocation.location.coordinate.latitude;
    _coordinate.longitude = userLocation.location.coordinate.longitude;
    
    [self setMapRegionWithCoordinate:_coordinate];
    
    NSLog(@"999999%f-----%f",_coordinate.latitude,_coordinate.longitude);
    if (catClickFlage==YES) {
        [self addStarPoint];
    }
    catClickFlage =NO;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8)
    {
        [locationManager requestAlwaysAuthorization];
        [locationManager startUpdatingLocation];
        
    }else{
        
    }
    
}

- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion region;
    
    region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(.1, .1));
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
    [_mapView setRegion:adjustedRegion animated:YES];
    
    
    
}

#pragma mark 控件将要显示
- (void)viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}



@end
