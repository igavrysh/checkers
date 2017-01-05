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
                                    fromPostion:(GVRBoardPosition *)position
                                 exceptPosition:(GVRBoardPosition *)exceptPosition;

- (BOOL)applyForBoard:(GVRBoard *)board
            stepIndex:(NSUInteger)stepIndex
               player:(GVRPlayer)player
                error:(NSError **)error;

@end

@implementation GVRManTrajectory

#pragma mark -
#pragma mark Public Methods

- (BOOL)applyForBoard:(GVRBoard *)board player:(GVRPlayer)player error:(NSError **)error {
    return [self applyForBoard:board
                     stepIndex:1
                        player:player
                        error:error];
}

#pragma mark -
#pragma mark Private Methods

- (BOOL)applyForBoard:(GVRBoard *)board
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
    
    GVRBoardPosition *initialPosition = [board positionForRow:initialCell.row
                                                       column:initialCell.column];
    GVRBoardPosition *position = [board positionForRow:cell.row column:cell.column];
    
    if (GVRBoardPositionColorWhite == position.color) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryStepOnWhiteCell];
        
        return NO;
    }
    
    if (position.isFilled) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryStepOnFilledCell];
        
        return NO;
    }
    
    if (!initialPosition.isFilled) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryNoActiveCheckerInStepsSequence];
        
        return NO;
    }
    
    if (GVRCheckerTypeKing == initialPosition.checker.type) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryTypeInconsistencyManAndKing];
        
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
    
    if (labs(deltaRow) > 2 || labs(deltaColumn) > 2) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryLongJump];
        
        return NO;
    }
    
    if (1 == stepIndex) {
        
        if ((GVRPlayerWhiteCheckers == player && deltaRow < 0)
            || (GVRPlayerBlackCheckers == player && deltaRow > 0))
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
                                                  fromPostion:initialPosition
                                               exceptPosition:nil])
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
        NSUInteger victimRow = previousCell.row + deltaRow / 2;
        NSUInteger victimColumn = previousCell.column + deltaColumn / 2;
        
        GVRBoardPosition *victimPosition = [board positionForRow:victimRow column:victimColumn];
        if (!victimPosition.isFilled) {
            *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                         code:GVRTrajectoryLongJump];
            return NO;
        }
        
        if ((GVRBoardPositionColorWhite == victimPosition.color && GVRPlayerWhiteCheckers == player)
            || (GVRBoardPositionColorBlack == victimPosition.color && GVRPlayerBlackCheckers == player))
        {
            *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                         code:GVRTrajectoryJumpOverFriendlyChecker];
            return NO;
        }
        
        if ((GVRBoardPositionColorBlack == victimPosition.color && GVRPlayerWhiteCheckers == player)
            || (GVRBoardPositionColorWhite == victimPosition.color && GVRPlayerBlackCheckers == player))
        {
            BOOL result = NO;
            
            if (stepIndex == self.steps.count - 1) {
                result = ![self isRequiredTrajectoriesAvailalbleOnBoard:board
                                                            fromPostion:position
                                                         exceptPosition:nil];
            } else {
                result = [self applyForBoard:board
                                   stepIndex:stepIndex + 1
                                      player:player
                                       error:error];
            }
            
            if (result) {
                [board removeCheckerAtRow:victimRow column:victimColumn];
            }
            
            return result;
        }
    }
    
    return NO;
}

- (BOOL)isRequiredTrajectoriesAvailalbleOnBoard:(GVRBoard *)board
                                    fromPostion:(GVRBoardPosition *)position
                                 exceptPosition:(GVRBoardPosition *)exceptPosition
{
    BOOL (^isTrajectoryAvailable)(NSInteger, NSInteger)
    = ^BOOL(NSInteger deltaRow, NSInteger deltaColumn) {
        GVRBoardPosition *victimPosition = [board positionForRow:deltaRow column:deltaColumn];
        GVRBoardPosition *nextPosition = [board positionForRow:2 * deltaRow column:2 * deltaColumn];
        
        if (victimPosition
            && victimPosition.isFilled
            && victimPosition.checker.color != position.checker.color
            && !nextPosition.isFilled
            && position != exceptPosition) {
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
