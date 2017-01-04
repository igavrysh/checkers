//
//  GVRBoardSpec.m
//  Checkers
//
//  Created by Ievgen on 1/1/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Kiwi.h"

#import "GVRBoard.h"
#import "GVRBoardPosition.h"

SPEC_BEGIN(GVRBoardSpec)

describe(@"GVRBoard", ^{
    __block GVRBoard *board = nil;
    
    registerMatchers(@"GVR");
    
    context(@"when board is initialized", ^{
        beforeAll(^{
            board = [GVRBoard new];
        });
        
        it(@"should have size of 10 cells", ^{
            [[theValue(board.size) should] equal:theValue(10)];
        });
        
        it(@"should have white checkers count of 3 * 5 = 15", ^{
            [[theValue(board.whiteCheckersCount) should] equal:theValue(15)];
        });
        
        it(@"should have black checkers count of 3 * 5 = 15", ^{
            [[theValue(board.blackCheckersCount) should] equal:theValue(15)];
        });
        
        it(@"should have black board position on {0; 0}", ^{
            [[theValue([[board positionForRow:0 column:0] color]) should] equal:theValue(GVRBoardPositionColorBlack)];
        });
        
        it(@"should have black board position on {0; 1}", ^{
            [[theValue([[board positionForRow:0 column:1] color]) should] equal:theValue(GVRBoardPositionColorWhite)];
        });
        
        it(@"should have black board position on {1; 1}", ^{
            [[theValue([[board positionForRow:1 column:1] color]) should] equal:theValue(GVRBoardPositionColorBlack)];
        });
        
        it(@"should have black board position on {1; 0}", ^{
            [[theValue([[board positionForRow:1 column:0] color]) should] equal:theValue(GVRBoardPositionColorWhite)];
        });
    });
});

SPEC_END
