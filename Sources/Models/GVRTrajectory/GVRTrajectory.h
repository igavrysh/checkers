//
//  GVRTrajectory.h
//  Checkers
//
//  Created by Ievgen on 1/3/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVRGame.h"

@class GVRBoard;

FOUNDATION_EXPORT NSString *const GVRTrajectoryErrorDomain;
enum {
    GVRTrajectoryStepOnWhiteCell = 1000,
    GVRTrajectoryTypeInconsistencyManAndKing,
    GVRTrajectoryStepOnFilledCell,
    GVRTrajectoryStepOutOfBoard,
    GVRTrajectoryBackwardsMove,
    GVRTrajectoryLongJump,
    GVRTrajectoryJumpOverFriendlyChecker,
    GVRTrajectoryMissRequiredJump
};

@interface GVRTrajectory : NSObject
@property (nonatomic, readonly)         NSArray     *steps;
@property (nonatomic, weak, readonly)   GVRBoard    *board;

+ (instancetype)manTrajectoryWithSteps:(NSArray *)steps board:(GVRBoard *)board;

+ (instancetype)kingTrajectoryWithSteps:(NSArray *)steps board:(GVRBoard *)board;

- (instancetype)initWithSteps:(NSArray *)steps board:(GVRBoard *)board;

- (BOOL)applyForPlayer:(GVRPlayer)player error:(NSError **)error;

@end
