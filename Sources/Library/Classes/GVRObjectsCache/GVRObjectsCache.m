//
//  GVRObjectsCache.m
//  SuperUI
//
//  Created by Ievgen on 9/12/16.
//  Copyright © 2016 1mlndollarsasset. All rights reserved.
//

#import "GVRObjectsCache.h"

#import "GVRDispatchMacros.h"

@interface GVRObjectsCache ()
@property (nonatomic, strong) NSMapTable *objects;

@end

@implementation GVRObjectsCache

#pragma mark - 
#pragma mark Class Methods

+ (instancetype)cache {
    GVRReturnAfterSettingVariableWithBlockOnce(^{
        return [self new];
    });
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    self.objects = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality
                                         valueOptions:NSPointerFunctionsWeakMemory];
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (id)objectForKey:(id)key {
    @synchronized(self) {
        return [self.objects objectForKey:key];
    }
}

- (void)setObject:(id)object forKey:(id)key {
    @synchronized(self) {
        [self.objects setObject:object forKey:key];
    }
}

@end
