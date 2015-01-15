//
//  MapController.m
//  menuOrder
//
//  Created by promo on 14-12-9.
//  Copyright (c) 2014年 promo. All rights reserved.
//

#import "MapController.h"
#import "mapTool.h"
#import "phoneView.h"
#import "NavPointAnnotation.h"
#import "APIKey.h"
#define kSetingViewHeight   20.f
#define KStartY 20
typedef NS_ENUM(NSInteger, NavigationTypes)
{
    NavigationTypeNone = 0,
    NavigationTypeSimulator, // 模拟导航
    NavigationTypeGPS,       // 实时导航
};

typedef NS_ENUM(NSInteger, TravelTypes)
{
    TravelTypeCar = 0,    // 驾车方式
    TravelTypeWalk,       // 步行方式
};


@interface MapController ()<AMapNaviViewControllerDelegate,CLLocationManagerDelegate>{
    
     CLLocationCoordinate2D _coordinate;
    CGFloat starY;
}

@property (nonatomic, strong) AMapNaviPoint         *startPoint;
@property (nonatomic, strong) AMapNaviPoint         *endPoint;

@property (nonatomic,strong) AMapNaviPoint          *currentPoint;
@property (strong,nonatomic) CLLocationManager *locationManager;

@property (nonatomic,assign) BOOL       locChange;
@property(nonatomic,copy)NSString *fishLong;
@property(nonatomic,copy)NSString *fishLat;
@property(nonatomic,copy)NSString *fishTel;
@property(nonatomic,copy)NSString *fishshop_name;
@property(nonatomic,copy)NSString *fishaddress;


@property (nonatomic, strong) NSArray *annotations;

@property (nonatomic, strong) MAPolyline *polyline;

@property (nonatomic) BOOL calRouteSuccess; // 指示是否算路成功

@property (nonatomic) NavigationTypes naviType;
@property (nonatomic) TravelTypes travelType;


@end

@implementation MapController
- (id)init
{
    self = [super init];
    if (self)
    {
        [self configureAPIKey];
        [self addLoadStatus];
        
    }
    return self;
}


- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"apiKey为空，请检查key是否正确设置" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [AMapNaviServices sharedServices].apiKey = (NSString *)APIKey;
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        starY = KStartY;
    }else
    {
        starY = 0;
    }
    
    
    [self initNaviPoints];
    [self addLocationManagerView];
    
    // 初始化travel方式为驾车方式
    self.travelType = TravelTypeCar;
    
    // NSLog(@"1111%@",_startPoint);
    [self configMapView];
}
- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:YES];
    //     NSLog(@"2222%@",_startPoint);
    
    
}
-(void)addLocationManagerView{
    _locationManager =[[CLLocationManager alloc]init];
    _locationManager.delegate =self;
    _locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    _locationManager.distanceFilter=10;
    
    if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization]; // 永久授权
    }
    [_locationManager startUpdatingLocation];
}
//#pragma mark ----加载数据
-(void)addLoadStatus
{
    [mapTool mapStatusesWithSuccess:^(NSArray *statues) {
        NSDictionary *dict =[statues objectAtIndex:0];
        _fishLat =[dict objectForKey:@"lat"];
        _fishLong =[dict objectForKey:@"long"];
        _fishTel=[dict objectForKey:@"tel"];
        _fishaddress=[dict objectForKey:@"address"];
        _fishshop_name=[dict objectForKey:@"shop_name"];
        
        [self addUIView];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_locationManager stopUpdatingLocation];
}
-(void)addUIView
{
    
    UIButton *phoneTel = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneTel.backgroundColor =[UIColor clearColor];
    [phoneTel setImage:[UIImage imageNamed:@"Tel"] forState:UIControlStateNormal];
    [phoneTel setImage:[UIImage imageNamed:@"Tel_rep"] forState:UIControlStateHighlighted];
    
    [phoneTel addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    phoneTel.frame = CGRectMake(kWidth-85, kHeight-210, 55, 73);
    [self.view addSubview:phoneTel];
    [self.view bringSubviewToFront:phoneTel];
    
}



- (void)configMapView
{
    if (self.myMapView == nil)
    {
        self.myMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, starY, kWidth, kHeight-starY)];
    }
    
    self.myMapView.showsScale = NO;
    [self.myMapView setDelegate:self];
    [self.myMapView setFrame:CGRectMake(0, starY,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height - starY)];
    [self.view insertSubview:self.myMapView atIndex:0];
    
    
    self.myMapView.showsUserLocation = YES;
    
    
    if (self.naviManager == nil)
    {
        _naviManager = [[AMapNaviManager alloc] init];
        [_naviManager setDelegate:self];
    }
    
    
}

#pragma mark 打电话
-(void)phoneBtnClick{
    [phoneView callPhoneNumber:_fishTel call:^(NSTimeInterval duration) {
    } cancel:^{
        
    } finish:^{
        
    }];
}

#pragma mark - Construct and Inits

