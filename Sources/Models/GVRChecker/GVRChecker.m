//
//  GVRChecker.m
//  Checkers
//
//  Created by Ievgen on 12/31/16.
//  Copyright © 2016 Gavrysh. All rights reserved.
//

#import "GVRChecker.h"

#import "GVRBoardPosition.h"

@interface GVRChecker ()
@property (nonatomic, assign)   GVRCheckerType  type;
@property (nonatomic, assign)   GVRCheckerColor color;

@end

@implementation GVRChecker

#pragma mark -
#pragma mark Class Methods

+ (instancetype)whiteKing {
    return [self checkerWithType:GVRCheckerTypeKing color:GVRCheckerColorWhite];
}

+ (instancetype)blackKing {
    return [self checkerWithType:GVRCheckerTypeKing color:GVRCheckerColorBlack];
}

+ (instancetype)whiteMan {
    return [self checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorWhite];
}

+ (instancetype)blackMan {
    return [self checkerWithType:GVRCheckerTypeMan color:GVRCheckerColorBlack];
}

+ (instancetype)checkerWithType:(GVRCheckerType)type color:(GVRCheckerColor)color {
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
#pragma mark Public Methos

- (void)promoteCheckerType {
    self.type = GVRCheckerTypeKing;
}


- (BOOL)isAllowedDistanceToVictim:(NSInteger)distance {
    GVRCheckerType type = self.type;
    if (GVRCheckerTypeMan == type) {
        return labs(distance) == 1 ? YES : NO;
    } else if (GVRCheckerTypeKing == type) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isAllowedDistanceToVictimFromCell:(GVRBoardCell)fromCell
                                   toCell:(GVRBoardCell)toCell
{
    return [self isAllowedDistanceToVictim:GVRRowDistanceBetweenCells(fromCell, toCell)];
}

- (BOOL)isAllowedSingleJumpDistance:(NSInteger)distance {
    GVRCheckerType type = self.type;
    if (GVRCheckerTypeMan == type) {
        return distance > 0 && distance <= 1 ? YES : NO;
    } else if (GVRCheckerTypeKing == type) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isAllowedSingleJumpDistanceFromCell:(GVRBoardCell)fromCell
                                     toCell:(GVRBoardCell)toCell
{
    return [self isAllowedSingleJumpDistance:GVRRowDistanceBetweenCells(fromCell, toCell)];
}


#pragma mark - 
#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    GVRChecker *checker = [GVRChecker checkerWithType:self.type color:self.color];
    checker.markedForRemoval = self.markedForRemoval;
    
    return checker;
}

@end
