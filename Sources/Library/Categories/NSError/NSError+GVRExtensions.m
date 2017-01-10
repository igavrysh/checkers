//
//  NSError+GVRExtensions.m
//  Checkers
//
//  Created by Ievgen on 1/5/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "NSError+GVRExtensions.h"

@implementation NSError (GVRExtensions)

#pragma mark -
#pragma mark Class Methods

+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code {
    return [NSError errorWithDomain:domain
                               code:code
                           userInfo:nil];
}


@end
