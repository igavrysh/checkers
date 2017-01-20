//
//  GVRTrajectory.h
//  Checkers
//
//  Created by Ievgen on 1/3/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVRGame.h"
#import "GVRBoardPosition.h"

@class GVRBoard;

FOUNDATION_EXPORT NSString *const GVRTrajectoryErrorDomain;
enum {
    GVRTrajectoryStepOnWhiteCell                = 1000,
    GVRTrajectoryNoActiveCheckerInStepsSequence = 1001,
    GVRTrajectoryPlayerMovesOpponentsChecker    = 1002,
    GVRTrajectoryMoreThanOneOneCellMove         = 1003,
    GVRTrajectoryTypeInconsistencyManAndKing    = 1004,
    GVRTrajectoryStepOnFilledCell               = 1005,
    GVRTrajectoryStepOutOfBoard                 = 1006,
    GVRTrajectoryNonDiagonalMove                = 1007,
    GVRTrajectoryBackwardsMove                  = 1008,
    GVRTrajectoryLongJump                       = 1009,
    GVRTrajectoryJumpOverFriendlyChecker        = 1010,
    GVRTrajectoryMissRequiredJump               = 1011,
    GVRTrajectoryIncorrectFormat                = 1012,
    GVRTrajectoryNoStepsInTrajectory            = 1013
};

@interface GVRTrajectory : NSObject
@property (nonatomic, readonly)         NSArray     *steps;

+ (instancetype)trajectoryWithSteps:(NSArray *)steps board:(GVRBoard *)board;

+ (instancetype)manTrajectoryWithSteps:(NSArray *)steps;

+ (instancetype)kingTrajectoryWithSteps:(NSArray *)steps;

- (instancetype)initWithSteps:(NSArray *)steps board:(GVRBoard *)board;

- (BOOL)isAllowedDistanceToVictim:(NSInteger)distance;

- (BOOL)isAllowedDistanceToVictimFromCell:(GVRBoardCell)fromCell
                                   toCell:(GVRBoardCell)toCell;

- (BOOL)isAllowedSingleJumpDistance:(NSInteger)distance;

- (BOOL)isAllowedSingleJumpDistanceFromCell:(GVRBoardCell)fromCell
                                     toCell:(GVRBoardCell)toCell;

- (BOOL)applyForBoard:(GVRBoard *)board
               player:(GVRPlayer)player
                error:(NSError **)error;

@end
