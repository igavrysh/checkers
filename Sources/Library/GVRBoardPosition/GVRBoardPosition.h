//
//  GVRBoardPosition.h
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVRChecker.h"

typedef enum : NSUInteger {
    GVRBoardPositionColorWhite,
    GVRBoardPositionColorBlack
} GVRBoardPositionColor;

@interface GVRBoardPosition : NSObject
@property (nonatomic, strong)   GVRChecker              *checker;
@property (nonatomic, readonly) NSUInteger              rowNumber;
@property (nonatomic, readonly) NSUInteger              columnNumber;
@property (nonatomic, readonly) GVRBoardPositionColor   color;

- (instancetype)initWithColor:(GVRBoardPositionColor)color
                    rowNumber:(NSUInteger)rowNumber
                 columnNumber:(NSUInteger)columnNumber
                      checker:(GVRChecker *)checker;

@end
