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
    });
});

SPEC_END
