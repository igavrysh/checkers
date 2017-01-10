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
#import "NSError+GVRTrajectory.h"
#import "NSArray+GVRTrajectory.h"

#import "GVRBlockMacros.h"

NSString *const GVRTrajectoryErrorDomain = @"com.gavrysh.checkers.trajectoryerror";

@interface GVRTrajectory ()
@property (nonatomic, strong)   NSArray     *steps;

- (instancetype)initWithSteps:(NSArray *)steps;

- (BOOL)checkBasicRules:(GVRBoard *)board stepIndex:(NSUInteger)stepIndex player:(GVRPlayer)player error:(NSError **)error;

- (BOOL)applyForBoard:(GVRBoard *)board stepIndex:(NSUInteger)stepIndex player:(GVRPlayer)player error:(NSError **)error;

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

- (BOOL)isAllowedDistanceToVictim:(NSInteger)distance {
    return NO;
}

- (BOOL)isAllowedSingleJumpDistance:(NSInteger)distance {
    return NO;
}

- (BOOL)applyForBoard:(GVRBoard *)board player:(GVRPlayer)player error:(NSError **)error {    
    BOOL result = [self applyForBoard:board stepIndex:1 player:player error:error];
    
    [board resetMarkedForRemovalCheckers];
    
    return result;
}

- (BOOL)checkBasicRules:(GVRBoard *)board
              stepIndex:(NSUInteger)stepIndex
                 player:(GVRPlayer)player
                  error:(NSError **)error
{
    NSArray *steps = self.steps;
    
    GVRBoardCell initialCell = [steps cellAtIndex:0];
    GVRBoardCell cell = [steps cellAtIndex:stepIndex];
    GVRBoardCell previousCell = [steps cellAtIndex:stepIndex - 1];
    
    GVRBoardPosition *initialPosition = [board positionForCell:initialCell];
    initialPosition.checker.markedForRemoval = YES;
    GVRBoardPosition *position = [board positionForCell:cell];
    
    if (GVRBoardPositionColorWhite == position.color) {
        *error = [NSError trajectoryErrorWithCode:GVRTrajectoryStepOnWhiteCell];
        
        return NO;
    }
    
    if (position.isFilled
        && position != initialPosition)         // Cycle movements
    {
        *error = [NSError trajectoryErrorWithCode:GVRTrajectoryStepOnFilledCell];
        
        return NO;
    }
    
    if (!initialPosition.isFilled) {
        *error = [NSError trajectoryErrorWithCode:GVRTrajectoryNoActiveCheckerInStepsSequence];
        
        return NO;
    }
    
    if ((player == GVRPlayerWhiteCheckers && GVRCheckerColorBlack == initialPosition.checker.color)
        || (player == GVRPlayerBlackCheckers && GVRCheckerColorWhite == initialPosition.checker.color))
    {
        *error = [NSError trajectoryErrorWithCode:GVRTrajectoryPlayerMovesOpponentsChecker];
        return NO;
    }
    
    NSUInteger size = board.size;
    if (cell.row >= size || cell.column >= size) {
        *error = [NSError trajectoryErrorWithCode:GVRTrajectoryStepOutOfBoard];
        
        return NO;
    }
    
    NSInteger deltaRow = cell.row - previousCell.row;
    NSInteger deltaColumn = cell.column - previousCell.column;
    if (labs(deltaRow) != labs(deltaColumn)) {
        *error = [NSError trajectoryErrorWithCode:GVRTrajectoryNonDiagonalMove];
        return NO;
    }
    
    return YES;
}

