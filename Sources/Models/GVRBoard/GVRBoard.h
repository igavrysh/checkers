//
//  GVRBoard.h
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVRBoardPosition.h"

@class GVRChecker;
@class GVRBoardPosition;

static const NSUInteger GVRBoardSize = 10;

static const NSUInteger GVRInitialCheckersFilledRowsCount = 6;

@interface GVRBoard : NSObject
@property (nonatomic, readonly) NSUInteger  size;
@property (nonatomic, readonly) NSUInteger  whiteCheckersCount;
@property (nonatomic, readonly) NSUInteger  blackCheckersCount;

+ (instancetype)board;

- (instancetype)initWithSize:(NSUInteger)size;

- (GVRBoardPosition *)positionForRow:(NSUInteger)row column:(NSUInteger)column;
- (GVRBoardPosition *)positionForCell:(GVRBoardCell)cell;

- (void)addChecker:(GVRChecker *)checker atRow:(NSUInteger)row column:(NSUInteger)column;
- (void)addChecker:(GVRChecker *)checker atCell:(GVRBoardCell)cell;

- (void)removeCheckerAtRow:(NSUInteger)row column:(NSUInteger)column;
- (void)removeCheckerAtCell:(GVRBoardCell)cell;

- (void)moveCheckerFromCell:(GVRBoardCell)fromCell toCell:(GVRBoardCell)toCell;
- (void)moveCheckerFromRow:(NSUInteger)fromRow
                    column:(NSUInteger)fromColumn
                     toRow:(NSUInteger)toRow
                    column:(NSUInteger)toColumn;
- (void)moveCheckerFrom:(GVRBoardPosition *)fromPostion
                     to:(GVRBoardPosition *)toPosition;

- (NSUInteger)indexForRow:(NSUInteger)row column:(NSUInteger)column;
- (NSUInteger)indexForCell:(GVRBoardCell)cell;

- (BOOL)isCheckerPresentAtRow:(NSUInteger)row column:(NSUInteger)column;
- (BOOL)isCheckerPresentAtCell:(GVRBoardCell)cell;

- (void)resetMarkedForRemovalCheckers;

@end
