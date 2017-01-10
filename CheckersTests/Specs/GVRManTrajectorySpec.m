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

#import "NSValue+GVRExtensions.h"

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
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell finalCell = GVRBoardCellMake(1, 1);
            
            __block BOOL checkerMoved = NO;
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(0, 4);
            GVRBoardCell finalCell = GVRBoardCellMake(1, 3);
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            
            __block BOOL checkerMoved = NO;
            
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(4, 4);
            GVRBoardCell finalCell = GVRBoardCellMake(3, 3);
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            
            __block BOOL checkerMoved = YES;
            
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(4, 4);
            GVRBoardCell finalCell = GVRBoardCellMake(3, 3);
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            
            __block BOOL checkerMoved = YES;
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(9, 1);
            GVRBoardCell finalCell = GVRBoardCellMake(8, 0);
            
            __block BOOL checkerMoved = NO;
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:initialCell];
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(9, 1);
            GVRBoardCell finalCell = GVRBoardCellMake(8, 2);
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack]
                       atCell:initialCell];
            
            __block BOOL checkerMoved = NO;
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(8, 2);
            GVRBoardCell finalCell = GVRBoardCellMake(9, 1);
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            
            __block BOOL checkerMoved = YES;
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(8, 0);
            GVRBoardCell finalCell = GVRBoardCellMake(9, 1);
            [board addChecker:[GVRChecker blackMan] atCell:initialCell];
            
            __block BOOL checkerMoved = YES;
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell finalCell = GVRBoardCellMake(1, 1);
            
            __block BOOL checkerMoved = YES;
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(1, 1);
            GVRBoardCell finalCell = GVRBoardCellMake(0, 0);
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker blackMan]
                       atCell:initialCell];
            
            NSArray *path = @[[NSValue valueWithCell:initialCell],
                              [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell finalCell = GVRBoardCellMake(2, 2);
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            
            [game moveChekerBySteps:@[[NSValue valueWithCell:initialCell],
                                      [NSValue valueWithCell:finalCell]]
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
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell finalCell = GVRBoardCellMake(3, 3);
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite]
                       atCell:initialCell];
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell finalCell = GVRBoardCellMake(1, 1);
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            [board addChecker:[GVRChecker whiteMan] atCell:finalCell];
            
            NSArray *path = @[[NSValue valueWithCell:initialCell],
                              [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell opponentCell = GVRBoardCellMake(1, 1);
            GVRBoardCell finalCell = GVRBoardCellMake(2, 2);

            __block BOOL checkerMoved = NO;
            
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            [board addChecker:[GVRChecker blackMan] atCell:opponentCell];
            
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:opponentCell] isFilled]) should] beNo];
                 
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                 
                 [[theValue([board positionForCell:finalCell].checker.color) should] equal:theValue(GVRCheckerColorWhite)];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:opponentCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when checker jumps twice, by 1 cell each turn", ^{
        it(@"should set success flag to false", ^{
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell interimCell = GVRBoardCellMake(1, 1);
            GVRBoardCell finalCell = GVRBoardCellMake(2, 2);
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            
            NSArray *path = @[[NSValue valueWithCell:initialCell],
                              [NSValue valueWithCell:interimCell],
                              [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
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
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell opponentCell = GVRBoardCellMake(1, 1);
            GVRBoardCell interimCell = GVRBoardCellMake(2, 2);
            GVRBoardCell finalCell = GVRBoardCellMake(3, 3);
            
            __block BOOL checkerMoved = YES;
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            [board addChecker:[GVRChecker blackMan] atCell:opponentCell];
            [game moveChekerBySteps:@[[NSValue valueWithCell:initialCell],
                                      [NSValue valueWithCell:interimCell],
                                      [NSValue valueWithCell:finalCell]]
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
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell opponent1Cell = GVRBoardCellMake(1, 1);
            GVRBoardCell opponent2Cell = GVRBoardCellMake(3, 1);
            GVRBoardCell interimCell = GVRBoardCellMake(2, 2);
            
            __block BOOL checkerMoved = YES;
            
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            [board addChecker:[GVRChecker blackMan] atCell:opponent1Cell];
            [board addChecker:[GVRChecker blackMan] atCell:opponent2Cell];
            
            [game moveChekerBySteps:@[[NSValue valueWithCell:initialCell],
                                      [NSValue valueWithCell:interimCell]]
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
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell opponent1Cell = GVRBoardCellMake(1, 1);
            GVRBoardCell opponent2Cell = GVRBoardCellMake(3, 1);
            GVRBoardCell interimCell = GVRBoardCellMake(2, 2);
            GVRBoardCell finalCell = GVRBoardCellMake(4, 0);
            
            __block BOOL checkerMoved = NO;
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            [board addChecker:[GVRChecker blackMan] atCell:opponent1Cell];
            [board addChecker:[GVRChecker blackMan] atCell:opponent2Cell];
            
            [game moveChekerBySteps:@[[NSValue valueWithCell:initialCell],
                                      [NSValue valueWithCell:interimCell],
                                      [NSValue valueWithCell:finalCell]]
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
    
    context(@"when white man kills 1 black man and cannot move any further since next black men are two in a row", ^{
        it(@"should kill men and set success flag to true", ^{
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell finalCell = GVRBoardCellMake(2, 2);
            GVRBoardCell opponent1Cell = GVRBoardCellMake(1, 1);
            GVRBoardCell opponent2Cell = GVRBoardCellMake(3, 1);
            GVRBoardCell opponent3Cell = GVRBoardCellMake(4, 0);
            
            __block BOOL checkerMoved = NO;
            [board addChecker:[GVRChecker whiteMan] atCell:initialCell];
            [board addChecker:[GVRChecker blackMan] atCell:opponent1Cell];
            [board addChecker:[GVRChecker blackMan] atCell:opponent2Cell];
            [board addChecker:[GVRChecker blackMan] atCell:opponent3Cell];
            [game moveChekerBySteps:@[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success) {
                  checkerMoved = success;
                  
                  [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                  
                  [[theValue([[board positionForCell:opponent1Cell] isFilled]) should] beNo];
                  
                  [[theValue([[board positionForCell:opponent2Cell] isFilled]) should] beYes];
                  
                  [[theValue([[board positionForCell:opponent3Cell] isFilled]) should] beYes];
                  
                  [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                  
                  [board removeCheckerAtCell:initialCell];
                  [board removeCheckerAtCell:opponent1Cell];
                  [board removeCheckerAtCell:opponent2Cell];
                  [board removeCheckerAtCell:opponent3Cell];
              }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when black man kills 4 white men located in cycle", ^{
        it(@"should set success flag to true", ^{
            GVRBoardCell initialCell = GVRBoardCellMake(2, 0);
            GVRBoardCell interim1Cell = GVRBoardCellMake(4, 2);
            GVRBoardCell interim2Cell = GVRBoardCellMake(2, 4);
            GVRBoardCell interim3Cell = GVRBoardCellMake(0, 2);
            GVRBoardCell opponent1Cell = GVRBoardCellMake(3, 1);
            GVRBoardCell opponent2Cell = GVRBoardCellMake(3, 3);
            GVRBoardCell opponent3Cell = GVRBoardCellMake(1, 3);
            GVRBoardCell opponent4Cell = GVRBoardCellMake(1, 1);
            
            __block BOOL checkerMoved = NO;
            [board addChecker:[GVRChecker blackMan] atCell:initialCell];
            [board addChecker:[GVRChecker whiteMan] atCell:opponent1Cell];
            [board addChecker:[GVRChecker whiteMan] atCell:opponent2Cell];
            [board addChecker:[GVRChecker whiteMan] atCell:opponent3Cell];
            [board addChecker:[GVRChecker whiteMan] atCell:opponent4Cell];
            NSArray *path = @[[NSValue valueWithCell:initialCell],
                              [NSValue valueWithCell:interim1Cell],
                              [NSValue valueWithCell:interim2Cell],
                              [NSValue valueWithCell:interim3Cell],
                              [NSValue valueWithCell:initialCell]];
            [game moveChekerBySteps:path forPlayer:GVRPlayerBlackCheckers
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
