//
//  GVRBoardPosition.h
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVRChecker.h"

@class GVRBoard;

typedef enum : NSUInteger {
    GVRBoardPositionColorWhite,
    GVRBoardPositionColorBlack
} GVRBoardPositionColor;

struct GVRBoardCell {
    NSInteger row;
    NSInteger column;
};

typedef struct GVRBoardCell GVRBoardCell;

struct GVRBoardDirection {
    NSInteger rowDirection;
    NSInteger columnDirection;
};

typedef struct GVRBoardDirection GVRBoardDirection;

extern GVRBoardCell GVRBoardCellMake(NSUInteger row, NSUInteger column);

extern GVRBoardDirection GVRBoardDirectionMake(NSInteger rowDirectin,
                                               NSInteger columnDirection);

extern GVRBoardDirection GVRBoardDirectionUsingCells(GVRBoardCell fromCell,
                                                     GVRBoardCell toCell);

extern NSInteger GVRRowDistanceBetweenCells(GVRBoardCell fromCell, GVRBoardCell toCell);

extern BOOL GVRIsDiagonalDistance(GVRBoardCell cell1, GVRBoardCell cell2);

extern GVRBoardCell GVRBoardCellShift(GVRBoardCell cell, GVRBoardDirection direction, NSInteger delta);

extern GVRBoardCell GVREdgeCellMake(NSUInteger size,
                                    GVRBoardCell fromCell,
                                    GVRBoardDirection direction);

extern BOOL GVRBoardCellIsEqualToBoardCell(GVRBoardCell cell1, GVRBoardCell cell2);

extern BOOL GVRBoardDirectionIsEqualToBoardDirection(GVRBoardDirection direction1,
                                                     GVRBoardDirection direction2);

@interface GVRBoardPosition : NSObject
@property (nonatomic, readonly)         NSUInteger              row;
@property (nonatomic, readonly)         NSUInteger              column;
@property (nonatomic, strong)           GVRChecker              *checker;
@property (nonatomic, weak, readonly)   GVRBoard                *board;
@property (nonatomic, readonly)         GVRBoardPositionColor   color;
@property (nonatomic, readonly, getter=isFilled)    BOOL        isFilled;
@property (nonatomic, assign, readonly) GVRBoardCell            cell;

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column board:(GVRBoard *)board;

- (BOOL)isEqualToPosition:(GVRBoardPosition *)position;

- (instancetype)positionShiftedByDeltaRows:(NSInteger)deltaRows deltaColumns:(NSInteger)deltaColumns;

- (instancetype)positionShiftedByDirection:(GVRBoardDirection)direction distance:(NSInteger)distance;

- (NSInteger)rowDeltaToPosition:(GVRBoardPosition *)position;

- (NSInteger)columnDeltaToPosition:(GVRBoardPosition *)position;

- (NSInteger)rowDirectionToPosition:(GVRBoardPosition *)position;

- (NSInteger)columnDirectionToPosition:(GVRBoardPosition *)position;

- (GVRBoardDirection)directionToPosition:(GVRBoardPosition *)position;

@end
