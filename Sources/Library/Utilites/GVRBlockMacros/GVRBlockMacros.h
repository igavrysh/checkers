//
//  GVRBlockMacros.h
//  SuperUI
//
//  Created by Ievgen on 8/23/16.
//  Copyright © 2016 1mlndollarsasset. All rights reserved.
//

#import "GVRMacros.h"

#define __GVRBlockPerform(operand, operation, block, ...) \
    do { \
        typeof(block) blockToFire = block; \
        if (blockToFire) { \
            operand operation blockToFire(__VA_ARGS__); \
        } \
    } while(0) \

#define GVRBlockPerform(block, ...) \
    __GVRBlockPerform(GVREmpty, GVREmpty, block, __VA_ARGS__)

#define GVRReturnBlockPerform(block, ...) \
    __GVRBlockPerform(GVREmpty, return, block, __VA_ARGS__)

#define GVRAssignBlockPerform(block, variable, ...) \
    __GVRBlockPerform(variable, =, block, __VA_ARGS__)

