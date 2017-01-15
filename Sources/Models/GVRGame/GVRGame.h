//
//  GVRGame.h
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GVRBoard;

typedef enum : NSUInteger {
    GVRPlayerNone,
    GVRPlayerWhiteCheckers,
    GVRPlayerBlackCheckers
} GVRPlayer;

@interface GVRGame : NSObject
@property (nonatomic, readonly) GVRBoard    *board;
@property (nonatomic, readonly) GVRPlayer   activePlayer;

- (void)begin:(void(^)(BOOL success))block;

- (void)beginWithBoard:(GVRBoard *)board
     completionHandler:(void (^)(BOOL))block;

- (void)end:(void(^)(BOOL success))block;

- (void)moveChekerBySteps:(NSArray *)steps
                forPlayer:(GVRPlayer)player
    withCompletionHandler:(void(^)(BOOL success))block;

@end
