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

- (NSArray *)unifiedStepsForBoard:(GVRBoard *)board;

- (BOOL)__applyForBoard:(GVRBoard *)board
              stepIndex:(NSUInteger)stepIndex
                 player:(GVRPlayer)player
                  error:(NSError **)error;

@end

@implementation GVRKingTrajectory

#pragma mark -
#pragma mark Public Methods

- (BOOL)applyForBoard:(GVRBoard *)board player:(GVRPlayer)player error:(NSError **)error {
    BOOL result = [self __applyForBoard:board
                              stepIndex:1
                                 player:player
                                  error:error];
    
    [board resetMarkedForRemovalCheckers];
    
    return result;
}

- (BOOL)isAllowedDistanceToVictim:(NSInteger)distance {
    return YES;
}

- (BOOL)isAllowedSingleJumpDistance:(NSInteger)distance {
    return YES;
}

#pragma mark -
#pragma mark Private Methods

// This method should unify steps so that king should jump right behind each checker covered by trajectory
- (NSArray *)unifiedStepsForBoard:(GVRBoard *)board {
    __block NSMutableArray *unifiedSteps  = [NSMutableArray new];
    
    void (^unify)(NSArray *steps, NSUInteger index) = ^void(NSArray *steps, NSUInteger index) {
        if (index == 1) {
            [unifiedSteps addObject:steps[0]];
        }
        
        GVRBoardCell targetCell, previousCell;
        
        [self.steps[index] getValue:&targetCell];
        [self.steps[index - 1] getValue:&previousCell];
 
        NSInteger deltaRow = targetCell.row - previousCell.row;
        NSInteger deltaRowDirection = deltaRow / labs(deltaRow);
        NSInteger deltaColumn = targetCell.column - previousCell.column;
        NSInteger deltaColumnDirection = deltaColumn / labs(deltaColumn);
        
        for (NSUInteger i = 0; i < labs(deltaRow); i++) {
            GVRBoardCell cell = GVRBoardCellMake(previousCell.row + deltaRowDirection * i,
                                                 previousCell.column + deltaColumnDirection * i);
            
            GVRBoardPosition *position = [board positionForCell:cell];
            if (position.isFilled) {
                [unifiedSteps addObject:[NSValue valueWithBytes:&cell objCType:@encode(GVRBoardCell)]];
            }
        }
        
        [unifiedSteps addObject:[NSValue valueWithBytes:&targetCell objCType:@encode(GVRBoardCell)]];
    };
    
    
    for (NSUInteger i = 1; i < unifiedSteps.count; i++) {
        unify(self.steps, i);
    }
    
    return [unifiedSteps copy];;
}

- (BOOL)isReqMoveAvailalbleOnBoard:(GVRBoard *)board
                          fromCell:(GVRBoardCell)cell
                         direction:(GVRBoardDirection)direction
                            player:(GVRPlayer)player
{
    BOOL (^isVictimPresent)(GVRBoard *, GVRBoardCell, GVRBoardDirection, GVRPlayer)
        = ^BOOL(GVRBoard *board, GVRBoardCell cell, GVRBoardDirection direction, GVRPlayer player)
    {
        GVRBoardPosition *victimPosition
            = [self victimPositionOnBoard:board fromCell:cell direction:direction forPlayer:player error:nil];
        
        return (victimPosition) && [self isAllowedDistanceToVictim:labs((NSInteger)victimPosition.row - (NSInteger)cell.row)];
    };
    
    GVRBoardDirection direction1, direction2;
    if (direction.rowDirection != direction.columnDirection) {
        direction1 = GVRBoardDirectionMake(+1, +1);
        direction2 = GVRBoardDirectionMake(-1, -1);
    } else {
        direction1 = GVRBoardDirectionMake(+1, -1);
        direction2 = GVRBoardDirectionMake(-1, +1);
    }
    
    __block BOOL isTrajectoryAvailable = NO;
    if (isVictimPresent(board, cell, direction, player)) {
        isTrajectoryAvailable = YES;
        
        return isTrajectoryAvailable;
    }
    
    [board iterateDiagonallyFromCell:cell
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
                             forPlayer:player error:error];
}

// Assume that every jump contains only one opposite checker
- (GVRBoardPosition *)victimPositionOnBoard:(GVRBoard *)board
                                   fromCell:(GVRBoardCell)fromCell
                                     toCell:(GVRBoardCell)toCell
                                  forPlayer:(GVRPlayer)player
                                      error:(NSError **)error
{
    __block GVRBoardPosition *victimPosition = nil;
    
    [board iterateDiagonallyFromCell:fromCell toCell:toCell withBlock:^(GVRBoardPosition *position, BOOL *stop) {
         if (position.isFilled && !position.checker.isMarkedForRemoval) {
             *stop = YES;
             
             GVRCheckerColor color = position.checker.color;
             if ((GVRCheckerColorBlack == color  && GVRPlayerBlackCheckers == player)
                 || (GVRCheckerColorWhite == color && GVRPlayerWhiteCheckers == player))
             {
                 *error = [NSError trajectoryErrorWithCode:GVRTrajectoryJumpOverFriendlyChecker];
                 
                 return;
             }
             
             GVRBoardPosition *nextPosition = [position positionShiftedByDirection:GVRBoardDirectionUsingCells(fromCell, toCell)
                                                                          distance:1];
             if (!nextPosition.isFilled) {
                 *error = [NSError trajectoryErrorWithCode:GVRTrajectoryLongJump];
                 
                 return;
             }
             
             if (![self isAllowedDistanceToVictim:(NSInteger)position.row - (NSInteger)fromCell.row]
                 || ![self isAllowedDistanceToVictim:(NSInteger)toCell.row - (NSInteger)position.row]) {
                 *error = [NSError trajectoryErrorWithCode:GVRTrajectoryLongJump];
                 
                 return;
             }
             else if ((GVRCheckerColorWhite == color && GVRPlayerBlackCheckers == player)
                || (GVRCheckerColorBlack == color && GVRPlayerWhiteCheckers == player))
             {
                 victimPosition = position;
             }
         }
     }];
    
    return victimPosition;
}

- (BOOL)__applyForBoard:(GVRBoard *)board
              stepIndex:(NSUInteger)stepIndex
                 player:(GVRPlayer)player
                  error:(NSError **)error
{
    if (![super __applyForBoard:board stepIndex:stepIndex player:player error:error]) {
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
                                                          fromCell:previousCell toCell:cell
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
            result = [self __applyForBoard:board stepIndex:stepIndex + 1 player:player error:error];
        } else {
            
            if (victimPosition) {
                result = ![self isReqMoveAvailalbleOnBoard:board
                                               fromCell:previousCell
                                              direction:GVRBoardDirectionUsingCells(previousCell, cell)
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
