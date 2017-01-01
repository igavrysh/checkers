//
//  GVRChecker.m
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import "GVRChecker.h"

@interface GVRChecker ()
@property (nonatomic, assign)   GVRCheckerType  type;
@property (nonatomic, assign)   GVRCheckerColor color;

@end

@implementation GVRChecker

#pragma mark -
#pragma mark Class Method

+ (instancetype)checkerWithType:(GVRCheckerType)type
                          color:(GVRCheckerColor)color
{
    return [[self alloc] initWithType:type color:color];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithType:(GVRCheckerType)type
                       color:(GVRCheckerColor)color
{
    self = [super init];
    if (self) {
        self.type = type;
        self.color = color;
    }
    
    return self;
}

#pragma mark - 
#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    return [GVRChecker checkerWithType:self.type color:self.color];
}

@end