- (BOOL)isReqMoveAvailalbleOnBoard:(GVRBoard *)board
                          fromCell:(GVRBoardCell)fromCell
                         direction:(GVRBoardDirection)direction
                            player:(GVRPlayer)player
{
    BOOL (^isVictimPresent)(GVRBoard *, GVRBoardCell, GVRBoardDirection, GVRPlayer)
    = ^BOOL(GVRBoard *board, GVRBoardCell cell, GVRBoardDirection direction, GVRPlayer player)
    {
        GVRBoardPosition *victimPosition = [self victimPositionOnBoard:board
                                                              fromCell:cell
                                                             direction:direction
                                                             forPlayer:player
                                                                 error:nil];
        
        return (victimPosition) && [self isAllowedDistanceToVictim:labs((NSInteger)victimPosition.row - (NSInteger)cell.row)];
    };
    
    GVRBoardDirection direction1 = direction.rowDirection != direction.columnDirection
        ? GVRBoardDirectionMake(+1, +1) : GVRBoardDirectionMake(+1, -1);
    GVRBoardDirection direction2 = direction.rowDirection != direction.columnDirection
        ? GVRBoardDirectionMake(-1, -1) : GVRBoardDirectionMake(-1, +1);
    
    __block BOOL isTrajectoryAvailable = NO;
    if (isVictimPresent(board, fromCell, direction, player)) {
        isTrajectoryAvailable = YES;
        
        return isTrajectoryAvailable;
    }
    
    [board iterateDiagonallyFromCell:fromCell
                       withDirection:direction
                               block:^(GVRBoardPosition *position, BOOL *stop)
     {
         GVRBoardCell candidateCell = [position cell];
         if (isVictimPresent(board, candidateCell, direction1, player)
             || isVictimPresent(board, candidateCell, direction2, player))
         {
             *stop = YES;
             isTrajectoryAvailable = YES;
         }
     }];
    
    return isTrajectoryAvailable;
}

- (BOOL)isReqFirstMoveAvailalbleOnBoard:(GVRBoard *)board
                               fromCell:(GVRBoardCell)cell
                                 player:(GVRPlayer)player
{
    return [self isReqMoveAvailalbleOnBoard:board fromCell:cell direction:GVRBoardDirectionMake(+1, +1) player:player]
    || [self isReqMoveAvailalbleOnBoard:board fromCell:cell direction:GVRBoardDirectionMake(+1, -1) player:player]
    || [self isReqMoveAvailalbleOnBoard:board fromCell:cell direction:GVRBoardDirectionMake(-1, +1) player:player]
    || [self isReqMoveAvailalbleOnBoard:board fromCell:cell direction:GVRBoardDirectionMake(-1, -1) player:player];
}

- (GVRBoardPosition *)victimPositionOnBoard:(GVRBoard *)board
                                   fromCell:(GVRBoardCell)fromCell
                                  direction:(GVRBoardDirection)direction
                                  forPlayer:(GVRPlayer)player
                                      error:(NSError **)error
{
    return [self victimPositionOnBoard:board
                              fromCell:fromCell
                                toCell:GVREdgeCellMake(board.size, fromCell, direction)
                             forPlayer:player
                                 error:error];
}

- (GVRBoardPosition *)victimPositionOnBoard:(GVRBoard *)board
                                   fromCell:(GVRBoardCell)fromCell
                                     toCell:(GVRBoardCell)toCell
                                  forPlayer:(GVRPlayer)player
                                      error:(NSError **)error
{
    __block GVRBoardPosition *victimPosition = nil;
    
    GVRBoardCell startingCell = GVRBoardCellShift(fromCell, GVRBoardDirectionUsingCells(fromCell, toCell), 1);
    
    [board iterateDiagonallyFromCell:startingCell toCell:toCell withBlock:^(GVRBoardPosition *position, BOOL *stop) {
        if (![self isAllowedDistanceToVictim:position.row - fromCell.row]
            || ![self isAllowedDistanceToVictim:toCell.row - position.row])
        {
            *stop = YES;
            
            return;
        }
        
        if (position.isFilled && !position.checker.isMarkedForRemoval) {
            *stop = YES;
            
            GVRCheckerColor color = position.checker.color;
            if ((GVRCheckerColorBlack == color && GVRPlayerBlackCheckers == player)
                || (GVRCheckerColorWhite == color && GVRPlayerWhiteCheckers == player))
            {
                if (error) {
                    *error = [NSError trajectoryErrorWithCode:GVRTrajectoryJumpOverFriendlyChecker];
                }
                
                return;
            }
            
            GVRBoardPosition *nextPosition = [position positionShiftedByDirection:GVRBoardDirectionUsingCells(fromCell, toCell)
                                                                         distance:1];
            if (nextPosition.isFilled && !nextPosition.checker.isMarkedForRemoval) {
                if (error) {
                    *error = [NSError trajectoryErrorWithCode:GVRTrajectoryLongJump];
                }
                
                return;
            }
            
            if ((GVRCheckerColorWhite == color && GVRPlayerBlackCheckers == player)
                || (GVRCheckerColorBlack == color && GVRPlayerWhiteCheckers == player))
            {
                victimPosition = position;
            }
        }
    }];
    
    return victimPosition;
}

