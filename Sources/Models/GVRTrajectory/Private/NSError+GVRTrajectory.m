//
//  NSError+GVRTrajectory.m
//  Checkers
//
//  Created by Ievgen on 1/8/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "NSError+GVRTrajectory.h"

#import "GVRTrajectory.h"

@implementation NSError (GVRTrajectory)

#pragma mark -
#pragma mark Class Methods

+ (instancetype)trajectoryErrorWithCode:(NSInteger)code {
    return [NSError errorWithDomain:GVRTrajectoryErrorDomain
                               code:code
                           userInfo:nil];
}

@end
