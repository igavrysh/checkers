//
//  GVRDispatchMacros.h
//  SuperUI
//
//  Created by Ievgen on 9/5/16.
//  Copyright © 2016 1mlndollarsasset. All rights reserved.
//

#import "GVRBlockMacros.h"

#define GVRReturnAfterSettingVariableWithBlockOnce(factoryBlock) \
    do { \
        static id variable = nil; \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            GVRAssignBlockPerform(factoryBlock, variable); \
        }); \
        \
        return variable; \
    \
    } while(0) \




