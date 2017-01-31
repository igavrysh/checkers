//
//  NSMutableArray+GVRTrajectory.m
//  Checkers
//
//  Created by Ievgen on 1/16/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "NSMutableArray+GVRTrajectory.h"

#import "NSValue+GVRExtensions.h"

@implementation NSMutableArray (GVRTrajectory)

#pragma mark -
#pragma mark Public Methods

- (void)addCell:(GVRBoardCell)cell {
    [self addObject:[NSValue valueWithCell:cell]];
}

- (void)setCell:(GVRBoardCell)cell atIndex:(NSUInteger)index {
    if (index >= self.count) {
        return;
    }
    
    self[index] = [NSValue valueWithCell:cell];
}

@end
