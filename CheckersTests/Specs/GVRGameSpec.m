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
        
        [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                    atRow:0
                   column:4];
        
        [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                    atRow:4
                   column:4];
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
    
    context(@"when white man moves 1 cell ahead-right", ^{
        it(@"should successfully move checker", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 0;
            initialCell.column = 0;
            finalCell.row = 1;
            finalCell.column = 1;
            
            __block BOOL checkerMoved = NO;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
            {
                checkerMoved = success;
                
                [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                
                [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                
                [board removeCheckerAtCell:initialCell];
                [board removeCheckerAtCell:finalCell];
            }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when white man moves 1 cell ahead-left", ^{
        it(@"should successfully move checker", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 0;
            initialCell.column = 4;
            finalCell.row = 1;
            finalCell.column = 3;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            
            __block BOOL checkerMoved = NO;
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when white man moves 1 cell backwards to the left", ^{
        it(@"should return false and checker should stay on initial position", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 4;
            initialCell.column = 4;
            finalCell.row = 3;
            finalCell.column = 3;
            
            __block BOOL checkerMoved = YES;
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    
    it(@"when white man moves 1 cell backwards to the right, should return false", ^{});
    
    
    
    it(@"when black man moves 1 cell ahead-left, should return true", ^{});
    
    it(@"when black man moves 1 cell ahead-right, should return true", ^{});
    
    it(@"when black man moves 1 cell backwards to the right, should return false", ^{});
    
    it(@"when black man moves 1 cell backwards to the left, should return false", ^{});
    
    it(@"when black player moves white man should call block with false", ^{});
    
    it(@"when white player moves black man should call block with false", ^{});
    
    it(@"when player 1 should move the man, instead, player 2 moves, should call block with false", ^{});
    
    it(@"when player 2 should move the man, instead player 1 moves, should call block with false", ^{});
    
    it(@"when man moves 2 cells ahead, should call block with false", ^{});
    
    it(@"when man moves 3 cells ahead, should call block with false", ^{});
    
    it(@"when man jumps on the cell with other checker, should return false", ^{});
    
    it(@"when white man kills black man and occupies next cell, without any checker nearby, should return true", ^{});
    
    it(@"when white man kills black man and doesn't kill next black man, located nearby, should return false", ^{});
    
    it(@"when white man kills black man and kills next black man, with no other options left, should return true", ^{});
    
    it(@"when man riches opposite side, it should switch its state to king", ^{});
    
    it(@"when king moves 1 cell ahead to the left, should return true", ^{});
    
    it(@"when king moves 1 cell ahead to the right, should return true", ^{});
    
    it(@"when king moves 1 cell backwards to the left, should return true", ^{});
    
    it(@"when king moves 1 cell backwards to the right, should return true", ^{});
    
    it(@"when king kills 2 men separated by at least one cell, should return true", ^{});
    
    it(@"when king jumps over 2 men which are not separated by at least one cell, should return false", ^{});
    
    it(@"when white king jumps over at least one white men in his move, should return false", ^{});
    
    it(@"when no black men or black kings are left on the board - player 1 wins", ^{});
    
    it(@"when no white men or white kings are left on the board - player 2 wins", ^{});
    
    it(@"when only 1 white and 1 black king is left on the board, the game should end, draw", ^{});
    
    it(@"when only 1 white/black and 2 black/white kings are left on the board, the game should end - draw", ^{});
    
    
    
});


SPEC_END
