//
//  GVRGame.m
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import "GVRGame.h"

#include "GVRBoard.h"
#import "GVRBoardPosition.h"
#import "GVRTrajectory.h"

#import "GVRBlockMacros.h"

GVRCheckerColor GVRCheckerColorForPlayer(GVRPlayer player) {
    GVRCheckerColor color = GVRCheckerColorNone;
    if (GVRPlayerWhiteCheckers == player) {
        color = GVRCheckerColorWhite;
    } else if (GVRPlayerBlackCheckers == player) {
        color = GVRCheckerColorBlack;
    }
    
    return color;
}

@interface GVRGame()
@property (nonatomic, strong)   GVRBoard        *board;
@property (nonatomic, assign)   GVRPlayer       activePlayer;

@end

@implementation GVRGame

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)begin:(void(^)(BOOL success))block {
    [self beginWithBoard:[GVRBoard board] completionHandler:block];
}

- (void)beginWithBoard:(GVRBoard *)board
     completionHandler:(void (^)(BOOL))block
{
    self.board = board;
    self.activePlayer = GVRPlayerWhiteCheckers;
    
    GVRBlockPerform(block, TRUE);
}

- (void)end:(void(^)(BOOL success))block {
    
    GVRBlockPerform(block, TRUE);
}

- (void)moveChekerBySteps:(NSArray *)steps
                forPlayer:(GVRPlayer)player
    withCompletionHandler:(void(^)(BOOL success))block
{
    GVRTrajectory *trajectory = [GVRTrajectory trajectoryWithSteps:steps board:self.board];
    
    NSError *error = nil;
    
    BOOL result = [trajectory applyForBoard:self.board player:player error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
    }
    
    if (result) {
        self.activePlayer = GVRPlayerWhiteCheckers == self.activePlayer
            ? GVRPlayerBlackCheckers : GVRPlayerWhiteCheckers;
    }
    
    GVRBlockPerform(block, result);
}

@end
