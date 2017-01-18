//
//  GVRBoardPosition.m
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import "GVRBoardPosition.h"

#import "GVRBoard.h"

GVRBoardCell GVRBoardCellMake(NSUInteger row, NSUInteger column) {
    GVRBoardCell cell;
    cell.row = row;
    cell.column = column;
    
    return cell;
}

GVRBoardDirection GVRBoardDirectionMake(NSInteger rowDirectin,
                                        NSInteger columnDirection)
{
    GVRBoardDirection direction;
    direction.rowDirection = rowDirectin;
    direction.columnDirection = columnDirection;
    
    return direction;
}

GVRBoardDirection GVRBoardDirectionUsingCells(GVRBoardCell fromCell,
                                              GVRBoardCell toCell)
{
    NSInteger deltaRow = toCell.row - fromCell.row;
    NSInteger deltaColumn = toCell.column - fromCell.column;
    
    return 0 == deltaColumn || 0 == deltaRow
        ? GVRBoardDirectionMake(0, 0)
        : GVRBoardDirectionMake(deltaRow/labs(deltaRow), deltaColumn/labs(deltaColumn));
}

GVRBoardCell GVRBoardCellShift(GVRBoardCell cell,
                               GVRBoardDirection direction,
                               NSInteger delta) {
    GVRBoardCell shiftedCell;
    shiftedCell.row = cell.row + direction.rowDirection * delta;
    shiftedCell.column = cell.column + direction.columnDirection * delta;
    
    return shiftedCell;
}

NSUInteger GVRRowDistanceBetweenCells(GVRBoardCell cell1, GVRBoardCell cell2) {
    return ABS(cell1.row - cell2.row);
}

BOOL GVRIsDiagonalDistance(GVRBoardCell cell1, GVRBoardCell cell2) {
    return labs((NSInteger)cell1.row - (NSInteger)cell2.row)
        == labs((NSInteger)cell1.column - (NSInteger)cell2.column)
            ? YES : NO;
}

BOOL GVRBoardCellIsEqualToBoardCell(GVRBoardCell cell1, GVRBoardCell cell2) {
    return cell1.row == cell2.row && cell2.column == cell2.column ? YES : NO;
}

BOOL GVRBoardDirectionIsEqualToBoardDirection(GVRBoardDirection direction1,
                                              GVRBoardDirection direction2)
{
    return direction1.rowDirection == direction2.rowDirection
        && direction1.columnDirection == direction2.columnDirection;
}

GVRBoardCell GVREdgeCellMake(NSUInteger size,
                            GVRBoardCell fromCell,
                                GVRBoardDirection direction)
{
    GVRBoardCell toCell;
    
    NSInteger minDistance;
    
    if (direction.rowDirection == 1) {
        if (direction.columnDirection == 1) {
            minDistance = MIN(size - fromCell.row - 1, size - fromCell.column - 1);
        } else if (direction.columnDirection == -1) {
            minDistance = MIN(size - fromCell.row - 1, fromCell.column);
        }
    } else if (direction.rowDirection == -1) {
        if (direction.columnDirection == 1)  {
            minDistance = MIN(fromCell.row, size - fromCell.column - 1);
        } else if (direction.columnDirection == -1) {
            minDistance = MIN(fromCell.row, fromCell.column);
        }
    }
    
    toCell.row = fromCell.row + direction.rowDirection * minDistance;
    toCell.column = fromCell.column + direction.columnDirection * minDistance;
    
    return toCell;
}

@interface GVRBoardPosition ()
@property (nonatomic, assign)   NSUInteger               row;
@property (nonatomic, assign)   NSUInteger               column;
@property (nonatomic, weak)     GVRBoard                *board;

@end

@implementation GVRBoardPosition

@dynamic color;
@dynamic isFilled;

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithRow:(NSUInteger)row
                     column:(NSUInteger)column
                      board:(GVRBoard *)board
{
    self = [super init];
    if (self) {
        self.board = board;
        self.row = row;
        self.column = column;
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (GVRBoardPositionColor)color {
    return (self.row + self.column) % 2 == 0 ? GVRBoardPositionColorBlack : GVRBoardPositionColorWhite;
}

- (BOOL)isFilled {
    return self.checker;
}

#pragma mark -
#pragma mark Public Methods

- (BOOL)isEqualToPosition:(GVRBoardPosition *)position {
    return self.row == position.row && self.column == position.column;
}

- (instancetype)positionShiftedByDeltaRows:(NSInteger)deltaRows deltaColumns:(NSInteger)deltaColumns {
    NSInteger row = self.row + deltaRows;
    NSInteger column = self.column + deltaColumns;
    NSUInteger size = self.board.size;
    
    if (row < 0 || row >= size || column < 0 || column >= size) {
        return nil;
    }
    
    return [self.board positionForRow:row column:column];
}

- (instancetype)positionShiftedByDirection:(GVRBoardDirection)direction distance:(NSInteger)distance {
    return [self positionShiftedByDeltaRows:distance * direction.rowDirection
                               deltaColumns:distance * direction.columnDirection];
}


- (NSInteger)rowDeltaToPosition:(GVRBoardPosition *)position {
    return (NSInteger)position.row - (NSInteger)self.row;
}

- (NSInteger)columnDeltaToPosition:(GVRBoardPosition *)position {
    return (NSInteger)position.column - (NSInteger)self.column;
}

- (NSInteger)rowDirectionToPosition:(GVRBoardPosition *)position {
    NSInteger delta = [self rowDeltaToPosition:position];
    
    return delta != 0 ? delta / labs(delta) : 0;
}

- (NSInteger)columnDirectionToPosition:(GVRBoardPosition *)position {
    NSInteger delta = [self columnDeltaToPosition:position];
    
    return delta != 0 ? delta / labs(delta) : 0;
}

- (GVRBoardDirection)directionToPosition:(GVRBoardPosition *)position {
    GVRBoardDirection direction;
    direction.rowDirection = [self rowDirectionToPosition:position];
    direction.columnDirection = [self columnDirectionToPosition:position];
    
    return direction;
}

- (GVRBoardCell)cell {
    GVRBoardCell cell;
    cell.row = self.row;
    cell.column = self.column;
    
    return cell;
}

@end
