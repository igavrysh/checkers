//
//  GVRBoard.m
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import "GVRBoard.h"

#import "GVRChecker.h"
#import "GVRTrajectory.h"

#import "NSArray+GVRExtensions.h"
#import "NSError+GVRTrajectory.h"

#import "GVRBlockMacros.h"

@interface GVRBoard ()
@property (nonatomic, strong)   NSMutableArray  *positions;
@property (nonatomic, assign)   NSUInteger      size;
@property (nonatomic, assign)   NSUInteger      whiteCheckersCount;
@property (nonatomic, assign)   NSUInteger      blackCheckersCount;

- (void)setChecker:(GVRChecker *)checker atRow:(NSUInteger)row column:(NSUInteger)column;

- (void)addCheckersWithinRowsNumber:(NSUInteger)checkerRows;

@end

@implementation GVRBoard

#pragma mark -
#pragma mark Class Methods 

+ (instancetype)board {
    return [self new];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    if (self = [self initWithSize:GVRBoardSize]) {
        [self addCheckersWithinRowsNumber:GVRInitialCheckersFilledRowsCount];
    }

    return self;
}

- (instancetype)initWithSize:(NSUInteger)size {
    if (!(self = [super init])) {
        return nil;
    }
    
    self.size = size;
    
    self.positions = [[NSMutableArray alloc] initWithCapacity:size*size];
    
    for (NSUInteger i = 0; i < size; i++) {
        for (NSUInteger j = 0; j < size; j++) {
            GVRBoardPosition *position = [[GVRBoardPosition alloc] initWithRow:i column:j board:self];
            NSUInteger index = [self indexForRow:i column:j];
            self.positions[index] = position;
        }
    }
    
    return self;
}

- (GVRBoardPosition *)positionForRow:(NSUInteger)row column:(NSUInteger)column {
    NSInteger size = self.size;
    if (row >= size || column >= size) {
        return  nil;
    }
    
    return self.positions[[self indexForRow:row column:column]];
}

- (GVRBoardPosition *)positionForCell:(GVRBoardCell)cell {
    return [self positionForRow:cell.row column:cell.column];
}

- (void)addCheckersWithinRowsNumber:(NSUInteger)checkerRows {
    if (!self.positions) {
        return;
    }
    
    GVRChecker *whiteChecker = [GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite];
    GVRChecker *blackChecker = [GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack];
    NSUInteger rows = checkerRows / 2;
    NSUInteger size = self.size;
    
    for (NSUInteger i = 0; i < size; i++) {
        for (NSUInteger j = 0; j < size; j++) {
            GVRChecker *checker = nil;
            
            GVRBoardPosition *position = self[[self indexForRow:i column:j]];
            
            if (GVRBoardPositionColorBlack == position.color) {
                if (i < rows) {
                    checker = [whiteChecker copy];
                }
                
                if (i >= size - rows) {
                    checker = [blackChecker copy];
                }
                
                [self addChecker:checker atRow:i column:j];
            }
        }
    }
}

#pragma mark -
#pragma mark Public Methods

- (NSUInteger)indexForRow:(NSUInteger)row column:(NSUInteger)column {
    return self.size * row + column;
}

- (NSUInteger)indexForCell:(GVRBoardCell)cell {
    return [self indexForRow:cell.row column:cell.column];
}

- (BOOL)isCheckerPresentAtRow:(NSUInteger)row column:(NSUInteger)column {
    return self[[self indexForRow:row column:column]].isFilled;
}

- (BOOL)isCheckerPresentAtCell:(GVRBoardCell)cell {
    return [self isCheckerPresentAtRow:cell.row column:cell.column];
}

- (GVRBoardPosition *)objectAtIndexedSubscript:(NSUInteger)index {
    return self.positions[index];
}

- (void)setObject:(GVRChecker *)object atIndexedSubscript:(NSUInteger)index {
    self.positions[index] = object;
}

- (GVRChecker *)checkerAtRow:(NSUInteger)row column:(NSUInteger)column {
    return self[row * self.size + column].checker;
}

- (void)addChecker:(GVRChecker *)checker atRow:(NSUInteger)row column:(NSUInteger)column {
    if (!checker || [self isCheckerPresentAtRow:row column:column]) {
        return;
    }
    
    [self setChecker:checker atRow:row column:column];
        
    if (GVRCheckerColorBlack == checker.color) {
        self.blackCheckersCount++;
    } else if (GVRCheckerColorWhite == checker.color) {
        self.whiteCheckersCount++;
    }
}

