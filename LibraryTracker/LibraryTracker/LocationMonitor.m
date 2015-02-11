//
//  LocationMonitor.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/3/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LocationMonitor.h"
#import <UIKit/UIKit.h>
#import "ApplicationState.h"

@interface LocationMonitor()

@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation LocationMonitor 

#pragma mark - Singleton init methods

+ (id)sharedLocation {
    static LocationMonitor *shared =nil;
    
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        shared = [[LocationMonitor alloc] init];
    });
    return shared;

}

- (id)init {
    
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [self.locationManager requestAlwaysAuthorization];

        
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

// method to check whether there is permissions for location monitoring
// this is important!
- (BOOL)checkLocationManagerPermissions {
    if(![CLLocationManager locationServicesEnabled]) {
        NSLog(@"You need to enable Location Services");
        return  FALSE;
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  ) {
        NSLog(@"You need to authorize Location Services for the APP");
        return  FALSE;
    }
    return TRUE;
}

#pragma mark - Region Monitoring methods

// call this method when setting a new university or whatever
- (void)addRegions:(NSArray *)regions {
    // clear out the current regions that it's monitoring
    //[self clearRegionsMonitoring];
    
    // add each of the regions
    for (CLRegion *region in regions) {
        // start tracking the region
        //NSLog(@"Adding Region: %@", region.identifier);
        
        [self.locationManager startMonitoringForRegion:region];
    }
    
    //NSLog(@"Regions tracking: %@", [self.locationManager monitoredRegions]);
    
    // check if already in a region
    [self checkIfAlreadyInRegion];
}

- (void)clearRegionsMonitoring {
    NSLog(@"Clearing the current regions monitoring");
    for(CLRegion *region in [[self.locationManager monitoredRegions] allObjects]) {
        [self.locationManager stopMonitoringForRegion:region];
    }
}

- (CLLocation *)getCurrentLocation {
    if ([self checkLocationManagerPermissions]) {
        [self.locationManager startUpdatingLocation];
    }
    
    [self.locationManager stopUpdatingLocation];
    return self.currentLocation;
}

- (void)checkIfAlreadyInRegion {
    [self getCurrentLocation];
    for (CLRegion *region in [self.locationManager monitoredRegions]) {
        
        // TYPE CASTING DON'T HATE ME
        if ([(CLCircularRegion *)region containsCoordinate:self.currentLocation.coordinate]) {
            NSLog(@"Already in the Region: %@", region.identifier);
            [self locationManager:self.locationManager didEnterRegion:region];
        }
    }
}


#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region {
    //use this if the user is already in a region
    NSLog(@"Region State - %@", region.identifier);
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    NSLog(@"Started monitoring %@ region", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    [self createLocalNotificationWithAlertBody:[NSString stringWithFormat:@"Entered Region: %@", region.identifier]];
    
    NSLog(@"Entered Region - %@", region.identifier);
    
    // when user enters region - need to change user state to Roaming
    [[ApplicationState sharedInstance] userEnteredRegion:(CLCircularRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    [self createLocalNotificationWithAlertBody:[NSString stringWithFormat:@"Exited Region: %@", region.identifier]];
    
    NSLog(@"Exited Region - %@", region.identifier);
}

- (void)createLocalNotificationWithAlertBody:(NSString *)alert {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = alert;
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
    notification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [locations objectAtIndex:0];
    //NSLog(@"Regions tracking: %@", [self.locationManager monitoredRegions]);
}

@end
