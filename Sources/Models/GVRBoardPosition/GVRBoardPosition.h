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
    NSUInteger row;
    NSUInteger column;
};

typedef struct GVRBoardCell GVRBoardCell;

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

@end
