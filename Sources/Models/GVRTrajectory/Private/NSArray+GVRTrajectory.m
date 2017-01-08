//
//  NSArray+GVRTrajectory.m
//  Checkers
//
//  Created by Ievgen on 1/8/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "NSArray+GVRTrajectory.h"

@implementation NSArray (GVRTrajectory)

#pragma mark -
#pragma mark Public Methods

- (GVRBoardCell)cellAtIndex:(NSUInteger)index {
    GVRBoardCell cell;
    [self[index] getValue:&cell];
    
    return cell;
}

@end
