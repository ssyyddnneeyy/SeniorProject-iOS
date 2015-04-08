//
//  RegionViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 4/4/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionViewController.h"

@implementation RegionViewController

- (UIColor *)convertRegionPopulationToColorWithCurrentPop:(int)currentPopulation andMaxCapacity:(int)maxCapacity {
    // YAY HSV COLOR SPACE IS GOING TO MAKE THIS EASY FOR ME WEEEEEEEEEEEEE
    // hue of 0.0 == RED
    // hue of .33 = GREEN
    // so the color needs to be between that
    // divide the color
    if (maxCapacity == 0) {
        // if the max capacity is 0, then we would be diving by a zero number. which is no bueno
        // if that's the case, then return black
        return [UIColor blackColor];
    }
    
    //so this is mapped from [0.0, 1.0], need to constrain this to [0.0, 0.33]
    // subtract 1.0 from what the value is to invert it, then constrain it to [0.0, 0.33] by dividing by 3.0
    float color = (1.0f - ((float)currentPopulation/maxCapacity)) / 3.0f;
    return [UIColor colorWithHue:color saturation:0.75f brightness:0.9f alpha:0.7f];
}

@end