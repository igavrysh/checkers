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
    GVRTrajectoryStepOnFilledCell,
    GVRTrajectoryStepOutOfBoard,
    GVRTrajectoryBackwardsMove,
    GVRTrajectoryLongJump,
    GVRTrajectoryJumpOverFriendlyChecker,
    GVRTrajectoryMissRequiredJump
};

@interface GVRTrajectory : NSObject
@property (nonatomic, readonly) NSArray     *steps;

+ (instancetype)trajectoryWithSteps:(NSArray *)steps;

- (instancetype)initWithSteps:(NSArray *)steps;

- (BOOL)applyForBoard:(GVRBoard *)board player:(GVRPlayer)player error:(NSError **)error;

@end
