//
//  GVRManTrajectory.m
//  Checkers
//
//  Created by Ievgen on 1/3/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRManTrajectory.h"

#import "GVRBoard.h"
#import "GVRBoardPosition.h"

#import "NSError+GVRTrajectory.h"

@interface GVRManTrajectory ()

@end

@implementation GVRManTrajectory

#pragma mark -
#pragma mark Public Methods

- (BOOL)isAllowedDistanceToVictim:(NSInteger)distance {
    return labs(distance) == 1 ? YES : NO;
}

- (BOOL)isAllowedSingleJumpDistance:(NSInteger)distance {
    return distance > 0 && distance <= 1 ? YES : NO;
}

@end
