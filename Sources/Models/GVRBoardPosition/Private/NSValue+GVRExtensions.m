//
//  NSValue+GVRExtensions.m
//  Checkers
//
//  Created by Ievgen on 1/9/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "NSValue+GVRExtensions.h"

@implementation NSValue (GVRExtensions)

#pragma mark -
#pragma mark Class Methods

+ (instancetype)valueWithCell:(GVRBoardCell)cell {
    return [NSValue valueWithBytes:&cell objCType:@encode(GVRBoardCell)];
}

@end
