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
    
    registerMatchers(@"GVR"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"when board is initialized", ^{
        beforeAll(^{
            board = [GVRBoard new];
        });
        
        it(@"should have size of 10 cells * 10 cells", ^{
            [[@(board.size) should] equal:@(10)];
        });
        
        it(@"should have white checkers count of 3 * 5 = 15", ^{
            [[@(board.whiteCheckersCount) should] equal:@(15)];
        });
        
        it(@"should have black checkers count of 3 * 5 = 15", ^{
            [[@(board.blackCheckersCount) should] equal:@(15)];
        });
    });

});


SPEC_END
