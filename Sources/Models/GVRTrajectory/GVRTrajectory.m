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

#import "NSError+GVRExtensions.h"

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
    [steps[0] getValue:&cell];
    GVRBoardPosition *position = [board positionForRow:cell.row column:cell.column];
    GVRCheckerType type = position.checker.type;
    if (GVRCheckerTypeMan == type) {
        self = [GVRTrajectory manTrajectoryWithSteps:steps];
    } else if (GVRCheckerTypeKing == type) {
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

- (BOOL)__applyForBoard:(GVRBoard *)board
              stepIndex:(NSUInteger)stepIndex
                 player:(GVRPlayer)player
                  error:(NSError **)error
{
    GVRBoardCell initialCell;
    GVRBoardCell cell;
    GVRBoardCell previousCell;
    
    [self.steps[0] getValue:&initialCell];
    [self.steps[stepIndex] getValue:&cell];
    [self.steps[stepIndex - 1] getValue:&previousCell];
    
    GVRBoardPosition *initialPosition = [board positionForCell:initialCell];
    initialPosition.checker.markedForRemoval = YES;
    GVRBoardPosition *position = [board positionForCell:cell];
    
    if (GVRBoardPositionColorWhite == position.color) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryStepOnWhiteCell];
        
        return NO;
    }
    
    if (position.isFilled
        && position != initialPosition)         // Cycle movements
    {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryStepOnFilledCell];
        
        return NO;
    }
    
    if (!initialPosition.isFilled) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryNoActiveCheckerInStepsSequence];
        
        return NO;
    }
    
    if ((player == GVRPlayerWhiteCheckers && GVRCheckerColorBlack == initialPosition.checker.color)
        || (player == GVRPlayerBlackCheckers && GVRCheckerColorWhite == initialPosition.checker.color))
    {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryPlayerMovesOpponentsChecker];
        return NO;
    }
    
    NSUInteger size = board.size;
    if (cell.row >= size || cell.column >= size) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryStepOutOfBoard];
        return NO;
    }
    
    NSInteger deltaRow = cell.row - previousCell.row;
    NSInteger deltaColumn = cell.column - previousCell.column;
    if (labs(deltaRow) != labs(deltaColumn)) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryNonDiagonalMove];
        return NO;
    }
    
    return YES;
}

- (BOOL)isAllowedDistanceToVictim:(NSInteger)distance {
    return NO;
}

- (BOOL)isAllowedSingleJumpDistance:(NSInteger)distance {
    return NO;
}

@end
