//
//  NSValue+GVRExtensions.h
//  Checkers
//
//  Created by Ievgen on 1/9/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVRBoardPosition.h"

@interface NSValue (GVRExtensions)

+ (instancetype)valueWithCell:(GVRBoardCell)cell;

@end