- (void)addChecker:(GVRChecker *)checker atCell:(GVRBoardCell)cell {
    [self addChecker:checker atRow:cell.row column:cell.column];
}

- (void)removeCheckerAtRow:(NSUInteger)row column:(NSUInteger)column {
    if (![self isCheckerPresentAtRow:row column:column]) {
        return;
    }
    
    GVRChecker *checker = self[[self indexForRow:row column:column]].checker;
    GVRCheckerColor color = checker.color;
    if (GVRCheckerColorBlack == color) {
        self.blackCheckersCount--;
    } else if (GVRCheckerColorWhite == color) {
        self.whiteCheckersCount--;
    }
    
    [self setChecker:nil atRow:row column:column];
}

- (void)removeCheckerAtCell:(GVRBoardCell)cell {
    [self removeCheckerAtRow:cell.row column:cell.column];
}

- (void)moveCheckerFrom:(GVRBoardPosition *)fromPostion to:(GVRBoardPosition *)toPosition {
    [self moveCheckerFromRow:fromPostion.row
                      column:fromPostion.column
                       toRow:toPosition.row
                      column:toPosition.column];
}

- (void)moveCheckerFromCell:(GVRBoardCell)fromCell toCell:(GVRBoardCell)toCell {
    [self moveCheckerFromRow:fromCell.row
                      column:fromCell.column
                       toRow:toCell.row
                      column:toCell.column];
}

- (void)moveCheckerFromRow:(NSUInteger)fromRow
                    column:(NSUInteger)fromColumn
                     toRow:(NSUInteger)toRow
                    column:(NSUInteger)toColumn
{
    if (fromRow == toRow && fromColumn == toColumn) {
        return;
    }
    
    GVRChecker *checker = [self positionForRow:fromRow column:fromColumn].checker;
    
    NSUInteger size = self.size;
    if (GVRCheckerTypeMan == checker.type) {
        if ((GVRCheckerColorWhite == checker.color && toRow == size - 1)
            || (GVRCheckerColorBlack == checker.color && toRow == 0))
        {
            [checker promoteCheckerType];
        }
    }
    
    [self addChecker:checker atRow:toRow column:toColumn];
    
    [self removeCheckerAtRow:fromRow column:fromColumn];
}

- (void)resetMarkedForRemovalCheckers {
    [self.positions performBlockWithEachObject:^(GVRBoardPosition *position) {
        position.checker.markedForRemoval = NO;
    }];
}

- (void)iterateDiagonallyFromCell:(GVRBoardCell)fromCell
                    withDirection:(GVRBoardDirection)direction
                            block:(void (^)(GVRBoardPosition *position, BOOL *stop))block
{
    GVRBoardCell toCell = GVREdgeCellMake(self.size, fromCell, direction);
    
    [self iterateDiagonallyFromCell:fromCell toCell:toCell withBlock:block];
}

- (void)iterateDiagonallyFromCell:(GVRBoardCell)fromCell
                           toCell:(GVRBoardCell)toCell
                        withBlock:(void (^)(GVRBoardPosition *position, BOOL *stop))block
{
    if (labs(fromCell.row - toCell.row) != labs(fromCell.column - toCell.column)) {
        return;
    }
    
    GVRBoardPosition *fromPosition = [self positionForCell:fromCell];
    GVRBoardPosition *toPosition = [self positionForCell:toCell];
    GVRBoardDirection direction = [fromPosition directionToPosition:toPosition];
    
    for (NSInteger row = fromPosition.row, column = fromPosition.column;
         row != toPosition.row + direction.rowDirection;
         row += direction.rowDirection, column += direction.columnDirection)
    {
        BOOL stop = NO;
        
        GVRBoardPosition *position = [self positionForRow:row column:column];
        if (!position) {
            return;
        }
        
        GVRBlockPerform(block, position, &stop);
        
        if (stop) {
            return;
        }
    }
}


- (GVRBoardPosition *)victimPositionFromCell:(GVRBoardCell)fromCell
                                   direction:(GVRBoardDirection)direction
                                   forPlayer:(GVRPlayer)player
                                       error:(NSError **)error
{
    GVRBoardCell toCell = GVREdgeCellMake(self.size, fromCell, direction);
    
    return [self victimPositionFromCell:fromCell
                                 toCell:toCell
                              forPlayer:player
                                  error:error];
}

