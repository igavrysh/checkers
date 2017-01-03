//
//  GVRGame.h
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GVRPlayerWhiteCheckers,
    GVRPlayerBlackCheckers
} GVRPlayer;

@interface GVRGame : NSObject

- (void)begin:(void(^)(BOOL success))block;

- (void)end:(void(^)(BOOL success))block;

- (void)moveChekerBySteps:(NSArray *)steps
                forPlayer:(GVRPlayer)player
    withCompletionHandler:(void(^)(BOOL success))block;

@end
