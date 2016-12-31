//
//  GVRBoardPosition.m
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import "GVRBoardPosition.h"

@interface GVRBoardPosition ()
@property (nonatomic, assign)   GVRBoardPositionColor   color;
@property (nonatomic, assign)   NSUInteger              rowNumber;
@property (nonatomic, assign)   NSUInteger              columnNumber;

@end

@implementation GVRBoardPosition

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithColor:(GVRBoardPositionColor)color
                    rowNumber:(NSUInteger)rowNumber
                 columnNumber:(NSUInteger)columnNumber
                      checker:(GVRChecker *)checker
{
    self = [super init];
    if (self) {
        self.color = color;
        self.checker = checker;
    }
    
    return self;
}


@end
