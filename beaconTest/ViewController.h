//
//  ViewController.h
//  beaconTest
//
//  Created by Pavlos Dimitriou on 9/25/14.
//  Copyright (c) 2014 Pavlos Dimitriou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeacon.h"


typedef enum : int
{
    ESTScanTypeBluetooth,
    ESTScanTypeBeacon
    
} ESTScanType;

/*
 * Selected beacon is returned on given completion handler.
 */


@interface ViewController : UIViewController
//- (id)initWithBeacon:(ESTBeacon *)beacon;

- (id)initWithScanType:(ESTScanType)scanType completion:(void (^)(ESTBeacon *))completion;

@end

