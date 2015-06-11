//
//  TestingClassViewController.h
//  EstimoteProject01
//
//  Created by UXI2 on 11/06/15.
//  Copyright (c) 2015 Goofy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EstimoteSDK/EstimoteSDK.h>

@interface TestingClassViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;

- (id) initWithBeacon:(CLBeacon *)beacon;
@end
