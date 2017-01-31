//
//  GVRBoardView.m
//  Checkers
//
//  Created by Ievgen on 1/11/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRBoardView.h"

#import "GVRCellView.h"
#import "GVRCheckerView.h"
#import "GVRBoard.h"
#import "GVRBoardPosition.h"

@interface GVRBoardView ()
@property (nonatomic, weak)             UIView          *baseBoardView;
@property (nonatomic, assign, readonly) float           leftMargin;
@property (nonatomic, assign, readonly) float           topMargin;
@property (nonatomic, strong)           NSMutableArray  *checkers;
@property (nonatomic, strong)           NSMutableArray  *cells;

- (void)initBoard;

- (void)initCheckerAtRow:(NSUInteger)row
                  column:(NSUInteger)column
            withCellSize:(float)cellSize;

- (UIView *)createBoardWithFrame:(CGRect)frame
                           color:(UIColor*)color
                          parent:(UIView *)parent
                             tag:(GVRSubViewTag)tag;

- (NSUInteger)indexForRow:(NSUInteger)row column:(NSUInteger)column;

- (void)iterateBoardWithBlock:(void (^)(NSUInteger row, NSUInteger column))block;

@end

@implementation GVRBoardView

@dynamic boardSize;
@dynamic leftMargin;
@dynamic topMargin;

#pragma mark -
#pragma mark Accessors

- (void)setBoard:(GVRBoard *)board {
    if (_board != board) {
        _board = board;
        
        [self initBoard];
    }
}

- (void)setActivePlayer:(GVRPlayer)activePlayer {
    if (_activePlayer != activePlayer) {
        _activePlayer = activePlayer;
        
        [self initBoard];
    }
}

- (float)leftMargin {
    CGRect bounds = self.bounds;
    
    return MIN(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)) / 25.f;
}

- (float)topMargin {
    CGRect bounds = self.bounds;
    
    return MAX(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)) / 2.f - self.boardSize / 2.f;
}

- (float)boardSize {
    CGRect bounds = self.bounds;
    
    return (MIN(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)) - self.leftMargin * 2.f );
}

#pragma mark -
#pragma mark Public Methods

- (GVRCellView *)cellViewForRow:(NSUInteger)row column:(NSUInteger)column {
    NSUInteger index = [self indexForRow:row column:column];
    
    return index < self.cells.count ? self.cells[index] : nil;
}

- (GVRCheckerView *)checkerViewForRow:(NSUInteger)row column:(NSUInteger)column {
    for (GVRCheckerView *checkerView in self.checkers) {
        if (checkerView.row == row && checkerView.column == column) {
            return checkerView;
        }
    }
    
    return nil;
}

- (CGPoint)locationInBaseBoardViewForTouch:(UITouch *)touch {
    return [touch locationInView:self.baseBoardView];
}

- (GVRCellView *)cellForInBoardTouch:(UITouch *)touch {
    CGPoint point = [self locationInBaseBoardViewForTouch:touch];
    for (GVRCellView *cell in self.cells) {
        if (CGRectContainsPoint(cell.frame, point)) {
            return cell;
        }
    }
    
    return nil;
}

- (void)initBoard {
    [self initBoardBase];
    
    [self initCells];
    
    NSInteger multiplier = -1; // self.activePlayer == GVRPlayerWhiteCheckers ? -1 : 1;
    
    self.baseBoardView.transform = CGAffineTransformRotate(self.baseBoardView.transform, multiplier * M_PI / 2);
}

- (void)updateCheckers {
    for (GVRCheckerView *checkerView in self.checkers) {
        [checkerView removeFromSuperview];
    }
    
    [self iterateBoardWithBlock:^(NSUInteger row, NSUInteger column) {
        GVRCellView *cellView = [self cellViewForRow:row column:column];
        
        GVRCheckerView *checkerView = [self checkerViewForRow:row column:column];
        if (checkerView) {
            [checkerView removeFromSuperview];
        }
        
        [self initCheckerAtRow:row column:column withCellSize:cellView.cellSize];
    }];
}

#pragma mark - 
#pragma mark Private Methods

- (NSUInteger)indexForRow:(NSUInteger)row column:(NSUInteger)column {
    return self.board.size * row + column;
}

- (void)initBoardBase {
    float leftMargin = self.leftMargin;
    float boardSize = self.boardSize;
    float topMargin = self.topMargin;
    
    CGRect boardFrame = CGRectMake(leftMargin, topMargin, boardSize, boardSize);
    
    UIView *boardBaseView = [self createBoardWithFrame:boardFrame
                                                 color:[UIColor brownColor]
                                                parent:self
                                                   tag:GVRSubViewTagBoard];
    
    boardBaseView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
        | UIViewAutoresizingFlexibleTopMargin
        | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleRightMargin;
    
    [self addSubview:boardBaseView];
    
    self.baseBoardView = boardBaseView;
}

- (void)iterateBoardWithBlock:(void (^)(NSUInteger row, NSUInteger column))block {
    if (!block) {
        return;
    }
    
    NSUInteger size = self.board.size;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            block(i, j);
        }
    }
}

- (void)initCells {
    self.cells = [NSMutableArray new];
    self.checkers = [NSMutableArray new];
    
    [self iterateBoardWithBlock:^(NSUInteger row, NSUInteger column) {
        GVRCellView *cellView = [GVRCellView cellWithCell:GVRBoardCellMake(row, column)
                                                    board:self.board
                                                boardView:self];
        if (cellView) {
            [self.baseBoardView addSubview:cellView];
            
            [self.cells addObject:cellView];
            
            [self initCheckerAtRow:row column:column withCellSize:cellView.cellSize];
        }
    }];
}

- (void)initCheckerAtRow:(NSUInteger)row
                  column:(NSUInteger)column
            withCellSize:(float)cellSize
{
    GVRBoardCell cell = GVRBoardCellMake(row, column);
    GVRBoardPosition *position = [self.board positionForCell:cell];
    if (!position.isFilled) {
        return;
    }
    
    GVRCheckerView *checker = [GVRCheckerView checkerOnCell:cell
                                                   cellSize:cellSize
                                                      board:self.board
                                                  boardView:self];
    
    if (checker) {
        [self.baseBoardView addSubview:checker];
        [self.checkers addObject:checker];
    }
}
 
- (UIView *)createBoardWithFrame:(CGRect)frame
                           color:(UIColor*)color
                          parent:(UIView *)parent
                             tag:(GVRSubViewTag)tag
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    view.tag = tag;
    [parent addSubview:view];
    
    return view;
}

@end
