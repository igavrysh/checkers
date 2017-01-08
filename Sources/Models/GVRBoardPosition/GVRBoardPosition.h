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

extern BOOL GVRIsDiagonalDistance(GVRBoardCell cell1, GVRBoardCell cell2);

@interface GVRBoardPosition : NSObject
@property (nonatomic, readonly)         NSUInteger              row;
@property (nonatomic, readonly)         NSUInteger              column;
@property (nonatomic, strong)           GVRChecker              *checker;
@property (nonatomic, weak, readonly)   GVRBoard                *board;
@property (nonatomic, readonly)         GVRBoardPositionColor   color;
@property (nonatomic, readonly, getter=isFilled)    BOOL        isFilled;

- (instancetype)initWithRow:(NSUInteger)row
                     column:(NSUInteger)column
                      board:(GVRBoard *)board;

- (BOOL)isEqualToPosition:(GVRBoardPosition *)position;

- (instancetype)positionShiftedByDeltaRows:(NSInteger)deltaRows deltaColumns:(NSInteger)deltaColumns;

- (instancetype)positionShiftedByDirection:(GVRBoardDirection)direction distance:(NSInteger)distance;

- (NSInteger)rowDeltaToPosition:(GVRBoardPosition *)position;

- (NSInteger)columnDeltaToPosition:(GVRBoardPosition *)position;

- (NSInteger)rowDirectionToPosition:(GVRBoardPosition *)position;

- (NSInteger)columnDirectionToPosition:(GVRBoardPosition *)position;

- (GVRBoardDirection)directionToPosition:(GVRBoardPosition *)position;

@end
