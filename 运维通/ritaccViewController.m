//
//  ritaccViewController.m
//  运维通
//
//  Created by nan on 15-7-12.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "ritaccViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import"hjnANNINOTION.h"

@interface ritaccViewController ()<UIAlertViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
  NSTimer *_timeer;
}
@property (nonatomic, strong) NSArray *tgs;
@property(nonatomic,assign)int num;
@end

#define RUNTIME 24*60*60

@implementation ritaccViewController
@synthesize _locationManager;
@synthesize _saveLocations;
@synthesize coordinate,title,subtitle;
@synthesize _updateTimer2;
@synthesize _mapview;


-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    if(!_timeer)
    {
        _timeer=[NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(updateloaction) userInfo:nil repeats:YES];
        [_timeer fire];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat R  = (CGFloat) 0/255.0;
    CGFloat G = (CGFloat) 146/255.0;
    CGFloat B = (CGFloat) 234/255.0;
    CGFloat alpha = (CGFloat) 1.0;
    
    UIColor *myColorRGB = [ UIColor colorWithRed: R
                                           green: G
                                            blue: B
                                           alpha: alpha
                           ];
    
    
    
    self.navigationController.navigationBar.barTintColor=myColorRGB;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    
    
    self._mapview.userTrackingMode=MKUserTrackingModeFollowWithHeading;
    self._mapview.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        
        _locationManager= [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        _locationManager.distanceFilter = 100;
        
        [_locationManager startUpdatingLocation];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            
            //     [_locationManager requestWhenInUseAuthorization];
            
            _locationManager.pausesLocationUpdatesAutomatically = NO;
    }

    
    self._updateTimer2 = [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(copynet) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self._updateTimer2 forMode:NSRunLoopCommonModes];
    
    NSString *kong=@"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:kong forKey:@"CusShort"];
    [userDefaults setObject:kong forKey:@"ContactMan"];
    [userDefaults setObject:kong forKey:@"ContactMobile"];
    [userDefaults setObject:kong forKey:@"ContactAddress"];
    [userDefaults setObject:kong forKey:@"detaaddr"];
    [userDefaults synchronize];
    
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    userLocation.title=@"当前位置";
    //userLocation.subtitle=@"";
    
    CLLocationCoordinate2D center=userLocation.location.coordinate;
    //  [self postJSON:lati:longti];
    
    
}






-(NSArray *)netwok:(NSArray *)tgsa
{
    
    _tgs=tgsa;
    return _tgs;
    
    
}

-(void)ann{
    @try
    {
    [self removeCustomAnnotation];
    [self._mapview removeAnnotations:self._mapview.annotations];
    if (_tgs.count>0) {
        int index=_tgs.count;
        for (int i=0; i<index; i++) {
            NSLog(@"%d,%@",i,[_tgs objectAtIndex:i]);
            hjnANNINOTION *annon=[[hjnANNINOTION alloc]init];
            float x=[[_tgs objectAtIndex:i][@"latitude"] floatValue]-0.00300;
            CLLocationDegrees latitude=x;
            float y=[[_tgs objectAtIndex:i][@"longitude"] floatValue]+0.00500;
            CLLocationDegrees longtitude=y;
            annon.coordinate= CLLocationCoordinate2DMake(latitude, longtitude);
            NSString *zt=[NSString stringWithFormat:@"运维单号：%@",[_tgs objectAtIndex:i][@"OrderNo"]];
            NSString *name=[NSString stringWithFormat:@"%@  %@",[_tgs objectAtIndex:i][@"RealName"],[_tgs objectAtIndex:i][@"Mobile"]];
            annon.title=name;
            annon.subtitle=zt;
            annon.icon=@"people.png";
            [self._mapview addAnnotation:annon];
        }
        
        
    }
    }@catch (NSException * e) {
        
        NSLog(@"Exception: %@", e);
        
        
        
    }
}


-(void)removeCustomAnnotation{
    [self._mapview.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[hjnANNINOTION class]]) {
            [self._mapview removeAnnotation:obj];
        }
    }];
}


-(float)lati:(float)la{
    lati=la;
    return lati;
}
-(float)longtia:(float)la{
    longtia=la;
    return longtia;
}


-(void)copynet{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/HL.ashx?action=getsubxy&q0=%@",urlt,myString];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"%@",urlStr);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"type=focus-c";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (data != nil) {
            
            
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSArray *dictarr2=[[dict objectForKey:@"ResultObject"] copy];
            [self netwok:dictarr2];
            [self ann];
        }else{
            
            
                
                
                return ;
                
            
        }
        }];

    }];
    
    
    
    
    
}



