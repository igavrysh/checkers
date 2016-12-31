//
//  GVRChecker.h
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GVRCheckerTypeMan,
    GVRCheckerTypeKing
} GVRCheckerType;

typedef enum : NSUInteger {
    GVRCheckerColorWhite,
    GVRCheckerColorBlack
} GVRCheckerColor;

@interface GVRChecker : NSObject <NSCopying>
@property (nonatomic, readonly)     GVRCheckerType  type;
@property (nonatomic, readonly)     GVRCheckerColor color;


+ (instancetype)checkerWithType:(GVRCheckerType)type
                          color:(GVRCheckerColor)color;

- (instancetype)initWithType:(GVRCheckerType)type
                       color:(GVRCheckerColor)color;

@end
