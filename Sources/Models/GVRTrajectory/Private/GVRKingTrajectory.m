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

#import "NSError+GVRExtensions.h"

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
    
    if (GVRCheckerTypeMan == initialPosition.checker.type) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryTypeInconsistencyManAndKing];
        
        return NO;
    }
    
    NSInteger deltaRow = cell.row - previousCell.row;
    NSInteger deltaColumn = cell.column - previousCell.column;
    GVRBoardPosition *victimPosition = [previousPosition positionShiftedByDeltaRows:deltaRow / labs(deltaRow)
                                                                       deltaColumns:deltaColumn / labs(deltaColumn)];
    
    GVRBoardPosition *victimPosition2 = [previousPosition positionShiftedByDeltaRows:2 * deltaRow / labs(deltaRow)
                                                                        deltaColumns:2 * deltaColumn / labs(deltaColumn)];
    
    if (victimPosition && victimPosition2 && victimPosition.isFilled && victimPosition2.isFilled) {
        *error = [NSError errorWithDomain:GVRTrajectoryErrorDomain
                                     code:GVRTrajectoryLongJump];
        return NO;
    }
    
    if (victimPosition && victimPosition.isFilled) {
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
                [board moveCheckerFrom:initialPosition to:position];
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

@end
