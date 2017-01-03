//
//  NSArray+GVRExtensions.m
//  SuperUI
//
//  Created by Ievgen on 8/31/16.
//  Copyright © 2016 1mlndollarsasset. All rights reserved.
//

#import "NSArray+GVRExtensions.h"

@implementation NSArray (GVRExtensions)

#pragma mark -
#pragma mark Class Methods

+ (NSArray *)objectsWithCount:(NSUInteger)count block:(id(^)())block {
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSUInteger index = 0; index < count; index++) {
        [array addObject:block()];
    }
    
    return [array copy];
}

#pragma mark -
#pragma mark Public Methods

- (id)objectWithClass:(Class)cls {
    for (id object in self) {
        if ([object isMemberOfClass:cls]) {
            return object;
        }
    }
    
    return nil;
}

- (void)performBlockWithEachObject:(void (^)(id object))block {
    if (!block) {
        return;
    }
    
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        block(object);
    }];
}

- (void)performBlockWithEachObject:(void (^)(id object1, id object2))block
                pairwiseWithArray:(NSArray *)array
{
    if (!block || self.count != array.count) {
        return;
    }
    
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        block(object, array[index]);
    }];
}


- (NSArray *)filteredArrayUsingBlock:(BOOL (^)(id object))block {
    if (!block) {
        return nil;
    }
    
    id arrayFilter = ^BOOL(id object, NSDictionary<NSString *,id> *bindings) {
        return block(object);
    };
    
    NSArray *result = [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:arrayFilter]];
    
    return result;
}

@end
