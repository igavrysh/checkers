//
//  NSError+GVRExtensions.h
//  Checkers
//
//  Created by Ievgen on 1/5/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (GVRExtensions)

+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code;

@end
