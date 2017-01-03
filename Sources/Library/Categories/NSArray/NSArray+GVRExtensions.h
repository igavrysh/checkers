//
//  NSArray+GVRExtensions.h
//  SuperUI
//
//  Created by Ievgen on 8/31/16.
//  Copyright © 2016 1mlndollarsasset. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (GVRExtensions)

+ (NSArray *)objectsWithCount:(NSUInteger)count block:(id(^)())block;

- (id)objectWithClass:(Class)class;

- (void)performBlockWithEachObject:(void (^)(id object))block;

- (void)performBlockWithEachObject:(void (^)(id object1, id object2))block
                 pairwiseWithArray:(NSArray *)array;

- (NSArray *)filteredArrayUsingBlock:(BOOL (^)(id object))block;

@end
