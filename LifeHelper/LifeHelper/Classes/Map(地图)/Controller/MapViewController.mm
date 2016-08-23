//
//  MapViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/8/22.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "WayPointRouteSearchDemoViewController.h"
#import "PoiSearchDemoViewController.h"
#import "UIImage+Rotate.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#pragma mark-路线规划相关
@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end



@interface MapViewController()<BMKMapViewDelegate,BMKLocationServiceDelegate,UITextFieldDelegate,BMKRouteSearchDelegate,BMKPoiSearchDelegate>

{
    UITextField* _cityText;
    UITextField* _keyText;
    UIButton* _nextPageButton;
    BMKPoiSearch* _poisearch;
    BMKPoiResult*_result;
    BMKSearchErrorCode errorcode;
    int curPage;
    NSString *_cityStr;//街道名
    NSString *_cityName;//城市名
    
}

@property(nonatomic,strong)BMKMapView* mapView;//基础地图
@property(nonatomic,strong)BMKLocationService *locService;//定位服务
@property(nonatomic,strong)BMKUserLocation *userLocation;//用户当前位置
@property(nonatomic,weak)UIButton *locationBtn;
@property (weak, nonatomic) UITextField *searchTextField;//搜索框


@property(nonatomic,weak) UITextField* startCityText;
@property(nonatomic,weak) UITextField* startAddrText;
@property(nonatomic,weak) UITextField* endCityText;
@property(nonatomic,weak) UITextField* endAddrText;
@property(nonatomic,strong)BMKRouteSearch* routesearch;
@property(nonatomic,strong)BMKPoiSearch* poisearch;//搜索要用到的
@property(nonatomic,strong)UIView *waySearchView;//交通工具框


@end
@implementation MapViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化BMKLocationService定位服务
    _locService = [[BMKLocationService alloc]init];
    [self getUserLocation];//开始定位
    
    
    //创建地图对象
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHight-80)];
    [mapView setShowsUserLocation:YES];//显示定位的蓝点儿
    self.mapView = mapView;
    [self.view addSubview:mapView];
   
    //设置初始显示区域
    //    BMKCoordinateRegion region;
    //    NSLog(@"%@",self.userLocation);
    //    region.center=self.userLocation.location.coordinate;//当前位置的经纬度
    //    region.span={0.8,0.8};//设置显示范围
    //    [self.mapView setRegion:region];
    
    //self.userLocation=self.locService.userLocation;
    //NSLog(@"%@",self.userLocation.location.coordinate);
//    [mapView setMapCenterToScreenPt:CGPointMake(kScreenWidth*0.5, kScreenHight*0.5)];//设置地图中点在屏幕上显示的位置
    
    
    
    //_mapView.mapType = BMKMapTypeNone;//设置地图为空白类型
    //切换为卫星图
    //[_mapView setMapType:BMKMapTypeSatellite];
    
    
    _poisearch = [[BMKPoiSearch alloc]init];//search类，搜索的时候会用到
    

    //[self positionSearch];
    
    
    
    //创建定位按钮
    [self createLocationBtn];
    
    //设置导航栏
    [self setNavigationBar];
    
    //创建交通工具view
    [self createWaySearchView];
    //创建搜索框
    //[self createSearchBtn];
    _routesearch = [[BMKRouteSearch alloc]init];
    _startCityText.text = @"沈阳";
    _startAddrText.text = @"东北大学";
    _endCityText.text = @"沈阳";
    _endAddrText.text = @"辽宁电视台";
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //[_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    [self stopLocation];
    _mapView.delegate = nil; // 不用时，置nil
     _routesearch.delegate = nil; //不用时，置nil
     _poisearch.delegate = nil; // 不用时，置nil
}

//创建定位按钮
-(void)createLocationBtn{
    UIButton *locationBtn=[[UIButton alloc]init];
    locationBtn.frame=CGRectMake(20, kScreenHight-150, 30, 30);
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"icon_navigationItem_map"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    self.locationBtn=locationBtn;
    [self.view addSubview:locationBtn];
}
-(void)getUserLocation
{
    NSLog(@"进入普通定位态");
    
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView setShowsUserLocation:YES];//显示定位的蓝点儿
    [_mapView setCenterCoordinate:self.userLocation.location.coordinate animated:YES];
    
}

-(void)startLocation
{
    NSLog(@"进入跟随定位态");

    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态，跟随状态
    _mapView.showsUserLocation = YES;//显示定位图层
}
-(void)stopLocation
{
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
}


