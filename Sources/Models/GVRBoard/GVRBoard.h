//
//  GVRBoard.h
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GVRChecker;
@class GVRBoardPosition;

@interface GVRBoard : NSObject
@property (nonatomic, readonly) NSUInteger  size;
@property (nonatomic, readonly) NSUInteger  whiteCheckersCount;
@property (nonatomic, readonly) NSUInteger  blackCheckersCount;

+ (instancetype)board;

- (instancetype)initWithSize:(NSUInteger)size;

- (void)addChecker:(GVRChecker *)checker atRow:(NSUInteger)row column:(NSUInteger)column;

- (void)removeCheckerAtRow:(NSUInteger)row column:(NSUInteger)column;

- (void)moveCheckerFrom:(GVRBoardPosition *)fromPostion
                     to:(GVRBoardPosition *)toPosition;

- (NSUInteger)indexForRow:(NSUInteger)row column:(NSUInteger)column;

- (BOOL)isCheckerPresentAtRow:(NSUInteger)row column:(NSUInteger)column;

@end
