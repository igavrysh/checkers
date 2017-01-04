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

- (instancetype)initWithSteps:(NSArray *)steps;

@end

@implementation GVRTrajectory

#pragma mark -
#pragma mark Class Methods

+ (instancetype)trajectoryWithSteps:(NSArray *)steps board:(GVRBoard *)board {
    return [[self alloc] initWithSteps:steps board:board];
}

+ (instancetype)manTrajectoryWithSteps:(NSArray *)steps {
    return [[GVRManTrajectory alloc] initWithSteps:steps];
}

+ (instancetype)kingTrajectoryWithSteps:(NSArray *)steps {
    return [[GVRKingTrajectory alloc] initWithSteps:steps];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithSteps:(NSArray *)steps board:(GVRBoard *)board {
    self = nil;
    
    if (steps.count == 0) {
        return nil;
    }
    
    GVRBoardCell cell;
    [self.steps[0] getValue:&cell];
    GVRBoardPosition *position = [board positionForRow:cell.row column:cell.column];
    if (GVRCheckerTypeMan == position.checker.type) {
        self = [GVRTrajectory manTrajectoryWithSteps:steps];
    } else if (GVRCheckerTypeKing == position.checker.type) {
        self = [GVRTrajectory kingTrajectoryWithSteps:steps];
    }
    
    return self;
}

- (instancetype)initWithSteps:(NSArray *)steps {
    if (self) {
        self.steps = steps;
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (BOOL)applyForBoard:(GVRBoard *)board player:(GVRPlayer)player error:(NSError **)error {
    return NO;
}

@end
