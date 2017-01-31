//
//  NSMutableArray+GVRTrajectory.h
//  Checkers
//
//  Created by Ievgen on 1/16/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVRBoardPosition.h"

@interface NSMutableArray (GVRTrajectory)

- (void)addCell:(GVRBoardCell)cell;

- (void)setCell:(GVRBoardCell)cell atIndex:(NSUInteger)index;

@end
