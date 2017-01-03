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

- (instancetype)__initWithSteps:(NSArray *)steps board:(GVRBoard *)board;

@end

@implementation GVRTrajectory

#pragma mark -
#pragma mark Class Methods

+ (instancetype)trajectoryWithSteps:(NSArray *)steps board:(GVRBoard *)board {
    return [[self alloc] initWithSteps:steps board:board];
}

+ (instancetype)manTrajectoryWithSteps:(NSArray *)steps board:(GVRBoard *)board {
    return [[GVRManTrajectory alloc] __initWithSteps:steps board:board];
}

+ (instancetype)kingTrajectoryWithSteps:(NSArray *)steps board:(GVRBoard *)board {
    return [[GVRKingTrajectory alloc] __initWithSteps:steps board:board];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithSteps:(NSArray *)steps board:(GVRBoard *)board {
    self = nil;
    
    if (self.steps.count == 0) {
        return nil;
    }
    
    GVRBoardCell cell;
    [self.steps[0] getValue:&cell];
    GVRBoardPosition *position = [board positionForRow:cell.row column:cell.column];
    if (GVRCheckerTypeMan == position.checker.type) {
        self = [[self class] manTrajectoryWithSteps:steps board:board];
    } else if (GVRCheckerTypeKing == position.checker.type) {
        self = [[self class] kingTrajectoryWithSteps:steps board:board];
    }
    
    return self;
}

- (instancetype)__initWithSteps:(NSArray *)steps board:(GVRBoard *)board {
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
