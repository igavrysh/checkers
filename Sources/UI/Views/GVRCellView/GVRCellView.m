//
//  GVRCellView.m
//  Checkers
//
//  Created by Ievgen on 1/15/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRCellView.h"

@interface GVRCellView ()
@property (nonatomic, assign)           NSUInteger          row;
@property (nonatomic, assign)           NSUInteger          column;
@property (nonatomic, weak)             GVRBoard            *board;
@property (nonatomic, weak)             GVRBoardView        *boardView;
@property (nonatomic, readonly)         UIColor             *color;
@property (nonatomic, readonly)         GVRSubViewTag       subViewTag;
@property (nonatomic, readonly)         GVRBoardPosition    *position;

@end

@implementation GVRCellView

@dynamic cellSize;
@dynamic color;
@dynamic tag;
@dynamic position;

#pragma mark -
#pragma mark Class Methods

+ (instancetype)cellWithCell:(GVRBoardCell)cell
                       board:(GVRBoard *)board
                   boardView:(GVRBoardView *)boardView
{
    return [[self alloc] initWithCell:cell board:board boardView:boardView];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithCell:(GVRBoardCell)cell
                       board:(GVRBoard *)board
                   boardView:(GVRBoardView *)boardView

{
    self = [super init];
    
    if (self) {
        self.row = cell.row;
        self.column = cell.column;
        self.board = board;
        self.boardView = boardView;
    
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    float cellSize = self.cellSize;
    CGRect frame = CGRectMake(self.row * cellSize, self.column * cellSize, cellSize, cellSize);
    [self setFrame:frame];
    self.backgroundColor = self.color;
    self.tag = self.subViewTag;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
        | UIViewAutoresizingFlexibleTopMargin
        | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleRightMargin;
}

#pragma mark -
#pragma mark Accessors

- (GVRBoardPosition *)position {
    return [self.board positionForCell:GVRBoardCellMake(self.row, self.column)];
}

- (float)cellSize {
    return self.boardView.boardSize / self.board.size;
}

- (UIColor *)color {
    GVRBoardPosition *position = self.position;
    
    return !position ? nil
        : position.color == GVRBoardPositionColorWhite ? [UIColor lightGrayColor] : [UIColor darkGrayColor];
}

- (GVRSubViewTag)subViewTag {
    GVRBoardPosition *position = self.position;
    
    return !position ? 0
        : position.color == GVRBoardPositionColorWhite ? GVRSubViewTagWhiteCell : GVRSubViewTagBlackCell;
}


@end
