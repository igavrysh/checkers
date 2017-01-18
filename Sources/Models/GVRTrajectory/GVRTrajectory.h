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
    GVRTrajectoryStepOnWhiteCell = 1000,
    GVRTrajectoryNoActiveCheckerInStepsSequence,
    GVRTrajectoryPlayerMovesOpponentsChecker,
    GVRTrajectoryMoreThanOneOneCellMove,
    GVRTrajectoryTypeInconsistencyManAndKing,
    GVRTrajectoryStepOnFilledCell,
    GVRTrajectoryStepOutOfBoard,
    GVRTrajectoryNonDiagonalMove,
    GVRTrajectoryBackwardsMove,
    GVRTrajectoryLongJump,
    GVRTrajectoryJumpOverFriendlyChecker,
    GVRTrajectoryMissRequiredJump,
    GVRTrajectoryIncorrectFormat,
    GVRTrajectoryNoStepsInTrajectory
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
