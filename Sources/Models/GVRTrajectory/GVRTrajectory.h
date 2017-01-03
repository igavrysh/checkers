//
//  GVRTrajectory.h
//  Checkers
//
//  Created by Ievgen on 1/3/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GVRBoard;

@interface GVRTrajectory : NSObject

+ (instancetype)trajectoryWithSteps:(NSArray *)steps;

- (instancetype)initWithSteps:(NSArray *)steps;

- (BOOL)applyForBoard:(GVRBoard *)board
         playerNumber:(NSUInteger)playerNumber
                error:(NSError **)error;

@end
