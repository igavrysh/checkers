//
//  GVRManTrajectorySpec.m
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

SPEC_BEGIN(GVRManTrajectorySpec)

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
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            
            __block BOOL checkerMoved = YES;
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    
    context(@"when white man moves 1 cell backwards to the right", ^{
        it(@"should return false and checker should stay on initial position", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 4;
            initialCell.column = 4;
            finalCell.row = 3;
            finalCell.column = 3;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            
            __block BOOL checkerMoved = YES;
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when black man moves 1 cell ahead-right", ^{
        it(@"should successfully move checker", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 9;
            initialCell.column = 1;
            finalCell.row = 8;
            finalCell.column = 0;
            
            __block BOOL checkerMoved = NO;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:initialCell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerBlackCheckers
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
    
    context(@"when black man moves 1 cell ahead-left", ^{
        it(@"should successfully move checker", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 9;
            initialCell.column = 1;
            finalCell.row = 8;
            finalCell.column = 2;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:initialCell];
            
            __block BOOL checkerMoved = NO;
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerBlackCheckers
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
    
    context(@"when black man moves 1 cell backwards to the left", ^{
        it(@"should return false and checker should stay on initial position", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 8;
            initialCell.column = 2;
            finalCell.row = 9;
            finalCell.column = 1;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:initialCell];
            
            __block BOOL checkerMoved = YES;
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerBlackCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when black man moves 1 cell backwards to the right", ^{
        it(@"should return false and checker should stay on initial position", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 8;
            initialCell.column = 0;
            finalCell.row = 9;
            finalCell.column = 1;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:initialCell];
            
            __block BOOL checkerMoved = YES;
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerBlackCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when black player moves white man 1 cell ahead", ^{
        it(@"should set success flag to false", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 0;
            initialCell.column = 0;
            finalCell.row = 1;
            finalCell.column = 1;
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerBlackCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when white player moves black man 1 cell ahead", ^{
        it(@"should set success flag to false", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 1;
            initialCell.column = 1;
            finalCell.row = 0;
            finalCell.column = 0;
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:initialCell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when white player moves white man 2 cell ahead", ^{
        it(@"should set success flag to false", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 0;
            initialCell.column = 0;
            finalCell.row = 2;
            finalCell.column = 2;
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when white player moves white man 3 cell ahead", ^{
        it(@"should set success flag to false", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 0;
            initialCell.column = 0;
            finalCell.row = 3;
            finalCell.column = 3;
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when men moves on the cell with other checker", ^{
        it(@"should set success flag to false", ^{
            GVRBoardCell initialCell, finalCell;
            initialCell.row = 0;
            initialCell.column = 0;
            finalCell.row = 1;
            finalCell.column = 1;
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:finalCell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when white man kills black man and occupies next cell, without any checker nearby", ^{
        it(@"should set success flag to true", ^{
            GVRBoardCell initialCell, opponentCell, finalCell;
            initialCell.row = 0;
            initialCell.column = 0;
            opponentCell.row = 1;
            opponentCell.column = 1;
            finalCell.row = 2;
            finalCell.column = 2;
            
            __block BOOL checkerMoved = NO;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:opponentCell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:opponentCell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                 
                 [[theValue([board positionForCell:finalCell].checker.color) should]
                  equal:theValue(GVRCheckerColorWhite)];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:opponentCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when checker jumps twice, by 1 cell each turn", ^{
        it(@"should set success flag to false", ^{
            GVRBoardCell initialCell, interimCell, finalCell;
            initialCell.row = 0;
            initialCell.column = 0;
            interimCell.row = 1;
            interimCell.column = 1;
            finalCell.row = 2;
            finalCell.column = 2;
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&interimCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:interimCell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when white man kills black man, occupies next cell, then jumps once cell forward", ^{
        it(@"should set success flag to false", ^{
            GVRBoardCell initialCell, opponentCell, interimCell, finalCell;
            initialCell.row = 0;
            initialCell.column = 0;
            opponentCell.row = 1;
            opponentCell.column = 1;
            interimCell.row = 2;
            interimCell.column = 2;
            finalCell.row = 3;
            finalCell.column = 3;
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:opponentCell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&interimCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:opponentCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:interimCell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:opponentCell];
                 [board removeCheckerAtCell:interimCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when white man kills black man and doesn't kill next black man, located nearby", ^{
        it(@"should set success flag to false", ^{
            GVRBoardCell initialCell, opponent1Cell, opponent2Cell, interimCell;
            initialCell.row = 0;
            initialCell.column = 0;
            opponent1Cell.row = 1;
            opponent1Cell.column = 1;
            interimCell.row = 2;
            interimCell.column = 2;
            opponent2Cell.row = 3;
            opponent2Cell.column = 1;
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:opponent1Cell];
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:opponent2Cell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&interimCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:opponent1Cell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:opponent2Cell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:interimCell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:opponent1Cell];
                 [board removeCheckerAtCell:opponent2Cell];
                 [board removeCheckerAtCell:interimCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when white man kills black man and kills next black man, with no other options left", ^{
        it(@"should set success flag to true", ^{
            GVRBoardCell initialCell, opponent1Cell, opponent2Cell, interimCell, finalCell;
            initialCell.row = 0;
            initialCell.column = 0;
            opponent1Cell.row = 1;
            opponent1Cell.column = 1;
            interimCell.row = 2;
            interimCell.column = 2;
            opponent2Cell.row = 3;
            opponent2Cell.column = 1;
            finalCell.row = 4;
            finalCell.column = 0;
            
            __block BOOL checkerMoved = NO;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:opponent1Cell];
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:opponent2Cell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&interimCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&finalCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:opponent1Cell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:opponent2Cell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:interimCell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:opponent1Cell];
                 [board removeCheckerAtCell:opponent2Cell];
                 [board removeCheckerAtCell:interimCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when black man kills 4 white men located in cycle", ^{
        it(@"should set success flag to true", ^{
            GVRBoardCell initialCell, interim1Cell, interim2Cell, interim3Cell;
            GVRBoardCell opponent1Cell, opponent2Cell, opponent3Cell, opponent4Cell;
            initialCell.row = 2;
            initialCell.column = 0;
            
            opponent1Cell.row = 3;
            opponent1Cell.column = 1;
            opponent2Cell.row = 3;
            opponent2Cell.column = 3;
            opponent3Cell.row = 1;
            opponent3Cell.column = 3;
            opponent4Cell.row = 1;
            opponent4Cell.column = 1;
            
            interim1Cell.row = 4;
            interim1Cell.column = 2;
            interim2Cell.row = 2;
            interim2Cell.column = 4;
            interim3Cell.row = 0;
            interim3Cell.column = 2;
            
            __block BOOL checkerMoved = NO;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:initialCell];
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:opponent1Cell];
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:opponent2Cell];
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:opponent3Cell];
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:opponent4Cell];
            
            [game moveChekerBySteps:@[[NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&interim1Cell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&interim2Cell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&interim3Cell objCType:@encode(GVRBoardCell)],
                                      [NSValue valueWithBytes:&initialCell objCType:@encode(GVRBoardCell)]]
                          forPlayer:GVRPlayerBlackCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 
                 [[theValue([[board positionForCell:opponent1Cell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:opponent2Cell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:opponent3Cell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:opponent4Cell] isFilled]) should] beNo];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:opponent1Cell];
                 [board removeCheckerAtCell:opponent2Cell];
                 [board removeCheckerAtCell:opponent3Cell];
                 [board removeCheckerAtCell:opponent4Cell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
});

SPEC_END
