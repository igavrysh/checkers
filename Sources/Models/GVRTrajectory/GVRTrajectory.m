//
//  GVRTrajectory.m
//  Checkers
//
//  Created by Ievgen on 1/3/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRTrajectory.h"

#import "GVRBoard.h"

@implementation GVRTrajectory

#pragma mark -
#pragma mark Class Methods

+ (instancetype)trajectoryWithSteps:(NSArray *)steps {
    return [[self alloc] initWithSteps:steps];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithSteps:(NSArray *)steps {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (BOOL)applyForBoard:(GVRBoard *)board
         playerNumber:(NSUInteger)playerNumber
                error:(NSError **)error
{
    return NO;
}

@end
