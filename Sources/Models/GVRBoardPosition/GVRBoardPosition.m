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

@interface GVRBoardPosition ()
@property (nonatomic, assign)   NSUInteger              row;
@property (nonatomic, assign)   NSUInteger              column;
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

- (instancetype)positionShiftedByDeltaRows:(NSInteger)deltaRows
                              deltaColumns:(NSUInteger)deltaColumns
{
    NSInteger row = self.row + deltaRows;
    NSInteger column = self.column + deltaColumns;
    NSUInteger size = self.board.size;
    
    if (row < 0 || row >= size || column < 0 || column >= size) {
        return nil;
    }
    
    return [self.board positionForRow:row column:column];
}

@end
