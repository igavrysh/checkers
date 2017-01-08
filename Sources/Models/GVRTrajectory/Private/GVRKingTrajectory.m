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
#import "NSArray+GVRExtensions.h"

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

- (BOOL)isAllowedDistanceToVictim:(NSInteger)distance {
    return YES;
}

- (BOOL)isAllowedSingleJumpDistance:(NSInteger)distance {
    return YES;
}

- (BOOL)isRequiredTrajectoriesAvailalbleOnBoard:(GVRBoard *)board
                               lastMoveFromCell:(GVRBoardCell)previousCell
                                         toCell:(GVRBoardCell)cell
                                    isFirstMove:(BOOL)isFirstMove
{
    BOOL (^isTrajectoryAvailable)(GVRBoardDirection)
    = ^BOOL(GVRBoardDirection direction) {
        __block BOOL isTrajectoryAvailable = NO;
        
        [board iterateDiagonallyFromCell:cell
                           withDirection:direction
                                   block:^(GVRBoardPosition *position, BOOL *stop)
        {
            if ([self isAllowedDistanceToVictim:labs((NSInteger)position.row - (NSInteger)cell.row)]) {
                GVRBoardPosition *nextPosition = [position positionShiftedByDirection:direction distance:1];
                
                if (nextPosition && !nextPosition.isFilled) {
                    isTrajectoryAvailable = YES;
                }
                
                *stop = YES;
            } else {
                *stop = YES;
            }
        }];
        
        return isTrajectoryAvailable;
    };
    
    return  isTrajectoryAvailable(GVRBoardDirectionMake(+1, +1))
        ||  isTrajectoryAvailable(GVRBoardDirectionMake(+1, -1))
        ||  isTrajectoryAvailable(GVRBoardDirectionMake(-1, +1))
        ||  isTrajectoryAvailable(GVRBoardDirectionMake(-1, -1));
    
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
    
    GVRBoardCell initialCell;
    GVRBoardCell cell;
    GVRBoardCell previousCell;
    [self.steps getValue:&initialCell atIndex:0];
    [self.steps getValue:&cell atIndex:stepIndex];
    [self.steps getValue:&previousCell atIndex:stepIndex - 1];
    
    if (!GVRIsDiagonalDistance(initialCell, cell)
        || !GVRIsDiagonalDistance(initialCell, cell)
        || !GVRIsDiagonalDistance(cell, previousCell))
    {
        *error = [NSError trajectoryErrorWithCode:GVRTrajectoryNonDiagonalMove];
        return NO;
    }
    
    __block GVRBoardPosition *victimPosition = nil;
    [board iterateDiagonallyFromCell:previousCell
                              toCell:cell
                           withBlock:^(GVRBoardPosition *position, BOOL *stop)
     {
         if (position.isFilled) {
             if ((GVRBoardPositionColorBlack == position.checker.color && GVRPlayerBlackCheckers == player)
                 || (GVRBoardPositionColorWhite == position.checker.color && GVRPlayerWhiteCheckers == player))
             {
                 *stop = YES;
                 
                 *error = [NSError trajectoryErrorWithCode:GVRTrajectoryJumpOverFriendlyChecker];
             }
             
             if ((GVRBoardPositionColorWhite == position.checker.color && GVRPlayerBlackCheckers == player)
                 || (GVRBoardPositionColorBlack == position.checker.color && GVRPlayerWhiteCheckers == player)) {
                 if (victimPosition) {
                     *stop = YES;
                     
                     *error = [NSError trajectoryErrorWithCode:GVRTrajectoryLongJump];
                 } else {
                     victimPosition = position;
                 }
             }
         }
     }];
    
    if (error) {
        return NO;
    }
    
    if (self.steps.count > 2 && !victimPosition) {
        *error = [NSError trajectoryErrorWithCode:GVRTrajectoryMoreThanOneOneCellMove];
        return NO;
    }
    
    if (victimPosition) {
        if ([self isAllowedDistanceToVictim:(NSInteger)victimPosition.row - (NSInteger)previousCell.row]
            && [self isAllowedDistanceToVictim:(NSInteger)cell.row - (NSInteger)victimPosition.row])
        {
            victimPosition.checker.markedForRemoval = YES;
            
            BOOL result = NO;
            
            if (stepIndex < self.steps.count - 1) {
                result = [self __applyForBoard:board stepIndex:stepIndex + 1 player:player error:error];
            } else {
                result = ![self isRequiredTrajectoriesAvailalbleOnBoard:board
                                                       lastMoveFromCell:previousCell
                                                                 toCell:cell
                                                            isFirstMove:NO];
                if (result) {
                    [board moveCheckerFromCell:initialCell toCell:cell];
                } else {
                    *error = [NSError trajectoryErrorWithCode:GVRTrajectoryMissRequiredJump];
                    
                    return NO;
                }
            }
            
            if (result) {
                [board removeCheckerAtRow:victimPosition.row column:victimPosition.column];
            }
            
            return result;
        } else {
            *error = [NSError trajectoryErrorWithCode:GVRTrajectoryLongJump];
            return NO;
        }
    } else {
        NSInteger distance = (player == GVRPlayerWhiteCheckers ? +1 : -1) * (cell.row - previousCell.row);
        if ([self isAllowedSingleJumpDistance:distance]) {
            BOOL result = result = ![self isRequiredTrajectoriesAvailalbleOnBoard:board
                                                                 lastMoveFromCell:previousCell
                                                                           toCell:cell
                                                                      isFirstMove:YES];
            if (result) {
                [board moveCheckerFromCell:initialCell toCell:cell];
            
                return YES;
            } else {
                *error = [NSError trajectoryErrorWithCode:GVRTrajectoryMissRequiredJump];
                
                return NO;
            }
        } else {
            *error = [NSError trajectoryErrorWithCode:GVRTrajectoryLongJump];
            
            return NO;
        }
    }
    
    return NO;
}

@end