- (GVRBoardPosition *)victimPositionFromCell:(GVRBoardCell)fromCell
                                      toCell:(GVRBoardCell)toCell
                                   forPlayer:(GVRPlayer)player
                                       error:(NSError **)error
{
    __block GVRBoardPosition *victimPosition = nil;
    
    GVRBoardCell startingCell = GVRBoardCellShift(fromCell, GVRBoardDirectionUsingCells(fromCell, toCell), 1);
    
    [self iterateDiagonallyFromCell:startingCell
                             toCell:toCell
                          withBlock:^(GVRBoardPosition *position, BOOL *stop)
    {
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

- (BOOL)isReqFirstMoveAvailalbleForPlayer:(GVRPlayer)player {
    GVRCheckerColor color = GVRCheckerColorForPlayer(player);
    
    for (GVRBoardPosition *position in self.positions) {
        GVRChecker *candidateChecker = position.checker;
        if (position.isFilled && color == candidateChecker.color) {
            if ([self isReqFirstMoveAvailalbleForChecker:candidateChecker
                                                fromCell:position.cell
                                                  player:player])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)isReqFirstMoveAvailalbleForChecker:(GVRChecker *)checker
                                  fromCell:(GVRBoardCell)cell
                                    player:(GVRPlayer)player
{
    BOOL (^isReqMoveAvailalbleWithDirection)(GVRBoardDirection) = ^BOOL(GVRBoardDirection direction) {
        return [self isReqMoveAvailalbleForChecker:checker
                                          fromCell:cell
                                         direction:direction
                                            player:player
                                       isFirstMove:YES];
    };
    
    return isReqMoveAvailalbleWithDirection(GVRBoardDirectionMake(+1, +1))
    || isReqMoveAvailalbleWithDirection(GVRBoardDirectionMake(+1, -1))
    || isReqMoveAvailalbleWithDirection(GVRBoardDirectionMake(-1, +1))
    || isReqMoveAvailalbleWithDirection(GVRBoardDirectionMake(-1, -1));
}

- (BOOL)isReqMoveAvailalbleForChecker:(GVRChecker *)checker
                             fromCell:(GVRBoardCell)fromCell
                            direction:(GVRBoardDirection)direction
                               player:(GVRPlayer)player
                          isFirstMove:(BOOL)isFirstMove
{
    BOOL (^isVictimPresent)(GVRBoardCell, GVRBoardDirection, GVRPlayer)
    = ^BOOL(GVRBoardCell cell, GVRBoardDirection direction, GVRPlayer player)
    {
        GVRBoardPosition *victimPosition = [self victimPositionFromCell:cell
                                                              direction:direction
                                                              forPlayer:player
                                                                  error:nil];
        
        return (victimPosition) && [checker isAllowedDistanceToVictimFromCell:cell toCell:victimPosition.cell];
    };
    
    GVRBoardDirection direction1 = direction.rowDirection != direction.columnDirection
    ? GVRBoardDirectionMake(+1, +1) : GVRBoardDirectionMake(+1, -1);
    GVRBoardDirection direction2 = direction.rowDirection != direction.columnDirection
    ? GVRBoardDirectionMake(-1, -1) : GVRBoardDirectionMake(-1, +1);
    
    __block BOOL isTrajectoryAvailable = NO;
    if (isVictimPresent(fromCell, direction, player)) {
        isTrajectoryAvailable = YES;
        
        return isTrajectoryAvailable;
    }
    
    if (isFirstMove) {
        return isTrajectoryAvailable;
    }
    
    
    [self iterateDiagonallyFromCell:fromCell
                      withDirection:direction
                              block:^(GVRBoardPosition *position, BOOL *stop)
     {
         
         if (position.isFilled && !position.checker.markedForRemoval) {
             *stop = YES;
             isTrajectoryAvailable = NO;
             
             return;
         }
         
         GVRBoardCell candidateCell = [position cell];
         if (isVictimPresent(candidateCell, direction1, player)
             || isVictimPresent(candidateCell, direction2, player))
         {
             *stop = YES;
             isTrajectoryAvailable = YES;
             
             return;
         }
         
         if (![checker isAllowedDistanceToVictimFromCell:fromCell toCell:position.cell]) {
             *stop = YES;
             isTrajectoryAvailable = NO;
             
             return;
         }
     }];
    
    return isTrajectoryAvailable;
}

#pragma mark -
#pragma mark Private Methods

- (void)setChecker:(GVRChecker *)checker atRow:(NSUInteger)row column:(NSUInteger)column {
    NSUInteger index = [self indexForRow:row column:column];
    self[index].checker = checker;
}

@end
