//
//  UIWindow+GVRExtensions.m
//  SuperUI
//
//  Created by Ievgen on 8/15/16.
//  Copyright © 2016 1mlndollarsasset. All rights reserved.
//

#import "UIWindow+GVRExtensions.h"

@implementation UIWindow (GVRExtensions)

#pragma mark -
#pragma mark Class Methods

+ (UIWindow *)window {
    return [[UIWindow alloc] initWindow];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (UIWindow *)initWindow {
    return [self initWithFrame:[[UIScreen mainScreen] bounds]];
}

@end
