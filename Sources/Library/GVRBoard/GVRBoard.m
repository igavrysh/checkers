//
//  GVRBoard.m
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import "GVRBoard.h"

#import "GVRBoardPosition.h"
#import "GVRChecker.h"

static const NSUInteger GVRBoardSize = 10;
static const NSUInteger GVRInitialCheckersFilledRowsCount = 3;

@interface GVRBoard ()
@property (nonatomic, strong)   NSArray     *positions;
@property (nonatomic, readonly) NSUInteger  size;
@property (nonatomic, assign)   NSUInteger  whiteCheckersCount;
@property (nonatomic, assign)   NSUInteger  blackCheckersCount;

- (void)initBoard;

@end

@implementation GVRBoard

@dynamic size;

#pragma mark -
#pragma mark Class Methods 

+ (instancetype)board {
    return [self new];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    if (self = [super init]) {
        [self initBoard];
    }

    return self;
}

- (void)initBoard {
    NSMutableArray *positions = [NSMutableArray new];
    
    GVRChecker *whiteChecker = [GVRChecker checkerWithType:GVRCheckerTypeMan
                                                     color:GVRCheckerColorWhite];
    GVRChecker *blackChecker = [GVRChecker checkerWithType:GVRCheckerTypeMan
                                                     color:GVRCheckerColorWhite];
    for (int i = 0; i < GVRBoardSize; i++) {
        for (int j = 0; j < GVRBoardSize; j++) {
            GVRBoardPositionColor positionColor = (i + j) % 2 == 0 ? GVRBoardPositionColorWhite : GVRBoardPositionColorBlack;
            
            GVRChecker *checker = nil;
            if (GVRBoardPositionColorBlack == positionColor) {
                if (i < GVRInitialCheckersFilledRowsCount) {
                    checker = [whiteChecker copy];
                    self.whiteCheckersCount++;
                }
                if (j >= GVRBoardSize - GVRInitialCheckersFilledRowsCount) {
                    checker = [blackChecker copy];
                    self.blackCheckersCount++;
                }
            }
            
            GVRBoardPosition *position = [[GVRBoardPosition alloc] initWithColor:positionColor
                                                                       rowNumber:i
                                                                    columnNumber:j
                                                                         checker:checker];
            [positions addObject:position];
        }
    }
    
    self.positions = [positions copy];
}

#pragma mark -
#pragma mark Accessors 

- (NSUInteger)size {
    return [self.positions count];
}

#pragma mark -
#pragma mark Public Methods

- (GVRChecker *)checkerAtPostion:(GVRBoardPosition *)position {
    return self.positions[position.rowNumber * self.size + position.columnNumber];
}

- (void)addChecker:(GVRChecker *)checker
        atPosition:(GVRBoardPosition *)position
{
    
}

- (GVRChecker *)removeCheckerAtPosition:(GVRBoardPosition *)position
{
    return nil;
}

- (void)moveCheckerFrom:(GVRBoardPosition *)fromPostion
                     to:(GVRBoardPosition *)toPosition
{
    
}



@end
