//
//  GVRGameSpec.m
//  Checkers
//
//  Created by Ievgen on 1/2/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Kiwi.h"

#import "GVRGame.h"
#import "GVRBoard.h"
#import "GVRChecker.h"
#import "GVRBoardPosition.h"

SPEC_BEGIN(GVRGameSpec)

__block GVRBoard *board = nil;
__block GVRGame *game = nil;

registerMatchers(@"GVR");

context(@"when board is initialized", ^{
    beforeAll(^{
        board = [[GVRBoard alloc] initWithSize:GVRBoardSize];
        game = [GVRGame new];
    });
    
    context(@"when starting game", ^{
        it(@"should successfully start game within one second", ^{
            __block BOOL gameStarted = NO;
            
            [game beginWithBoard:board completionHandler:^(BOOL success) {
                gameStarted = YES;
            }];
            
            [[expectFutureValue(theValue(gameStarted)) shouldEventually] beYes];
        });
    });
});

/*
 it(@"when no black men or black kings are left on the board - player 1 wins", ^{});
 
 it(@"when no white men or white kings are left on the board - player 2 wins", ^{});
 
 it(@"when only 1 white and 1 black king is left on the board, the game should end, draw", ^{});
 
 it(@"when only 1 white/black and 2 black/white kings are left on the board, the game should end - draw", ^{});
*/

SPEC_END
