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
#define kSetingViewHeight   0.f

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


@interface MapController ()<AMapNaviViewControllerDelegate>

@property (nonatomic, strong) AMapNaviPoint         *startPoint;
@property (nonatomic, strong) AMapNaviPoint         *endPoint;

@property (nonatomic,strong) AMapNaviPoint          *currentPoint;
@property (strong,nonatomic) CLLocationManager *locationManager;

@property (nonatomic,assign) BOOL       locChange;
@property(nonatomic,copy)NSString *fishLong;
@property(nonatomic,copy)NSString *fishLat;
@property(nonatomic,copy)NSString *fishTel;



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
    [self initNaviPoints];
    //    [self initAnnotations];
    
    // 初始化travel方式为驾车方式
    self.travelType = TravelTypeCar;
    _locationManager =[[CLLocationManager alloc]init];

    [self configMapView];
}
- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:YES];
    
}
//#pragma mark ----加载数据
-(void)addLoadStatus
{
    [mapTool mapStatusesWithSuccess:^(NSArray *statues) {
        NSDictionary *dict =[statues objectAtIndex:0];
        _fishLat =[dict objectForKey:@"lat"];
        _fishLong =[dict objectForKey:@"long"];
        _fishTel=[dict objectForKey:@"tel"];
        
        [self addUIView];
        
    } failure:^(NSError *error) {
        
    }];
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
    self.myMapView.showsScale = NO;
    [self.myMapView setDelegate:self];
    [self.myMapView setFrame:CGRectMake(0, kSetingViewHeight,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height - kSetingViewHeight)];
    [self.view insertSubview:self.myMapView atIndex:0];
    
    
    self.myMapView.showsUserLocation = YES;
    
    
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
    
    _startPoint =[AMapNaviPoint locationWithLatitude:32.035729   longitude:118.793396];;
    
    
}


- (void)initAnnotations
{
    NavPointAnnotation *beginAnnotation = [[NavPointAnnotation alloc] init];
    
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    beginAnnotation.title        = @"起始点";
    beginAnnotation.navPointType = NavPointAnnotationStart;
    
    NavPointAnnotation *endAnnotation = [[NavPointAnnotation alloc] init];
    
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude)];
    
    endAnnotation.title        = @"紫金渔府";
    endAnnotation.subtitle =@"地址：鼓楼区老菜市场";
    
    endAnnotation.navPointType = NavPointAnnotationEnd;
    
    
    
    self.annotations = @[beginAnnotation, endAnnotation];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    
    
    _currentPoint = [AMapNaviPoint locationWithLatitude:mapView.userLocation.location.coordinate.latitude longitude:mapView.userLocation.location.coordinate.longitude];
   
    
    if (_locChange == NO)
    {
        _startPoint = _currentPoint;
        [self initAnnotations];
        
        if (_calRouteSuccess)
        {
            [self.myMapView addOverlay:_polyline];
        }
        
        if (self.annotations.count > 0)
        {
            [self.myMapView addAnnotations:self.annotations];
        }

        NSLog(@"11111%@",_startPoint);
        
        NSArray *startPoints = @[_startPoint];
        NSArray *endPoints   = @[_endPoint];
        
        if (self.travelType == TravelTypeCar)
        {
            NSLog(@"22222%@",_startPoint);
            [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
            NSLog(@"444444444");
//            [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
        }
        else
        {
            [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
            NSLog(@"3333333%@",_startPoint);
        }

        NSLog(@"55555555%@",_startPoint);
       
       
        
        _locChange = YES;
        
    }
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8)
    {
        [_locationManager requestAlwaysAuthorization];
        [_locationManager startUpdatingLocation];

    }else{
        
    }

    
}



#pragma mark - AMapNaviManager Delegate

- (void)AMapNaviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error
{
    [super AMapNaviManager:naviManager onCalculateRouteFailure:error];
}


- (void)AMapNaviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    [super AMapNaviManagerOnCalculateRouteSuccess:naviManager];
    
    
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
    
    
    
    _calRouteSuccess = YES;
}


- (void)AMapNaviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    [super AMapNaviManager:naviManager didPresentNaviViewController:naviViewController];
    
    // 初始化语音引擎
    [self initIFlySpeech];
    
    if (self.naviType == NavigationTypeGPS)
    {
        [self.naviManager startGPSNavi];
    }
    else if (self.naviType == NavigationTypeSimulator)
    {
        [self.naviManager startEmulatorNavi];
    }
}


#pragma mark - AManNaviViewController Delegate

- (void)AMapNaviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (self.naviType == NavigationTypeGPS)
    {
        [self.iFlySpeechSynthesizer stopSpeaking];
        
        self.iFlySpeechSynthesizer.delegate = nil;
        self.iFlySpeechSynthesizer          = nil;
        
        [self.naviManager stopNavi];
    }
    else if (self.naviType == NavigationTypeSimulator)
    {
        [self.iFlySpeechSynthesizer stopSpeaking];
        
        self.iFlySpeechSynthesizer.delegate = nil;
        self.iFlySpeechSynthesizer          = nil;
        
        [self.naviManager stopNavi];
    }
    
    [self.naviManager dismissNaviViewControllerAnimated:YES];
    
    // 退出导航界面后恢复地图的状态
    [self configMapView];
}


- (void)AMapNaviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (naviViewController.viewShowMode == AMapNaviViewShowModeCarNorthDirection)
    {
        naviViewController.viewShowMode = AMapNaviViewShowModeMapNorthDirection;
    }
    else
    {
        naviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
    }
}


- (void)AMapNaviViewControllerTrunIndicatorViewTapped:(AMapNaviViewController *)naviViewController
{
    [self.naviManager readNaviInfoManual];
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
        
        NavPointAnnotation *navAnnotation = (NavPointAnnotation *)annotation;
        
        if (navAnnotation.navPointType == NavPointAnnotationStart)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
            [pointAnnotationView setImage:[UIImage imageNamed:@"star_img.png"]];
//            imageView.image = [UIImage imageNamed:@"heaar_img"];

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
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        polylineView.strokeColor = HexRGB(0x7c9de4);

        polylineView.lineWidth   = 5.0f;
        polylineView.layer.cornerRadius=0;
        polylineView.layer.borderWidth=2.0;
        polylineView.layer.masksToBounds = YES;
        polylineView.layer.borderColor=[UIColor colorWithRed:85.0/255.0 green:113.0/255.0 blue:219.0/255.0 alpha:1 ] .CGColor;
        
        return polylineView;
    }
    return nil;
}




@end
