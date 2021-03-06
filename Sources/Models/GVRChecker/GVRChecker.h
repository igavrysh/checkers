//
//  GVRChecker.h
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GVRCheckerTypeNone,
    GVRCheckerTypeMan,
    GVRCheckerTypeKing
} GVRCheckerType;

typedef enum : NSUInteger {
    GVRCheckerColorNone,
    GVRCheckerColorWhite,
    GVRCheckerColorBlack
} GVRCheckerColor;

typedef struct GVRBoardCell GVRBoardCell;

@interface GVRChecker : NSObject <NSCopying>
@property (nonatomic, readonly)                             GVRCheckerType  type;
@property (nonatomic, readonly)                             GVRCheckerColor color;
@property (nonatomic, assign, getter=isMarkedForRemoval)    BOOL            markedForRemoval;

+ (instancetype)whiteKing;

+ (instancetype)blackKing;

+ (instancetype)whiteMan;

+ (instancetype)blackMan;

+ (instancetype)checkerWithType:(GVRCheckerType)type
                          color:(GVRCheckerColor)color;

- (instancetype)initWithType:(GVRCheckerType)type
                       color:(GVRCheckerColor)color;

- (void)promoteCheckerType;

- (BOOL)isAllowedDistanceToVictim:(NSInteger)distance;

- (BOOL)isAllowedDistanceToVictimFromCell:(GVRBoardCell)fromCell
                                   toCell:(GVRBoardCell)toCell;

- (BOOL)isAllowedSingleJumpDistance:(NSInteger)distance;

- (BOOL)isAllowedSingleJumpDistanceFromCell:(GVRBoardCell)fromCell
                                     toCell:(GVRBoardCell)toCell;


@end
