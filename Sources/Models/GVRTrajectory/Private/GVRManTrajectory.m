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

#import "NSError+GVRExtensions.h"

@interface GVRManTrajectory ()

- (BOOL)isRequiredTrajectoriesAvailalbleOnBoard:(GVRBoard *)board
                                    fromPostion:(GVRBoardPosition *)position;

- (BOOL)__applyForBoard:(GVRBoard *)board
            stepIndex:(NSUInteger)stepIndex
               player:(GVRPlayer)player
                error:(NSError **)error;

@end

@implementation GVRManTrajectory

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

- (BOOL)__applyForBoard:(GVRBoard *)board
              stepIndex:(NSUInteger)stepIndex
                 player:(GVRPlayer)player
                  error:(NSError **)error
{
    if (![super __applyForBoard:board stepIndex:stepIndex player:player error:error]) {
        return NO;
    }
    
    GVRBoardCell initialCell;
    GVRBoardCell cell;
    GVRBoardCell previousCell;
    
    [self.steps[0] getValue:&initialCell];
    [self.steps[stepIndex] getValue:&cell];
    [self.steps[stepIndex - 1] getValue:&previousCell];
    
    GVRBoardPosition *initialPosition = [board positionForCell:initialCell];
    GVRBoardPosition *previousPosition = [board positionForCell:previousCell];
    GVRBoardPosition *position = [board positionForCell:cell];
    
    if (GVRCheckerTypeKing == initialPosition.checker.type) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryTypeInconsistencyManAndKing];
        
        return NO;
    }
    
    NSInteger deltaRow = cell.row - previousCell.row;
    NSInteger deltaColumn = cell.column - previousCell.column;
    
    if (labs(deltaRow) > 2 || labs(deltaColumn) > 2) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryLongJump];
        
        return NO;
    }
    
    if (self.steps.count > 2 && 1 == labs(deltaColumn) && 1 == labs(deltaRow)) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryMoreThanOneOneCellMove];
        return NO;
    }
    
    if (1 == stepIndex) {
        
        if ((GVRPlayerWhiteCheckers == player && -1 == deltaRow)
            || (GVRPlayerBlackCheckers == player && 1 == deltaRow))
        {
            *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                         code:GVRTrajectoryBackwardsMove];
            
            return NO;
        }
         
        if (1 == labs(deltaColumn)
            && ((GVRPlayerWhiteCheckers == player && 1 == deltaRow)
                || (GVRPlayerBlackCheckers == player && -1 == deltaRow)))
        {
            if ([self isRequiredTrajectoriesAvailalbleOnBoard:board
                                                  fromPostion:initialPosition])
            {
                *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                             code:GVRTrajectoryMissRequiredJump];
                return NO;
            }
            
            [board moveCheckerFrom:initialPosition to:position];
            
            return YES;
        }
    }
    
    if (2 == labs(deltaRow) && 2 == labs(deltaColumn)) {
        GVRBoardPosition *victimPosition = [previousPosition positionShiftedByDeltaRows:deltaRow / 2
                                                                           deltaColumns:deltaColumn / 2];
        
        if (!victimPosition.isFilled) {
            *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                         code:GVRTrajectoryLongJump];
            return NO;
        }
        
        GVRCheckerColor victimColor = victimPosition.checker.color;
        
        if ((GVRCheckerColorWhite == victimColor  && GVRPlayerWhiteCheckers == player)
            || (GVRCheckerColorBlack == victimColor && GVRPlayerBlackCheckers == player))
        {
            *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                         code:GVRTrajectoryJumpOverFriendlyChecker];
            return NO;
        }
        
        if ((GVRCheckerColorBlack == victimColor && GVRPlayerWhiteCheckers == player)
            || (GVRCheckerColorWhite == victimColor && GVRPlayerBlackCheckers == player))
        {
            BOOL result = NO;
            
            victimPosition.checker.markedForRemoval = YES;
            
            if (stepIndex == self.steps.count - 1) {
                result = ![self isRequiredTrajectoriesAvailalbleOnBoard:board
                                                            fromPostion:position];
                if (result) {
                    [board moveCheckerFrom:initialPosition to:position];
                }
            } else {
                result = [self __applyForBoard:board
                                   stepIndex:stepIndex + 1
                                      player:player
                                       error:error];
            }
            
            if (result) {
                [board removeCheckerAtRow:victimPosition.row column:victimPosition.column];
            }
            
            return result;
        }
    }
    
    return NO;
}

- (BOOL)isRequiredTrajectoriesAvailalbleOnBoard:(GVRBoard *)board
                                    fromPostion:(GVRBoardPosition *)position
{
    BOOL (^isTrajectoryAvailable)(NSInteger, NSInteger)
    = ^BOOL(NSInteger deltaRow, NSInteger deltaColumn) {
        
        GVRBoardPosition *victimPosition = [position positionShiftedByDeltaRows:deltaRow
                                                                   deltaColumns:deltaColumn];
        
        GVRBoardPosition *nextPosition = [position positionShiftedByDeltaRows:2 * deltaRow
                                                                 deltaColumns:2 * deltaColumn];
        
        if (victimPosition
            && nextPosition
            && victimPosition.isFilled
            && victimPosition.checker.color != position.checker.color
            && !nextPosition.isFilled
            && !victimPosition.checker.isMarkedForRemoval)
        {
            return YES;
        }
        
        return NO;
    };
    
    return isTrajectoryAvailable(+1, +1)
        || isTrajectoryAvailable(+1, -1)
        || isTrajectoryAvailable(-1, +1)
        || isTrajectoryAvailable(-1, -1);
}

@end
