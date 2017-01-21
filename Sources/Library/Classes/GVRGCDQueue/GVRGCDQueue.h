//
//  GVRGCDQueue.h
//  SuperObjCProject
//
//  Created by Ievgen on 7/19/16.
//  Copyright © 2016 1mlndollarsasset. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GVRGCDExecutionBlock)(void);

typedef enum {
    GVRQueuePriorityTypeHigh        = DISPATCH_QUEUE_PRIORITY_HIGH,
    GVRQueuePriorityTypeDefault     = DISPATCH_QUEUE_PRIORITY_DEFAULT,
    GVRQueuePriorityTypeLow         = DISPATCH_QUEUE_PRIORITY_LOW,
    GVRQueuePriorityTypeBackground  = DISPATCH_QUEUE_PRIORITY_BACKGROUND
} GVRQueuePriorityType;

void GVRAsyncPerformInBackgroundQueue(GVRGCDExecutionBlock block);
void GVRSyncPerformInBackgoundQueue(GVRGCDExecutionBlock block);

void GVRAsyncPerformInQueue(GVRQueuePriorityType type, GVRGCDExecutionBlock block);
void GVRSyncPerformInQueue(GVRQueuePriorityType type, GVRGCDExecutionBlock block);

void GVRAsyncPerformInMainQueue(GVRGCDExecutionBlock block);
void GVRSyncPerformInMainQueue(GVRGCDExecutionBlock block);

dispatch_queue_t GVRGetGlobalQueueWithType(GVRQueuePriorityType type);
