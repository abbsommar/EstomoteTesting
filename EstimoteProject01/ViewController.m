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
@property (nonatomic, strong) CLBeaconRegion *beaconRegionYes;
@property (nonatomic, strong) CLBeaconRegion *beaconRegionNo;


@end



@implementation ViewController

@synthesize statusLbl, signalStrengthLbl, beaconLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
     self.beaconLabel.text = @"";
     //Create your UUID
     NSUUID *uuidYes = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
     NSUUID *uuidNo = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
     //set up the beacon manager
     self.beaconManager = [[ESTBeaconManager alloc] init];
     self.beaconManager.delegate = self;
     
     //set up the beacon region
     self.beaconRegionYes = [[CLBeaconRegion alloc] initWithProximityUUID:uuidYes
                                                                  major:16365
                                                                  minor:45820
                                                             identifier:@"regionYes"];
    
    self.beaconRegionNo = [[CLBeaconRegion alloc] initWithProximityUUID:uuidNo
                                                                   major:26500
                                                                   minor:21156
                                                              identifier:@"regionNo"];
     
     //let us know when we exit and enter a region
     self.beaconRegionYes.notifyOnEntry = YES;
     self.beaconRegionYes.notifyOnExit = YES;
     self.beaconRegionNo.notifyOnEntry = YES;
     self.beaconRegionNo.notifyOnExit = YES;

    
     //start  monitorinf
     [self.beaconManager startMonitoringForRegion:self.beaconRegionYes];
     [self.beaconManager startMonitoringForRegion:self.beaconRegionNo];
    

     
     //start the ranging
     [self.beaconManager startRangingBeaconsInRegion:self.beaconRegionYes];
     [self.beaconManager startRangingBeaconsInRegion:self.beaconRegionNo];
     
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
        self.statusLbl.text = [NSString stringWithFormat:@"Status: %@", [self textForProximity:firstBeacon.proximity]];
        self.signalStrengthLbl.text = [NSString stringWithFormat:@"Signal Strength: %@", [self textForsignalStrength:beacons.firstObject]];
        
        if([region.identifier isEqualToString:@"regionYes"] &&  [[self textForProximity:firstBeacon.proximity] isEqualToString:@"Immediate"] && firstBeacon.accuracy < 1.0f)
        {
            NSLog(@"Yes!");
            beaconLbl.text = [NSString stringWithFormat:@"Yes!"];
            beaconLbl.textColor = [UIColor greenColor];
        }
        else if([region.identifier isEqualToString:@"regionNo"] && [[self textForProximity:firstBeacon.proximity] isEqualToString:@"Immediate"] && firstBeacon.accuracy < 1.0f)
        {
            NSLog(@"No!");
            beaconLbl.text = [NSString stringWithFormat:@"No!"];
            beaconLbl.textColor = [UIColor redColor];
        }

    }
    else
    {
        self.statusLbl.text = [NSString stringWithFormat:@"Hittar inte alla beacons."];
        self.signalStrengthLbl.text = [NSString stringWithFormat:@"Hittar inte alla beacons."];
    }
    
}

-(NSString *)textForProximity:(CLProximity)proximity
{
    
    switch (proximity) {
        case CLProximityFar:
            self.signalStrengthLbl.textColor = [UIColor blueColor];
            return @"Far";
            break;
        case CLProximityNear:
            self.signalStrengthLbl.textColor = [UIColor purpleColor];
            return @"Near";
            break;
        case CLProximityImmediate:
            self.signalStrengthLbl.textColor = [UIColor redColor];
            return @"Immediate";
            break;
        case CLProximityUnknown:
            return @"Unknown";
            break;
        default:
            break;
    }
}

-(NSString *) textForsignalStrength:(CLBeacon*)beacon
{
    if(beacon.accuracy < 1.5f)
    {
        return @"Good!";
    }
    else if(beacon.accuracy > 1.5f && beacon.accuracy < 2.5f)
    {
        return @"Medium!";
    }
    else if (beacon.accuracy > 3.5f)
        return @"Bad!";
    else
        return @"None";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
