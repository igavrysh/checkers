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

#import "NSArray+GVRExtensions.h"

static const NSUInteger GVRBoardSize = 10;
static const NSUInteger GVRInitialCheckersFilledRowsCount = 6;

@interface GVRBoard ()
@property (nonatomic, strong)   NSMutableArray  *positions;
@property (nonatomic, assign)   NSUInteger      size;
@property (nonatomic, assign)   NSUInteger      whiteCheckersCount;
@property (nonatomic, assign)   NSUInteger      blackCheckersCount;

- (void)setChecker:(GVRChecker *)checker atRow:(NSUInteger)row column:(NSUInteger)column;

- (void)addCheckersWithinRowsNumber:(NSUInteger)checkerRows;

@end

@implementation GVRBoard

#pragma mark -
#pragma mark Class Methods 

+ (instancetype)board {
    return [self new];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    if (self = [self initWithSize:GVRBoardSize]) {
        [self addCheckersWithinRowsNumber:GVRInitialCheckersFilledRowsCount];
    }

    return self;
}

- (instancetype)initWithSize:(NSUInteger)size {
    if (!(self = [super init])) {
        return nil;
    }
    
    self.size = size;
    
    self.positions = [[NSMutableArray alloc] initWithCapacity:size*size];
    
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            GVRBoardPosition *position = [[GVRBoardPosition alloc] initWithRow:i column:j board:self];
            NSUInteger index = [self indexForRow:i column:j];
            self.positions[index] = position;
        }
    }
    
    return self;
}

- (GVRBoardPosition *)positionForRow:(NSUInteger)row column:(NSUInteger)column {
    NSUInteger size = self.size;
    if (row >= size || column >= size) {
        return  nil;
    }
    
    return self.positions[[self indexForRow:row column:column]];
}

- (void)addCheckersWithinRowsNumber:(NSUInteger)checkerRows {
    if (!self.positions) {
        return;
    }
    
    GVRChecker *whiteChecker = [GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite];
    GVRChecker *blackChecker = [GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack];
    NSUInteger rows = checkerRows / 2;
    NSUInteger size = self.size;
    
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            GVRChecker *checker = nil;
            
            GVRBoardPosition *position = self[[self indexForRow:i column:j]];
            
            if (GVRBoardPositionColorBlack == position.color) {
                if (i < rows) {
                    checker = [whiteChecker copy];
                }
                
                if (i >= size - rows) {
                    checker = [blackChecker copy];
                }
                
                [self addChecker:checker atRow:i column:j];
            }
        }
    }
}

#pragma mark -
#pragma mark Public Methods

- (NSUInteger)indexForRow:(NSUInteger)row column:(NSUInteger)column {
    return self.size * row + column;
}

- (BOOL)isCheckerPresentAtRow:(NSUInteger)row column:(NSUInteger)column {
    return self[[self indexForRow:row column:column]].isFilled;
}

- (GVRBoardPosition *)objectAtIndexedSubscript:(NSUInteger)index {
    return self.positions[index];
}

- (void)setObject:(GVRChecker *)object atIndexedSubscript:(NSUInteger)index {
    self.positions[index] = object;
}

- (GVRChecker *)checkerAtRow:(NSUInteger)row column:(NSUInteger)column {
    return self[row * self.size + column].checker;
}

- (void)addChecker:(GVRChecker *)checker atRow:(NSUInteger)row column:(NSUInteger)column {
    if (!checker || [self isCheckerPresentAtRow:row column:column]) {
        return;
    }
    
    [self setChecker:checker atRow:row column:column];
        
    if (GVRCheckerColorBlack == checker.color) {
        self.blackCheckersCount++;
    } else if (GVRCheckerColorWhite == checker.color) {
        self.whiteCheckersCount++;
    }
}

- (void)removeCheckerAtRow:(NSUInteger)row column:(NSUInteger)column {
    if (![self isCheckerPresentAtRow:row column:column]) {
        return;
    }
    
    GVRChecker *checker = self[[self indexForRow:row column:column]].checker;
    GVRCheckerColor color = checker.color;
    if (GVRCheckerColorBlack == color) {
        self.blackCheckersCount--;
    } else if (GVRCheckerColorWhite == color) {
        self.whiteCheckersCount--;
    }
    
    [self setChecker:nil atRow:row column:column];
}

- (void)moveCheckerFrom:(GVRBoardPosition *)fromPostion to:(GVRBoardPosition *)toPosition {
}

#pragma mark -
#pragma mark Private Methods

- (void)setChecker:(GVRChecker *)checker atRow:(NSUInteger)row column:(NSUInteger)column {
    NSUInteger index = [self indexForRow:row column:column];
    self[index].checker = checker;
}

@end
