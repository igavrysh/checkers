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

#import "NSValue+GVRExtensions.h"

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
    
    context(@"when checker with a man type riches board's opposite side", ^{
        it(@"should switch its type from man to king", ^{
            GVRBoardCell initialCell = GVRBoardCellMake(8, 4);
            GVRBoardCell finalCell= GVRBoardCellMake(9, 5);
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
                 [[theValue([board positionForCell:finalCell].checker.type) should] equal:theValue(GVRCheckerTypeKing)];
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when king moves 1 cell ahead to the left", ^{
        it(@"should set success variable to true", ^{
            GVRBoardCell initialCell = GVRBoardCellMake(2, 4);
            GVRBoardCell finalCell = GVRBoardCellMake(3, 3);
            [board addChecker:[GVRChecker whiteKing] atCell:initialCell];
            
            __block BOOL checkerMoved = NO;
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                 [[theValue([board positionForCell:finalCell].checker.type) should] equal:theValue(GVRCheckerTypeKing)];
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when king moves 1 cell ahead to the right", ^{
        it(@"should set success variable to true", ^{
            GVRBoardCell initialCell = GVRBoardCellMake(2, 4);
            GVRBoardCell finalCell = GVRBoardCellMake(3, 5);
            [board addChecker:[GVRChecker whiteKing] atCell:initialCell];
            
            __block BOOL checkerMoved = NO;
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                 [[theValue([board positionForCell:finalCell].checker.type) should] equal:theValue(GVRCheckerTypeKing)];
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when king moves 1 cell backwards to the right", ^{
        it(@"should set success variable to true", ^{
            GVRBoardCell initialCell = GVRBoardCellMake(2, 4);
            GVRBoardCell finalCell = GVRBoardCellMake(1, 5);
            [board addChecker:[GVRChecker whiteKing] atCell:initialCell];
            
            __block BOOL checkerMoved = NO;
            [game moveChekerBySteps:@[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                 [[theValue([board positionForCell:finalCell].checker.type) should] equal:theValue(GVRCheckerTypeKing)];
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when king moves 1 cell backwards to the left", ^{
        it(@"should set success variable to true", ^{
            GVRBoardCell initialCell = GVRBoardCellMake(2, 4);
            GVRBoardCell finalCell = GVRBoardCellMake(1, 3);
            [board addChecker:[GVRChecker whiteKing] atCell:initialCell];
    
            __block BOOL checkerMoved = NO;
            [game moveChekerBySteps:@[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                 [[theValue([board positionForCell:finalCell].checker.type) should] equal:theValue(GVRCheckerTypeKing)];
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when king kills 2 men separated by one cell", ^{
        it(@"should set success variable to true", ^{
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell opponent1Cell = GVRBoardCellMake(1, 1);
            GVRBoardCell intrimCell = GVRBoardCellMake(2, 2);
            GVRBoardCell opponent2Cell = GVRBoardCellMake(3, 3);
            GVRBoardCell finalCell = GVRBoardCellMake(4, 4);
            [board addChecker:[GVRChecker whiteKing] atCell:initialCell];
            [board addChecker:[GVRChecker blackKing] atCell:opponent1Cell];
            [board addChecker:[GVRChecker blackMan] atCell:opponent2Cell];
            
            __block BOOL checkerMoved = NO;
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:intrimCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:opponent1Cell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:intrimCell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:opponent2Cell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                 [[theValue([board positionForCell:finalCell].checker.type) should] equal:theValue(GVRCheckerTypeKing)];
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:opponent1Cell];
                 [board removeCheckerAtCell:opponent2Cell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when king kills 2 men separated by two cells", ^{
        it(@"should set success variable to true", ^{
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell opponent1Cell = GVRBoardCellMake(2, 2);
            GVRBoardCell intrimCell = GVRBoardCellMake(4, 4);
            GVRBoardCell opponent2Cell = GVRBoardCellMake(6, 6);
            GVRBoardCell finalCell = GVRBoardCellMake(8, 8);
            
            [board addChecker:[GVRChecker whiteKing] atCell:initialCell];
            [board addChecker:[GVRChecker blackKing] atCell:opponent1Cell];
            [board addChecker:[GVRChecker blackMan] atCell:opponent2Cell];
            
            __block BOOL checkerMoved = NO;
            NSArray *path = @[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:intrimCell], [NSValue valueWithCell:finalCell]];
            [game moveChekerBySteps:path
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:opponent1Cell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:intrimCell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:opponent2Cell] isFilled]) should] beNo];
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beYes];
                 [[theValue([board positionForCell:finalCell].checker.type) should] equal:theValue(GVRCheckerTypeKing)];
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:opponent1Cell];
                 [board removeCheckerAtCell:opponent2Cell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beYes];
        });
    });
    
    context(@"when king jumps over 2 men which are not separated by at least one cell", ^{
        it(@"should set success variable to false", ^{
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell opponent1Cell = GVRBoardCellMake(2, 2);
            GVRBoardCell opponent2Cell = GVRBoardCellMake(3, 3);
            GVRBoardCell finalCell = GVRBoardCellMake(8, 8);
            [board addChecker:[GVRChecker whiteKing] atCell:initialCell];
            [board addChecker:[GVRChecker blackMan] atCell:opponent1Cell];
            [board addChecker:[GVRChecker blackKing] atCell:opponent2Cell];
            
            __block BOOL checkerMoved = YES;
            [game moveChekerBySteps:@[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 [[theValue([[board positionForCell:opponent1Cell] isFilled]) should] beYes];
                 [[theValue([[board positionForCell:opponent2Cell] isFilled]) should] beYes];
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 [[theValue([board positionForCell:initialCell].checker.type) should] equal:theValue(GVRCheckerTypeKing)];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:opponent1Cell];
                 [board removeCheckerAtCell:opponent2Cell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        });
    });
    
    context(@"when white king jumps over at least one white men in his move, and does not proceed with required jumps", ^{
        it(@"should set succes variable to false", ^ {
            GVRBoardCell initialCell = GVRBoardCellMake(0, 0);
            GVRBoardCell opponent1Cell = GVRBoardCellMake(2, 2);
            GVRBoardCell opponent2Cell = GVRBoardCellMake(1, 5);
            GVRBoardCell finalCell = GVRBoardCellMake(3, 3);
            [board addChecker:[GVRChecker whiteKing] atCell:initialCell];
            [board addChecker:[GVRChecker blackMan] atCell:opponent1Cell];
            [board addChecker:[GVRChecker blackKing] atCell:opponent2Cell];
            
            __block BOOL checkerMoved = YES;
            [game moveChekerBySteps:@[[NSValue valueWithCell:initialCell], [NSValue valueWithCell:finalCell]]
                          forPlayer:GVRPlayerWhiteCheckers
              withCompletionHandler:^(BOOL success)
             {
                 checkerMoved = success;
                 [[theValue([[board positionForCell:initialCell] isFilled]) should] beYes];
                 [[theValue([[board positionForCell:opponent1Cell] isFilled]) should] beYes];
                 [[theValue([[board positionForCell:opponent2Cell] isFilled]) should] beYes];
                 [[theValue([[board positionForCell:finalCell] isFilled]) should] beNo];
                 [[theValue([board positionForCell:initialCell].checker.type) should] equal:theValue(GVRCheckerTypeKing)];
                 
                 [board removeCheckerAtCell:initialCell];
                 [board removeCheckerAtCell:opponent1Cell];
                 [board removeCheckerAtCell:opponent2Cell];
                 [board removeCheckerAtCell:finalCell];
             }];
            
            [[expectFutureValue(theValue(checkerMoved)) shouldEventually] beNo];
        
        });
    });
});

SPEC_END
