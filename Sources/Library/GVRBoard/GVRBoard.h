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
@property (nonatomic, readonly) NSUInteger  whiteCheckersCount;
@property (nonatomic, readonly) NSUInteger  blackCheckersCount;

+ (instancetype)board;

- (GVRChecker *)checkerAtPostion:(GVRBoardPosition *)position;

- (void)addChecker:(GVRChecker *)checker
        atPosition:(GVRBoardPosition *)position;

- (void)removeCheckerAtPosition:(GVRBoardPosition *)position;

- (void)moveCheckerFrom:(GVRBoardPosition *)fromPostion
                     to:(GVRBoardPosition *)toPosition;

@end
