//
//  GVRBoardView.m
//  Checkers
//
//  Created by Ievgen on 1/11/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRBoardView.h"

#import "GVRBoard.h"
#import "GVRBoardPosition.h"

typedef enum {
    GVRSubViewTagBlackCell,
    GVRSubViewTagWhiteCell,
    GVRSubViewTagChecker,
    GVRSubViewTagBoard
} GVRSubViewTag;

@interface GVRBoardView ()
@property (nonatomic, strong)           UIView  *boardView;
@property (nonatomic, assign, readonly) float   side;
@property (nonatomic, assign, readonly) float   leftMargin;
@property (nonatomic, assign, readonly) float   topMargin;

- (void)drawBoard;

- (UIColor *)colorForBoardPositionColor:(GVRBoardPositionColor)color;

- (UIColor *)colorForCheckerWithCheckerColor:(GVRCheckerColor)color;

- (GVRSubViewTag)tagForBoardPositionColor:(GVRBoardPositionColor)color;

- (void)drawCheckerOnView:(UIView *)view row:(NSUInteger)row column:(NSUInteger)column;

- (UIView *)createBoardWithFrame:(CGRect)frame
                           color:(UIColor*)color
                          parent:(UIView *)parent
                             tag:(GVRSubViewTag)tag;

@end

@implementation GVRBoardView

@dynamic side;
@dynamic leftMargin;
@dynamic topMargin;

#pragma mark -
#pragma mark Accessors

- (void)setBoard:(GVRBoard *)board {
    if (_board != board) {
        _board = board;
        
        [self drawBoard];
    }
}

- (float)leftMargin {
    CGRect bounds = self.bounds;
    
    return MIN(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)) / 25.f;
}

- (float)topMargin {
    CGRect bounds = self.bounds;
    
    return MAX(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)) / 2.0 - self.board.size / 2 * self.side;
}

- (float)side {
    CGRect bounds = self.bounds;
    
    return (MIN(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)) - self.leftMargin * 2 ) / self.board.size;
}

#pragma mark - 
#pragma mark Private Methods

- (UIColor *)colorForBoardPositionColor:(GVRBoardPositionColor)color {
    return color == GVRBoardPositionColorWhite ? [UIColor lightGrayColor] : [UIColor darkGrayColor];
}

- (UIColor *)colorForCheckerWithCheckerColor:(GVRCheckerColor)color {
    return color == GVRCheckerColorWhite ? [UIColor whiteColor] :
    color == GVRCheckerColorBlack ? [UIColor blackColor] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}

- (GVRSubViewTag)tagForBoardPositionColor:(GVRBoardPositionColor)color {
    return color == GVRBoardPositionColorWhite ? GVRSubViewTagWhiteCell : GVRSubViewTagBlackCell;
}

- (void)drawBoard {
    [self drawBoardBase];
    
    [self drawCells];
}

- (void)drawBoardBase {
    NSUInteger size = self.board.size;
    float leftMargin = self.leftMargin / 2;
    float side = self.side;
    float topMargin = self.topMargin - leftMargin;
    float boardSize = leftMargin + size * side;
    
    CGRect boardFrame = CGRectMake(leftMargin, topMargin, boardSize, boardSize);
    
    UIView *boardView = [self createBoardWithFrame:boardFrame
                                             color:[UIColor brownColor]
                                            parent:self
                                               tag:GVRSubViewTagBoard];
    
    boardView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
        | UIViewAutoresizingFlexibleTopMargin
        | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleRightMargin;
    
    [self addSubview:boardView];
    
    self.boardView = boardView;
}

- (void)drawCells {
    NSUInteger size = self.board.size;
    
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            GVRBoardCell cell = GVRBoardCellMake(i, j);
            
            float side = self.side;
            float origin = self.leftMargin / 2 + i * side;
            
            CGRect frame = CGRectMake(origin,origin, side, side);
            
            GVRBoardPositionColor positionColor = [[self.board positionForCell:cell] color];
            UIColor *color = [self colorForBoardPositionColor:positionColor];
            GVRSubViewTag tag = [self tagForBoardPositionColor:positionColor];
            UIView *view = [self createBoardWithFrame:frame color:color parent:self.boardView tag:tag];
            
            view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
                | UIViewAutoresizingFlexibleTopMargin
                | UIViewAutoresizingFlexibleBottomMargin
                | UIViewAutoresizingFlexibleRightMargin;
            
            [self drawCheckerOnView:view row:i column:j];
        }
    }
}

- (void)drawCheckerOnView:(UIView *)view row:(NSUInteger)row column:(NSUInteger)column {
    GVRBoardCell cell = GVRBoardCellMake(row, column);
    GVRBoardPosition *position = [self.board positionForCell:cell];
    if (!position.isFilled) {
        return;
    }
    
    UIColor *checkerColor = [self colorForCheckerWithCheckerColor:position.checker.color];
    
    NSInteger cellSize = view.bounds.size.width;
    
    float checkerCellRatio = 0.4;
    
    NSUInteger checkerSize = cellSize * 0.4;
    NSUInteger checkerOrigin = (cellSize * (1 - checkerCellRatio)) / 2;
    
    CGRect checkerRect = CGRectMake(checkerOrigin, checkerOrigin, checkerSize, checkerSize);
    
    [self createBoardWithFrame:checkerRect
                         color:checkerColor
                        parent:self.boardView
                           tag:GVRSubViewTagChecker];
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
