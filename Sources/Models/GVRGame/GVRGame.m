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

@interface GVRGame()
@property (nonatomic, strong)   GVRBoard        *board;
@property (nonatomic, strong)   NSString        *players;
@property (nonatomic, assign)   NSUInteger      activePlayer;

@end

@implementation GVRGame

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.board = [GVRBoard board];
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)begin:(void(^)(BOOL success))block {
    
}

- (void)end:(void(^)(BOOL success))block {
    
}

- (void)moveChekerForPlayer:(NSString *)palyer
                       from:(GVRBoardPosition *)fromPosition
                         to:(GVRBoardPosition *)toPosition
      withCompletionHandler:(void(^)(BOOL success))block
{
    
}

@end