//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
    self.userLocation=userLocation;
    
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.userLocation=userLocation;
    if ( _mapView.userTrackingMode==BMKUserTrackingModeNone) {
        [self stopLocation];
        [_mapView setCenterCoordinate:self.userLocation.location.coordinate animated:YES];

    }
        CLGeocoder *Geocoder=[[CLGeocoder alloc]init];//地理编码
    
    CLGeocodeCompletionHandler handler = ^(NSArray *place, NSError *error) {
        
        for (CLPlacemark *placemark in place) {
            
            _cityStr=placemark.thoroughfare;
            
            _cityName=placemark.locality;
            
            //NSLog(@"city %@",cityStr);//获取街道地址
            
            //NSLog(@"cityName %@",cityName);//获取城市名
            
            break;
            
        }
        
    };
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
    [Geocoder reverseGeocodeLocation:loc completionHandler:handler];

    [_mapView updateLocationData:userLocation];
}
#pragma mark-POI检索

-(void)positionSearch
{
    [_searchTextField resignFirstResponder];
    curPage = 0;
    BMKNearbySearchOption *citySearchOption = [[BMKNearbySearchOption alloc]init];
    citySearchOption.pageIndex = curPage;
    citySearchOption.pageCapacity = 10;
    citySearchOption.location = self.userLocation.location.coordinate;
    //citySearchOption.city= @"沈阳";//_cityText.text;
    citySearchOption.keyword =self.searchTextField.text;// _keyText.text;
    BOOL flag = [_poisearch poiSearchNearBy:citySearchOption];
    if(flag)
    {
        NSLog(@"地点检索发送成功");
        
    }
    else
    {
        NSLog(@"地点检索发送失败");
    }
    
    
}


-(void)onClickNextPage
{
    curPage++;
    //城市内检索，请求发送成功返回YES，请求发送失败返回NO
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = curPage;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= _cityText.text;
    citySearchOption.keyword = _keyText.text;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
        _nextPageButton.enabled = true;
        
    }
    else
    {
        _nextPageButton.enabled = false;
        NSLog(@"城市内检索发送失败");
    }
    
    
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"ddddd");
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {//正确
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            NSLog(@"%@",item.title);
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

#pragma mark-navigationBar设置

-(void)setNavigationBar{
    UITextField *searchField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 35)];
    searchField.backgroundColor=[UIColor whiteColor];
    searchField.layer.cornerRadius=10;
    searchField.font=[UIFont systemFontOfSize:12];
    UIView *leftVw=[[UIView alloc]init];
    leftVw.frame=CGRectMake(0, 0, 8, 1);
    searchField.leftView=leftVw;
    searchField.leftViewMode=UITextFieldViewModeAlways;//设置左边的View什么时候显示（一直都显示，只在编辑时显示等）
    searchField.tintColor=[UIColor blackColor];
    searchField.placeholder=@"搜地点、搜路线";
    searchField.returnKeyType=UIReturnKeySearch;//键盘的return显示“搜索”
    searchField.delegate=self;//用于键盘点击的响应事件
    self.navigationItem.titleView=searchField;
    
    self.searchTextField=searchField;
    
    //导航栏右侧按钮
    UIBarButtonItem* poiSearchBtn = [[UIBarButtonItem alloc]init];
    poiSearchBtn.target = self;
    poiSearchBtn.action = @selector(positionSearch);
    poiSearchBtn.title = @"搜索";
    poiSearchBtn.enabled=TRUE;
//    UIBarButtonItem* busBtn = [[UIBarButtonItem alloc]init];
//    busBtn.target = self;
//    busBtn.action = @selector(wayPointDemo);
//    busBtn.title = @"查公交";
//    busBtn.enabled=TRUE;
    UIBarButtonItem* gotoBtn = [[UIBarButtonItem alloc]init];
    gotoBtn.target = self;
    gotoBtn.action = @selector(createWaySearchView);//加载交通工具页面
    gotoBtn.title = @"到这去";
    gotoBtn.enabled=TRUE;
    self.navigationItem.rightBarButtonItems = @[gotoBtn,poiSearchBtn];
    
    //添加导航栏返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_dealsmap_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=backItem;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{//必须遵循textfield的代理协议，并设置当前控制器为其代理
    //NSLog(@"ffff");
    [self positionSearch];//搜地点
    [textField resignFirstResponder]; //不作为第一响应者
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponder];
}

