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
    GVRTrajectoryNoActiveCheckerInStepsSequence,
    GVRTrajectoryPlayerMovesOpponentsChecker,
    GVRTrajectoryMoreThanOneOneCellMove,
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

+ (instancetype)trajectoryWithSteps:(NSArray *)steps board:(GVRBoard *)board;

+ (instancetype)manTrajectoryWithSteps:(NSArray *)steps;

+ (instancetype)kingTrajectoryWithSteps:(NSArray *)steps;

- (instancetype)initWithSteps:(NSArray *)steps board:(GVRBoard *)board;

- (BOOL)applyForBoard:(GVRBoard *)board player:(GVRPlayer)player error:(NSError **)error;

@end
