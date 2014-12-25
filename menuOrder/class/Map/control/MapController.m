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
@property (strong,nonatomic) CLLocationManager *lm;

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
       
        [self addLoadStatus];

    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNaviPoints];
    //    [self initAnnotations];
    
    // 初始化travel方式为驾车方式
    self.travelType = TravelTypeCar;
    
    
    [self configMapView];
}
- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:YES];
    
}
//#pragma mark ----加载数据
-(void)addLoadStatus{
    [mapTool mapStatusesWithSuccess:^(NSArray *statues) {
        NSDictionary *dict =[statues objectAtIndex:0];
        _fishLat =[dict objectForKey:@"lat"];
        _fishLong =[dict objectForKey:@"long"];
        _fishTel=[dict objectForKey:@"tel"];
        
        [self addUIView];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)addUIView{
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
        
        
        
        
        NSArray *startPoints = @[_startPoint];
        NSArray *endPoints   = @[_endPoint];
        
        if (self.travelType == TravelTypeCar)
        {
            [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
        }
        else
        {
            [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
        }
        
        
        
        
        _locChange = YES;
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
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imageView.image = [UIImage imageNamed:@"tab_index_pre@2x.png"];
        pointAnnotationView.RightCalloutAccessoryView = imageView;
        pointAnnotationView.animatesDrop   = NO;
        pointAnnotationView.canShowCallout = YES;
        pointAnnotationView.draggable      = NO;
        
        NavPointAnnotation *navAnnotation = (NavPointAnnotation *)annotation;
        
        if (navAnnotation.navPointType == NavPointAnnotationStart)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
        }
        else if (navAnnotation.navPointType == NavPointAnnotationEnd)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorRed];
//            [pointAnnotationView setImage:[UIImage imageNamed:@"tab_index_pre@2x.png"]];
            
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
        
        polylineView.lineWidth   = 5.0f;
        polylineView.strokeColor = [UIColor blueColor];
        
        return polylineView;
    }
    return nil;
}




@end