- (BOOL)applyForBoard:(GVRBoard *)board stepIndex:(NSUInteger)stepIndex player:(GVRPlayer)player error:(NSError **)error {
    if (![self checkBasicRules:board stepIndex:stepIndex player:player error:error]) {
        return NO;
    }
    
    if (self.steps.count <= 1) {
        return NO;
    }
    
    NSArray *steps = self.steps;
    
    GVRBoardCell initialCell = [steps cellAtIndex:0];
    GVRBoardCell cell = [steps cellAtIndex:stepIndex];
    GVRBoardCell previousCell = [steps cellAtIndex:stepIndex - 1];
    
    if (!GVRIsDiagonalDistance(cell, previousCell)) {
        *error = [NSError trajectoryErrorWithCode:GVRTrajectoryNonDiagonalMove];
        
        return NO;
    }
    
    GVRBoardPosition *victimPosition = [self victimPositionOnBoard:board
                                                          fromCell:previousCell
                                                            toCell:cell
                                                         forPlayer:player
                                                             error:error];
    if (*error) {
        return NO;
    }
    
    if (self.steps.count > 2 && !victimPosition) {
        *error = [NSError trajectoryErrorWithCode:GVRTrajectoryMoreThanOneOneCellMove];
        
        return NO;
    }
    
    if (victimPosition) {
        victimPosition.checker.markedForRemoval = YES;
    }
    
    BOOL result;
    
    if (victimPosition) {
        if (stepIndex < self.steps.count - 1) {
            result = [self applyForBoard:board stepIndex:stepIndex + 1 player:player error:error];
        } else {
            if (victimPosition) {
                GVRBoardCell victimCell = [victimPosition cell];
                GVRBoardDirection dir = GVRBoardDirectionUsingCells(victimCell, cell);
                result = ![self isReqMoveAvailalbleOnBoard:board
                                                  fromCell:cell
                                                 direction:dir
                                                    player:player];
            }
            
            if (result) {
                [board moveCheckerFromCell:initialCell toCell:cell];
            } else {
                *error = [NSError trajectoryErrorWithCode:GVRTrajectoryMissRequiredJump];
                
                return NO;
            }
        }
        
        if (result && victimPosition) {
            [board removeCheckerAtRow:victimPosition.row column:victimPosition.column];
        }
    } else {
        NSInteger distance = (player == GVRPlayerWhiteCheckers ? +1 : -1) * (cell.row - previousCell.row);
        if (![self isAllowedSingleJumpDistance:distance]) {
            *error = [NSError trajectoryErrorWithCode:GVRTrajectoryLongJump];
            
            return NO;
        }
        
        if (![self isReqFirstMoveAvailalbleOnBoard:board fromCell:previousCell player:player]) {
            [board moveCheckerFromCell:initialCell toCell:cell];
            
            result = YES;
        } else {
            *error = [NSError trajectoryErrorWithCode:GVRTrajectoryMissRequiredJump];
            
            return NO;
        }
    }
    
    return result;
}

@end