- (void)dealloc {
    if (_routesearch != nil) {
        _routesearch = nil;
    }
    if (_poisearch != nil) {
        _poisearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}
#pragma mark-路线规划相关 加载交通工具选择界面
-(void)createWaySearchView{
    CGFloat margin=10;
    CGFloat w=kScreenWidth-2*margin;
    CGFloat btnW=(w-4*margin)/3.0;
    CGFloat btnH=30;
    UIView *waySearchView=[[UIView alloc]initWithFrame:CGRectMake(margin, 0, kScreenWidth-2*10, btnH)];
    waySearchView.backgroundColor=[UIColor blackColor];
    waySearchView.alpha=0.8;
    waySearchView.layer.cornerRadius=5;
    UIButton *walk=[[UIButton alloc]initWithFrame:CGRectMake(margin,0,btnW, btnH)];
    //walk.layer.cornerRadius=5;
    //[walk setBackgroundColor:[UIColor blackColor]];
    
    [walk setTitle:@"步行" forState:UIControlStateNormal];
    [walk addTarget:self action:@selector(onClickWalkSearch) forControlEvents:UIControlEventTouchUpInside];
    [waySearchView addSubview:walk];
    UIButton *bus=[[UIButton alloc]initWithFrame:CGRectMake(2*margin+btnW,0,btnW, btnH)];
    [bus setTitle:@"公交" forState:UIControlStateNormal];
    [bus addTarget:self action:@selector(onClickBusSearch) forControlEvents:UIControlEventTouchUpInside];
    [waySearchView addSubview:bus];
    UIButton *drive=[[UIButton alloc]initWithFrame:CGRectMake(3*margin+2*btnW,0,btnW, btnH)];
    [drive setTitle:@"驾车" forState:UIControlStateNormal];
    [drive addTarget:self action:@selector(onClickDriveSearch) forControlEvents:UIControlEventTouchUpInside];
    [waySearchView addSubview:drive];
    [self.view addSubview:waySearchView];
    self.waySearchView=waySearchView;
}
-(void)loadWayView{
    CGFloat margin=10;
    CGFloat w=kScreenWidth-2*margin;
    CGFloat btnH=30;
    [_searchTextField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    //0.1设置动画的时间
    [UIView setAnimationDuration:1.0];
    [self.waySearchView setFrame:CGRectMake(margin, 64, kScreenWidth-2*10, btnH)];
    //4.提交动画
    [UIView commitAnimations];

}
#pragma mark-路线规划相关
- (void)wayPointDemo {
    
    WayPointRouteSearchDemoViewController * wayPointCont = [[WayPointRouteSearchDemoViewController alloc]init];
    wayPointCont.title = @"驾车途经点";
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    [self.navigationController pushViewController:wayPointCont animated:YES];
}

#pragma mark - BMKMapViewDelegate

//- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
//        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
//    }
//    return nil;
//}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - BMKRouteSearchDelegate

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetRidingRouteResult error:%d", (int)error);
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKRidingRouteLine* plan = (BMKRidingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:i];
            if (i == 0) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
            } else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.degree = (int)transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKRidingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

#pragma mark - 检索公交

-(void)onClickBusSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //start.name = _startAddrText.text;
    start.pt=self.userLocation.location.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = _searchTextField.text;
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= _cityName;
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

-(void)onClickDriveSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //start.name = _startAddrText.text;
    start.cityName = _cityName;
    start.pt=self.userLocation.location.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = _searchTextField.text;
    end.cityName =_cityName;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}

-(IBAction)onClickWalkSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //start.name = _startAddrText.text;
    start.pt=self.userLocation.location.coordinate;
    start.cityName = _cityName;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = _endAddrText.text;
    end.cityName = _cityName;
    
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
    
}

- (IBAction)onClickRidingSearch:(id)sender {
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = _startAddrText.text;
    start.cityName = @"北京市";
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = _endAddrText.text;
    end.cityName = @"北京市";
    
    BMKRidingRoutePlanOption *option = [[BMKRidingRoutePlanOption alloc]init];
    option.from = start;
    option.to = end;
    BOOL flag = [_routesearch ridingSearch:option];
    if (flag)
    {
        NSLog(@"骑行规划检索发送成功");
    }
    else
    {
        NSLog(@"骑行规划检索发送失败");
    }
}

#pragma mark - 私有

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}



//-(void)createSearchBtn{
//    UIButton *textBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, 74, kScreenWidth-2*30, 40)];
//    [textBtn setTitle:@"搜地点、查公交、找路线" forState:UIControlStateNormal];
//    [textBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    textBtn.titleLabel.font=[UIFont systemFontOfSize:12];
//    textBtn.titleEdgeInsets=UIEdgeInsetsMake(0,10, 0, 0);
//    textBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
//    UIImage *image=[UIImage imageNamed:@"bg_search_field"];
//    //用平铺的方式拉伸图片，四个角的不变，以中间的点平铺，中间整个区域，实现扩大图片，并保持形状不变
//    image=[image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
//    [textBtn setBackgroundImage:image forState:UIControlStateNormal];
//    [textBtn addTarget:self action:@selector(jump2SearchView) forControlEvents:UIControlEventTouchUpInside];
//    //[textBtn setShowsTouchWhenHighlighted:NO];
//    textBtn.adjustsImageWhenHighlighted=NO;
//    [self.view addSubview:textBtn];
//}
//
//-(void)jump2SearchView{
//    SearchTableViewController *vc=[[SearchTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    return YES;
//}
@end
