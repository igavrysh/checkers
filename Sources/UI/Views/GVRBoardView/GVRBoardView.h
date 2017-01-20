//
//  GVRBoardView.h
//  Checkers
//
//  Created by Ievgen on 1/11/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GVRGame.h"

@class GVRBoard;
@class GVRCellView;

typedef enum {
    GVRSubViewTagBlackCell,
    GVRSubViewTagWhiteCell,
    GVRSubViewTagChecker,
    GVRSubViewTagBoard
} GVRSubViewTag;

@interface GVRBoardView : UIView
@property (nonatomic, strong)           GVRBoard        *board;
@property (nonatomic, weak, readonly)   UIView          *baseBoardView;
@property (nonatomic, assign)           GVRPlayer       activePlayer;
@property (nonatomic, readonly)         NSMutableArray  *checkers;
@property (nonatomic, readonly)         NSMutableArray  *cells;
@property (nonatomic, assign, readonly) float           boardSize;

- (void)initBoard;

- (void)updateCheckers;

- (CGPoint)locationInBaseBoardViewForTouch:(UITouch *)touch;

- (GVRCellView *)cellForInBoardTouch:(UITouch *)touch;

@end