- (void)initNaviPoints
{
    CGFloat mapLat;
    CGFloat mapLong;
    mapLat =[_fishLat floatValue];
    mapLong =[_fishLong floatValue];
    
    _endPoint   = [AMapNaviPoint locationWithLatitude:mapLat   longitude:mapLong];
    
    
    
}


- (void)initAnnotations
{
    NavPointAnnotation *beginAnnotation = [[NavPointAnnotation alloc] init];
    
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    beginAnnotation.title        = @"起始点";
    beginAnnotation.navPointType = NavPointAnnotationStart;
    
    NavPointAnnotation *endAnnotation = [[NavPointAnnotation alloc] init];
    
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude)];
    
    endAnnotation.title        = _fishshop_name;
    
    
    endAnnotation.subtitle =[NSString stringWithFormat:@"地址：%@",_fishaddress ];
    
    endAnnotation.navPointType = NavPointAnnotationEnd;
    
    [self.myMapView selectAnnotation:endAnnotation animated:NO];
    
    self.annotations = @[beginAnnotation, endAnnotation];
    
         NSLog(@"4444%@",_startPoint);
    if (_startPoint==nil) {
        [RemindView showViewWithTitle:@"算路失败" location:MIDDLE];
    }
    
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    _currentPoint = [AMapNaviPoint locationWithLatitude:mapView.userLocation.location.coordinate.latitude longitude:mapView.userLocation.location.coordinate.longitude];
    
    
    if (_locChange == NO)
    {
        NSLog(@"%f------%f",self.myMapView.userLocation.location.coordinate.latitude,self.myMapView.userLocation.location.coordinate.longitude);
        _coordinate.latitude = userLocation.location.coordinate.latitude;
        _coordinate.longitude = userLocation.location.coordinate.longitude;
        
//        [self setMapRegionWithCoordinate:_coordinate];


        _startPoint = _currentPoint;
        
                 NSLog(@"5555%@",_startPoint);
        [self initAnnotations];
        if (_calRouteSuccess)
        {
            [self.myMapView addOverlay:_polyline];
        }
        
        if (self.annotations.count > 0)
        {
            [self.myMapView addAnnotations:self.annotations];
        }
        
        
        NSArray *startPoints = @[_startPoint];
        NSArray *endPoints   = @[_endPoint];
        if (self.travelType == TravelTypeCar)
        {
            [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
            
        }
        else
        {
            [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
        }
        
        _locChange = YES;
        
    }
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8)
    {
        [_locationManager requestAlwaysAuthorization];
        [_locationManager startUpdatingLocation];
        
    }else{
        
    }
    
    
}
- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
{
//    MKCoordinateRegion region;
    MACoordinateRegion region;
//    region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(.1, .1));
    region =MACoordinateRegionMake(coordinate, MACoordinateSpanMake(.1, .1));
    MACoordinateRegion adjustedRegion = [self.myMapView regionThatFits:region];
    [self.myMapView setRegion:adjustedRegion animated:YES];
}


#pragma mark - AMapNaviManager Delegate


- (void)AMapNaviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    //    [super AMapNaviManagerOnCalculateRouteSuccess:naviManager];
    
    
    if (naviManager.naviRoute == nil)
    {
        return;
    }
    
    [self.myMapView removeOverlays:self.myMapView.overlays];
    
    NSUInteger coordianteCount = [naviManager.naviRoute.routeCoordinates count];
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [naviManager.naviRoute.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [self.myMapView addOverlay:polyline];
    [self.myMapView setVisibleMapRect:[polyline boundingMapRect] animated:NO];
    
    //     NSLog(@"8888%@",_startPoint);
    
    _calRouteSuccess = YES;
}


#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NavPointAnnotation class]])
    {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        
        MAPinAnnotationView *pointAnnotationView = (MAPinAnnotationView*)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil)
        {
            pointAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:annotationIdentifier];
        }
        pointAnnotationView.animatesDrop   = NO;
        pointAnnotationView.canShowCallout = YES;
        pointAnnotationView.draggable      = NO;
        //         NSLog(@"999999%@",_startPoint);
        
        NavPointAnnotation *navAnnotation = (NavPointAnnotation *)annotation;
        
        if (navAnnotation.navPointType == NavPointAnnotationStart)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
            [pointAnnotationView setImage:[UIImage imageNamed:@"star_img.png"]];
        }
        else if (navAnnotation.navPointType == NavPointAnnotationEnd)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorRed];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            pointAnnotationView.RightCalloutAccessoryView = imageView;
            
            [pointAnnotationView setImage:[UIImage imageNamed:@"end_img.png"]];
            imageView.image = [UIImage imageNamed:@"heaar_img"];
            
            
        }
        return pointAnnotationView;
    }
    
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        //         NSLog(@"101010101%@",_startPoint);
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        polylineView.strokeColor = HexRGB(0x7c9de4);
        
        polylineView.lineWidth   = 5.0f;
        return polylineView;
    }
    return nil;
}

#pragma mark 控件将要显示
- (void)viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}



@end
