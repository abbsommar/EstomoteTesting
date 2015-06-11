//
//  TestingClassViewController.m
//  EstimoteProject01
//
//  Created by UXI2 on 11/06/15.
//  Copyright (c) 2015 Goofy. All rights reserved.
//

#import "TestingClassViewController.h"

@interface TestingClassViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) CLBeacon *beacon;
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;



@end

@implementation TestingClassViewController



-(id)initWithBeacon:(CLBeacon *)beacon
{
    self = [super init];
    if(self)
    {
        self.beacon = beacon;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Proximity demo";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.zoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.zoneLabel];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 63, self.view.frame.size.width, self.view.frame.size.height-64)];'
    
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
