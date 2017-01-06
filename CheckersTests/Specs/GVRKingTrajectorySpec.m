//
//  GVRKingTrajectorySpec.m
//  Checkers
//
//  Created by Ievgen on 1/6/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Kiwi.h"

#import "GVRGame.h"
#import "GVRBoard.h"
#import "GVRChecker.h"
#import "GVRBoardPosition.h"

SPEC_BEGIN(GVRKingTrajectorySpec)

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
    
    context(@"when man riches board's opposite side", ^{
        it(@"should change its type from man to king", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 8;
            initialCell.column = 4;
            finalCell.row = 9;
            finalCell.column = 5;
            
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
                 
                 [[theValue([board positionForCell:finalCell].checker.type) should]
                     equal:theValue(GVRCheckerTypeKing)];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
});

/*
 
 it(@", it should switch its state to king", ^{});
 
 it(@"when king moves 1 cell ahead to the left, should return true", ^{});
 
 it(@"when king moves 1 cell ahead to the right, should return true", ^{});
 
 it(@"when king moves 1 cell backwards to the left, should return true", ^{});
 
 it(@"when king moves 1 cell backwards to the right, should return true", ^{});
 
 it(@"when king kills 2 men separated by at least one cell, should return true", ^{});
 
 it(@"when king jumps over 2 men which are not separated by at least one cell, should return false", ^{});
 
 it(@"when white king jumps over at least one white men in his move, should return false", ^{});
 */

SPEC_END