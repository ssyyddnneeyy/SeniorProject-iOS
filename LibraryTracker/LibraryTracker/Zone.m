//
//  Zone.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Zone.h"

#define kIdentifier     @"identifier"
#define kBssids         @"bssids"
#define kIdNumber       @"idNumber"

@implementation Zone

- (id)initWithIdentifier:(NSString *)identifier wifiBssidValues:(NSArray *)bssids idNumber:(int)idNum currentPopulation:(int)currentPop capacity:(int)maxCapacity{
    if (self = [super init]) {
        self.idNumber = idNum;
        self.identifier = identifier;
        self.bssidWifiData = bssids;
        self.currentPopulation = currentPop;
        self.maxCapacity = maxCapacity;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithIdentifier:[aDecoder decodeObjectForKey:kIdentifier]
                    wifiBssidValues:[aDecoder decodeObjectForKey:kBssids]
                           idNumber:(int)[aDecoder decodeIntegerForKey:kIdNumber]
                  currentPopulation:0
                           capacity:0];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:kIdentifier];
    [aCoder encodeObject:self.bssidWifiData forKey:kBssids];
    [aCoder encodeInteger:self.idNumber forKey:kIdNumber];
}

- (BOOL)bssidIsInZone:(NSString *)currentBSSID {
    for (NSString *bssid in self.bssidWifiData) {
        if ([bssid isEqualToString:currentBSSID]) {
            // found it
            return YES;
        }
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Zone %@, idNum: %i", self.identifier, self.idNumber];
}

@end
