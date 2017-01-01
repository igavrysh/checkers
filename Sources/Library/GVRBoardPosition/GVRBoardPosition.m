//
//  GVRBoardPosition.m
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import "GVRBoardPosition.h"

#import "GVRBoard.h"

@interface GVRBoardPosition ()
@property (nonatomic, assign)   NSUInteger              row;
@property (nonatomic, assign)   NSUInteger              column;
@property (nonatomic, weak)     GVRBoard                *board;

@end

@implementation GVRBoardPosition

@dynamic color;
@dynamic isFilled;

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithRow:(NSUInteger)row
                     column:(NSUInteger)column
                      board:(GVRBoard *)board
{
    self = [super init];
    if (self) {
        self.board = board;
        self.row = row;
        self.column = column;
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (GVRBoardPositionColor)color {
    return (self.row + self.column) % 2 == 0 ? GVRBoardPositionColorBlack : GVRBoardPositionColorWhite;
}

- (BOOL)isFilled {
    return self.checker;
}

@end
