//
//  GVRCheckerView.m
//  Checkers
//
//  Created by Ievgen on 1/15/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRCheckerView.h"

@interface GVRCheckerView ()
@property (nonatomic, assign)   NSUInteger          row;
@property (nonatomic, assign)   NSUInteger          column;
@property (nonatomic, readonly) GVRBoardPosition    *position;
@property (nonatomic, weak)     GVRBoard            *board;
@property (nonatomic, weak)     GVRBoardView        *boardView;
@property (nonatomic, assign)   float               cellSize;

@end

@implementation GVRCheckerView

@dynamic position;

#pragma mark -
#pragma mark Public Methods

+ (instancetype)checkerOnCell:(GVRBoardCell)cell
                     cellSize:(float)cellSize
                        board:(GVRBoard *)board
                    boardView:(GVRBoardView *)boardView
{
    return [[self alloc] initWithCell:cell cellSize:cellSize board:board boardView:boardView];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithCell:(GVRBoardCell)cell
                    cellSize:(float)cellSize
                       board:(GVRBoard *)board
                   boardView:(GVRBoardView *)boardView
{
    self = [super init];
    if (self) {
        self.row = cell.row;
        self.column = cell.column;
        self.board = board;
        self.boardView = boardView;
        self.cellSize = cellSize;
        
        [self initChecker];
    }
    
    return self;
}

- (void)initChecker {
    float cellSize = self.cellSize;
    
    float checkerCellRatio = 0.5;
    
    float checkerSize = cellSize * checkerCellRatio;
    float checkerOrigin = (cellSize * (1 - checkerCellRatio)) / 2.f;
    float checkerOriginX = self.row * cellSize + checkerOrigin;
    float checkerOriginY = self.column * cellSize + checkerOrigin;
    
    CGRect checkerRect = CGRectMake(checkerOriginX, checkerOriginY, checkerSize, checkerSize);
    
    [self setFrame:checkerRect];
    self.backgroundColor = self.color;
    self.tag = GVRSubViewTagChecker;
}

#pragma mark -
#pragma mark Accessors

- (UIColor *)color {
    GVRCheckerColor color = self.position.checker.color;
    
    return color == GVRCheckerColorWhite ? [UIColor whiteColor] :
        color == GVRCheckerColorBlack ? [UIColor blackColor] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}

- (GVRBoardPosition *)position {
    return [self.board positionForCell:GVRBoardCellMake(self.row, self.column)];
}

@end
