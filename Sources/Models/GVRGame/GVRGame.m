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

#import "GVRBlockMacros.h"

@interface GVRGame()
@property (nonatomic, strong)   GVRBoard        *board;
@property (nonatomic, strong)   NSArray         *players;
@property (nonatomic, assign)   GVRPlayer      activePlayer;

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
    self.board = [GVRBoard board];
    self.activePlayer = 0;
    self.players = @[@"id1", @"id2"];
    
    GVRBlockPerform(block, TRUE);
}

- (void)end:(void(^)(BOOL success))block {
    
    GVRBlockPerform(block, TRUE);
}

- (void)moveChekerBySteps:(NSArray *)steps
                forPlayer:(GVRPlayer)player
    withCompletionHandler:(void(^)(BOOL success))block
{
    
}

@end
