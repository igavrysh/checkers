//
//  NSArray+GVRTrajectory.h
//  Checkers
//
//  Created by Ievgen on 1/8/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVRBoardPosition.h"

@interface NSArray (GVRTrajectory)

- (GVRBoardCell)cellAtIndex:(NSUInteger)index;

@end
