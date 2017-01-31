//
//  GVRGameView.m
//  Checkers
//
//  Created by Ievgen on 1/12/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRGameView.h"

@implementation GVRGameView

#pragma mark -
#pragma mark Accessors

- (void)setActivePlayer:(GVRPlayer)activePlayer {
    if (_activePlayer != activePlayer) {
        _activePlayer = activePlayer;
        
        self.boardView.activePlayer = activePlayer;
    }
}

@end
