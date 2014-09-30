//
//  ViewController.m
//  beaconTest
//
//  Created by Pavlos Dimitriou on 9/25/14.
//  Copyright (c) 2014 Pavlos Dimitriou. All rights reserved.
//

#import "ViewController.h"
#import "ESTBeaconManager.h"

@interface ViewController () <ESTBeaconManagerDelegate>
@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;
//@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, assign)   ESTScanType scanType;
@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) UILabel           *zoneLabel;
@property (nonatomic, copy)     void (^completion)(ESTBeacon *);
//@property (nonatomic, assign)   ESTScanType scanType;

@property (nonatomic, strong) NSArray *beaconsArray;


@end

@implementation ViewController

//- (id)initWithBeacon:(ESTBeacon *)beacon
//{
//    self = [super init];
//    if (self)
//    {
//        
//
//        self.beacon = beacon;
//    }
//    return self;
//}

- (void)viewDidLoad {

[super viewDidLoad];

    /*
     * BeaconManager setup.
     */
  

    /*
     * Creates sample region object (you can additionaly pass major / minor values).
     *
     * We specify it using only the ESTIMOTE_PROXIMITY_UUID because we want to discover all
     * hardware beacons with Estimote's proximty UUID.
     */
//    self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
//                                                      identifier:@"EstimoteSampleRegion"];
    
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                                 major:63849
                                                                 minor:57777
                                                            identifier:@"RegionIdentifier"];
    
    /*
     * Request permission to use Location Services. (new in iOS 8)
     * We ask for "always" authorization so that the Notification Demo can benefit as well.
     * Also requires NSLocationAlwaysUsageDescription in Info.plist file.
     *
     * For more details about the new Location Services authorization model refer to:
     * https://community.estimote.com/hc/en-us/articles/203393036-Estimote-SDK-and-iOS-8-Location-Services
     */
    self.beaconManager = [[ESTBeaconManager alloc] init];
    [self.beaconManager requestAlwaysAuthorization];

    self.beaconManager.delegate = self;
    
   
     [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    /*
     * Starts looking for Estimote beacons.
     * All callbacks will be delivered to beaconManager delegate.
     */
//    if (self.scanType == ESTScanTypeBeacon)
//    {
//        [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
//    }
//    else
//    {
//        [self.beaconManager startEstimoteBeaconsDiscoveryForRegion:self.beaconRegion];
//    }
    
    [self.beaconManager startEstimoteBeaconsDiscoveryForRegion:self.beaconRegion];


/*
 * UI setup.
 */
self.view.backgroundColor = [UIColor whiteColor];

self.zoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                           100,
                                                           self.view.frame.size.width,
                                                           40)];
self.zoneLabel.textAlignment = NSTextAlignmentCenter;
[self.view addSubview:self.zoneLabel];

self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                               64,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height - 64)];
self.imageView.contentMode = UIViewContentModeCenter;
[self.view addSubview:self.imageView];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
    
    [super viewDidDisappear:animated];
}

- (id)initWithScanType:(ESTScanType)scanType completion:(void (^)(ESTBeacon *))completion
{
    self = [super init];
    if (self)
    {
        self.scanType = scanType;
        self.completion = [completion copy];
    }
    return self;
}


- (void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = beacons;
//    NSLog(@"%@",self.beaconsArray);
    
    for (id tempObject in self.beaconsArray) {
        ESTBeacon *tempBeacon = tempObject ;
//        NSLog(@"%@",tempBeacon.macAddress);
        if ([tempBeacon.macAddress isEqualToString:@"fd5ee1b1f969"]) {
            self.beacon = tempBeacon;
//            NSLog(@"Found here");

 

            //[self.beaconManager startEstimoteBeaconsDiscoveryForRegion:self.beaconRegion];

        }
    }
    
}

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)beaconRegion {
    NSLog(@"Entered");
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)beaconRegion {
    NSLog(@"Exited");

}

-(void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"error: %@", error);
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)beaconRegion
    {
//        NSLog(@"Here");
        self.beaconsArray = beacons;

        for (id tempObject in self.beaconsArray) {
            ESTBeacon *tempBeacon = tempObject ;

        if (beacons.count > 0)
        {

//                self.zoneLabel.text     = [self textForProximity:tempBeacon.proximity];

            [self textForProximity:tempBeacon.proximity];
        } else if(beacons.count == 0) {
            NSLog(@"Exited");
            NSLog(@"FAR");
            NSURL *url = [NSURL URLWithString:@"http://192.168.77.138:8080/"];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLResponse *response = NULL;
            NSError *requestError = NULL;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

        }
            
        }
    }
    
#pragma mark -
    
    - (void)textForProximity:(CLProximity)proximity
    {
        

        switch (proximity) {
                
            case CLProximityFar:
            {
                NSLog(@"FAR");
                NSURL *url = [NSURL URLWithString:@"http://192.168.77.138:8080/"];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = NULL;
                NSError *requestError = NULL;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
                NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                
                NSURL *url2 = [NSURL URLWithString:@"http://192.168.77.95/api/newdeveloper/lights/3/state"];
                NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
                [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                
                [request2 setHTTPBody:[@"{\"on\":false}" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [request2 setHTTPMethod:@"PUT"];
                
                
                NSError *requestError2 = NULL;
                NSURLResponse *response2 = NULL;
                NSData *responseData2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&requestError2];
                
                NSString *responseString2 = [[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding];
                NSLog(@"%@",responseString2);
                
                
                
                return ;
                break; }
            case CLProximityNear:
            { NSLog(@"NEAR");
                NSURL *url = [NSURL URLWithString:@"http://192.168.77.95/api/newdeveloper/lights/3/state"];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                
                [request setHTTPBody:[@"{\"on\":true,\"sat\":0,\"bri\":255}" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [request setHTTPMethod:@"PUT"];
                
                
                NSError *requestError = NULL;
                NSURLResponse *response = NULL;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
                
                NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                NSLog(@"%@",responseString);
                return ;}
                break;
            case CLProximityImmediate:{
                NSLog(@"IMMEDIATE");
                NSURL *url = [NSURL URLWithString:@"http://192.168.77.95/api/newdeveloper/lights/3/state"];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                
                [request setHTTPBody:[@"{\"on\":true,\"sat\":255,\"bri\":50}" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [request setHTTPMethod:@"PUT"];
                
                
                NSError *requestError = NULL;
                NSURLResponse *response = NULL;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
                
                NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                NSLog(@"%@",responseString);

                return ;
                break;
            }
            default:
                return ;
                break;
        }
    }
    


@end
