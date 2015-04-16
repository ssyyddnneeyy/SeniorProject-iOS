//
//  LocationState.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Region.h"
#import "Zone.h"
#import "LocationStateContext.h"

typedef NS_ENUM(NSInteger, UserState) {
    UserStateNotInRegion,
    UserStateRoaming,
    UserStateStudying
};

@interface LocationState : NSObject

@property UserState userState;
@property (strong, nonatomic) LocationStateContext *context;

- (id)initWithContext:(LocationStateContext *)context;

- (LocationState *)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid;
- (LocationState *)exitedRegion;
- (Region *)getRegion;
- (void)saveUserState;

@end
