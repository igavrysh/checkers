//
//  GVRKingTrajectory.m
//  Checkers
//
//  Created by Ievgen on 1/3/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRKingTrajectory.h"

#import "GVRBoard.h"
#import "GVRBoardPosition.h"

#import "NSError+GVRTrajectory.h"
#import "NSArray+GVRTrajectory.h"

#import "GVRBlockMacros.h"

@interface GVRKingTrajectory ()


@end

@implementation GVRKingTrajectory

#pragma mark -
#pragma mark Public Methods

- (BOOL)isAllowedDistanceToVictim:(NSInteger)distance {
    return YES;
}

- (BOOL)isAllowedSingleJumpDistance:(NSInteger)distance {
    return YES;
}

@end
