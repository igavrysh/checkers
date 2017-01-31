//
//  GVRGCDQueue.m
//  SuperObjCProject
//
//  Created by Ievgen on 7/19/16.
//  Copyright © 2016 1mlndollarsasset. All rights reserved.
//

#import "GVRGCDQueue.h"

void GVRAsyncPerformInBackgroundQueue(GVRGCDExecutionBlock block) {
    GVRAsyncPerformInQueue(GVRQueuePriorityTypeBackground, block);
}

void GVRSyncPerformInBackgoundQueue(GVRGCDExecutionBlock block) {
    GVRSyncPerformInQueue(GVRQueuePriorityTypeBackground, block);
}

void GVRAsyncPerformInQueue(GVRQueuePriorityType type, GVRGCDExecutionBlock block) {
    dispatch_async(GVRGetGlobalQueueWithType(type), block);
}

void GVRSyncPerformInQueue(GVRQueuePriorityType type, GVRGCDExecutionBlock block) {
    dispatch_sync(GVRGetGlobalQueueWithType(type), block);
}

void GVRAsyncPerformInMainQueue(GVRGCDExecutionBlock block) {
    dispatch_async(dispatch_get_main_queue(), block);
}

void GVRSyncPerformInMainQueue(GVRGCDExecutionBlock block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

dispatch_queue_t GVRGetGlobalQueueWithType(GVRQueuePriorityType type) {
    return dispatch_get_global_queue(type, 0);
}
