//
//  GVRCellView.h
//  Checkers
//
//  Created by Ievgen on 1/15/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GVRBoardView.h"
#import "GVRBoard.h"
#import "GVRBoardPosition.h"

@interface GVRCellView : UIView
@property (nonatomic, assign, readonly) NSUInteger      row;
@property (nonatomic, assign, readonly) NSUInteger      column;
@property (nonatomic, assign, readonly) float           cellSize;
@property (nonatomic, assign, readonly) GVRBoardCell    boardCell;


+ (instancetype)cellWithCell:(GVRBoardCell)cell
                       board:(GVRBoard *)board
                   boardView:(GVRBoardView *)boarView;


- (instancetype)initWithCell:(GVRBoardCell)cell
                       board:(GVRBoard *)board
                   boardView:(GVRBoardView *)boardView;




@end
