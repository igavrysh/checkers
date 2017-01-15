//
//  GVRCheckerView.h
//  Checkers
//
//  Created by Ievgen on 1/15/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GVRBoardView.h"
#import "GVRBoard.h"
#import "GVRBoardPosition.h"

@interface GVRCheckerView : UIView

+ (instancetype)checkerOnCell:(GVRBoardCell)cell
                     cellSize:(float)cellSize
                        board:(GVRBoard *)board
                    boardView:(GVRBoardView *)boardView;

- (instancetype)initWithCell:(GVRBoardCell)cell
                    cellSize:(float)cellSize
                       board:(GVRBoard *)board
                   boardView:(GVRBoardView *)boardView;

@end