//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    userLocation.title=@"当前位置";
//    //userLocation.subtitle=@"";
//
//    CLLocationCoordinate2D center=userLocation.location.coordinate;
//  //  [self postJSON:lati:longti];
//
//
//}

-(void)initData{
    //    backgroundUpdateInterval = RUNTIME;
    //    self._saveLocations = [[NSMutableArray alloc] init];
    //    self._locationManager = [[CLLocationManager alloc] init];
    //    self._locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //    self._locationManager.delegate = self;
    
    //
    
    
}

-(void)updateloaction
{
    [self._locationManager startUpdatingLocation];
    //    [self._locationManager stopUpdatingLocation];
    
}



- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MKCoordinateSpan mySpan = [mapView region].span;
    storedLatitudeDelta = mySpan.latitudeDelta;
    storedLongitudeDelta = mySpan.longitudeDelta;
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = newLocation.coordinate;
    //[self._mapview addAnnotation:annotation];//
    [self._saveLocations addObject:annotation];
    NSString *lati=[NSString stringWithFormat:@"%f",self._locationManager.location.coordinate.latitude-0.00420];
    NSString *longti=[NSString stringWithFormat:@"%f",self._locationManager.location.coordinate.longitude+0.00560];
    
    
    [self postJSON:lati:longti];
    //    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive)
    //    {
    //        if (backgroundTask != UIBackgroundTaskInvalid)
    //        {
    //            [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
    //            backgroundTask = UIBackgroundTaskInvalid;
    //        }
    //
    //
    //        for (MKPointAnnotation *annotation in self._saveLocations)
    //        {
    //            CLLocationCoordinate2D coordinate = annotation.coordinate;
    //
    //            MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(coordinate,storedLatitudeDelta ,storedLongitudeDelta);
    //      //      MKCoordinateRegion adjustedRegion = [self._mapview regionThatFits:region];
    //         //   [self._mapview setRegion:adjustedRegion animated:NO];
    //        }
    //
    //
    //    }
    //    else
    //    {
    //        NSString *lati=[NSString stringWithFormat:@"%f",self._locationManager.location.coordinate.latitude-0.00420];
    //        NSString *longti=[NSString stringWithFormat:@"%f",self._locationManager.location.coordinate.longitude+0.00560];
    //
    //
    //           [self postJSON:lati:longti];
    //            NSLog(@"成功！");
    //
    //
    //
    //
    //    }
    
    
    
}

//-(void)applicationDidEnterBackground:(NSNotificationCenter *)notication{
//    UIApplication* app = [UIApplication sharedApplication];
//
//    backgroundTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        NSLog(@"applicationD in Background");
//    }];
//
//    self._updateTimer = [NSTimer scheduledTimerWithTimeInterval:backgroundUpdateInterval
//                                                         target:self
//                                                       selector:@selector(stopUpdate)
//                                                       userInfo:nil
//                                                        repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self._updateTimer forMode:NSRunLoopCommonModes];
//}


-(void)stopUpdate{
    [self._locationManager stopUpdatingLocation];
    
    [_timeer invalidate];
    _timeer = nil;
    if (backgroundTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }
}





- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if(interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        return YES;
    }else {
        return NO;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        return;
        
    }else if(buttonIndex == 1){
        
        exit(0);
        
    }}

- (void)postJSON:(NSString *)text1 :(NSString *)text2
{
    @try
    {
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
        
        if (myString==NULL) {
            // NSLog(@"%@",myString);
            return;
        }else{
            
            NSString *strurl=[NSString stringWithFormat:@"%@/API/HL.ashx",urlt];
            NSURL *url = [NSURL URLWithString:strurl];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
            request.HTTPMethod = @"POST";
            
            NSString *str = [NSString stringWithFormat:@"action=sl&q0=%@&q1=%@&q2=%@",myString,text2,text1];
            NSLog(@"-++++++++-%@",str);
            request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                if (!data== nil) {
                    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"%@",result);
                }else{
                    return ;
                }
                
            }];
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[hjnANNINOTION class]]) return nil;
    
    static NSString *ID = @"tuangou";
    
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        
        annoView.canShowCallout = YES;
        
        annoView.calloutOffset = CGPointMake(0, -10);
        
        // annoView.rightCalloutAccessoryView =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        
        annoView.leftCalloutAccessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"index_tx"]];
    }
    
    annoView.annotation = annotation;
    
    hjnANNINOTION *tuangouAnno = annotation;
    annoView.image = [UIImage imageNamed:tuangouAnno.icon];
    
    return annoView;
}







@end
