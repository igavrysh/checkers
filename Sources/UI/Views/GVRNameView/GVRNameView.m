//
//  GVRNameView.m
//  Checkers
//
//  Created by Ievgen on 1/25/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRNameView.h"

@implementation GVRNameView

#pragma mark -
#pragma mark Initializations and Deallocations


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"Init");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Init");
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"Init");
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
