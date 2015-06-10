//
//  ViewController.m
//  EstimoteProject01
//
//  Created by UXI2 on 10/06/15.
//  Copyright (c) 2015 Goofy. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import </Users/mickeygoophy/Desktop/SommarJobbAddeMarcus/EstimoteProject01/EstimoteProject01/EstimoteSDK.framework/Headers/ESTBeaconManager.h>

@interface ViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) CLBeacon *beacon;
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.beaconLabel.text = @"";
     //Create your UUID
     NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
     
     //set up the beacon manager
     self.beaconManager = [[ESTBeaconManager alloc] init];
     self.beaconManager.delegate = self;
     
     //set up the beacon region
     self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                  major:16365
                                                                  minor:45820
                                                             identifier:@"RegionIdenifier"];
     
     //let us know when we exit and enter a region
     self.beaconRegion.notifyOnEntry = YES;
     self.beaconRegion.notifyOnExit = YES;
     
     //start  monitorinf
     [self.beaconManager startMonitoringForRegion:self.beaconRegion];
     
     //start the ranging
     [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
     
     //MUST have for IOS8
     [self.beaconManager requestAlwaysAuthorization];

}

//check for region failure
-(void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"Region Did Fail: Manager:%@ Region:%@ Error:%@",manager, region, error);
}

//checks permission status
-(void)beaconManager:(ESTBeaconManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Status:%d", status);
}

//Beacon manager did enter region
- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(CLBeaconRegion *)region
{
    //Adding a custom local notification to be presented
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = @"Youve done it!";
    notification.soundName = @"Default.mp3";
    NSLog(@"Youve entered");
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

//Beacon Manager did exit the region
- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(CLBeaconRegion *)region
{
    //adding a custon local notification
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = @"Youve exited!!!";
    NSLog(@"Youve exited");
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


-(void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        CLBeacon *firstBeacon = [beacons firstObject];
        self.beaconLabel.text = [self textForProximity:firstBeacon.proximity];
    }
}

-(NSString *)textForProximity:(CLProximity)proximity
{
    
    switch (proximity) {
        case CLProximityFar:
            NSLog(@"far");
            return @"Far";
            break;
        case CLProximityNear:
            NSLog(@"near");
            self.beaconLabel.textColor = [UIColor purpleColor];
            return @"Near";
            break;
        case CLProximityImmediate:
            NSLog(@"immediate");
            self.beaconLabel.textColor = [UIColor redColor];
            return @"Immediate";
            break;
        case CLProximityUnknown:
            NSLog(@"unknown " );
            return @"Unknown";
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
