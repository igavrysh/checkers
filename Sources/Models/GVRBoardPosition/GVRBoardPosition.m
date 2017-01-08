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

BOOL GVRIsDiagonalDistance(GVRBoardCell cell1, GVRBoardCell cell2) {
    return labs((NSInteger)cell1.row - (NSInteger)cell2.row) == labs((NSInteger)cell1.column - (NSInteger)cell2.column)
        ? YES : NO;
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
    NSInteger delta = [self rowDirectionToPosition:position];
    
    return delta / labs(delta);
}

- (NSInteger)columnDirectionToPosition:(GVRBoardPosition *)position {
    NSInteger delta = [self columnDeltaToPosition:position];
    
    return delta / labs(delta);
}

- (GVRBoardDirection)directionToPosition:(GVRBoardPosition *)position {
    GVRBoardDirection direction;
    direction.rowDirection = [self rowDirectionToPosition:position];
    direction.columnDirection = [self columnDirectionToPosition:position];
    
    return direction;
}

@end
