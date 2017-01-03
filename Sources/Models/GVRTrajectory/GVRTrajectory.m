//
//  GVRTrajectory.m
//  Checkers
//
//  Created by Ievgen on 1/3/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRTrajectory.h"

#import "GVRBoard.h"

#import "GVRManTrajectory.h"
#import "GVRKingTrajectory.h"
#import "GVRBoardPosition.h"

NSString *const GVRTrajectoryErrorDomain = @"com.gavrysh.checkers.trajectoryerror";

@interface GVRTrajectory ()
@property (nonatomic, strong)   NSArray     *steps;
@property (nonatomic, weak)     GVRBoard    *board;

@end

@implementation GVRTrajectory

#pragma mark -
#pragma mark Class Methods

+ (instancetype)manTrajectoryWithSteps:(NSArray *)steps board:(GVRBoard *)board {
    return [[GVRManTrajectory alloc] initWithSteps:steps board:board];
}

+ (instancetype)kingTrajectoryWithSteps:(NSArray *)steps board:(GVRBoard *)board {
    return [[GVRKingTrajectory alloc] initWithSteps:steps board:board];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithSteps:(NSArray *)steps board:(GVRBoard *)board {
    if (self) {
        self.steps = steps;
        self.board = board;
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (BOOL)applyForPlayer:(GVRPlayer)player error:(NSError **)error {
    return NO;
}

@end
