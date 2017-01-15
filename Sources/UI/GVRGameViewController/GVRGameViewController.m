//
//  GVRGameViewController.m
//  Checkers
//
//  Created by Ievgen on 1/12/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

//#import <libextobjc/extobjc.h>

#import "GVRGameViewController.h"

#import "GVRGame.h"
#import "GVRGameView.h"

#import "UIViewController+GVRExtensions.h"

#import "GVRMacros.h"
#import "GVRCompilerMacros.h"

kGVRStringVariableDefinition(GVRPlayer1Name, @"Player 1");
kGVRStringVariableDefinition(GVRPlayer2Name, @"Player 2");

@interface GVRGameViewController ()
@property (nonatomic, strong)   GVRGame     *game;
@property (nonatomic, assign)   GVRPlayer   activePlayer;
@property (nonatomic, readonly) NSString    *activePlayerName;
@property (nonatomic, strong)   UIView      *draggingChecker;
@property (nonatomic, assign)   CGPoint     touchOffset;

@end

GVRViewControllerBaseViewProperty(GVRGameViewController, GVRGameView, gameView)

@implementation GVRGameViewController

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.game = [GVRGame new];
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setActivePlayer:(GVRPlayer)activePlayer {
    if (_activePlayer != activePlayer) {
        _activePlayer = activePlayer;
        self.gameView.activePlayer = activePlayer;
        self.gameView.playerNameLabel.text = self.activePlayerName;
        self.navigationController.navigationBar.topItem.title =  self.activePlayerName;
    }
}

- (NSString *)activePlayerName {
    return self.activePlayer == GVRPlayerWhiteCheckers ? GVRPlayer1Name : GVRPlayer2Name;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //@weakify(self)
    [self.game begin:^(BOOL success) {
        //@strongify(self)
        
        if (success) {
            self.gameView.boardView.board = self.game.board;
            self.activePlayer = self.game.activePlayer;
        }
    }];
}

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *hitView = [self.view hitTest:[touch locationInView:self.gameView] withEvent:event];
    
    if (GVRSubViewTagChecker != hitView.tag) {
        self.draggingChecker = nil;
        
        return;
    }
    
    if ([self.gameView.boardView.checkers containsObject:hitView]) {
        self.draggingChecker = hitView;
        
        [self.gameView.boardView bringSubviewToFront:hitView];
        
        CGPoint touchPoint = [touch locationInView:hitView];
        
        CGRect checkerBounds = hitView.bounds;
        
        self.touchOffset = CGPointMake(CGRectGetMidX(checkerBounds) - touchPoint.x,
                                       CGRectGetMidY(checkerBounds) - touchPoint.y);
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.draggingChecker.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
                             self.draggingChecker.alpha = 0.3f;
                         }];
        return;
    } else {
        self.draggingChecker = nil;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.draggingChecker) {
        UITouch *touch = [touches anyObject];
        
        CGPoint pointOnMainView = [self.gameView.boardView locationInBaseBoardViewForTouch:touch];
        
        CGPoint correction = CGPointMake(pointOnMainView.x + self.touchOffset.x,
                                         pointOnMainView.y + self.touchOffset.y);
        
        self.draggingChecker.center = correction;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.draggingChecker) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    /*
    UIView *closestCell = nil;
    double closestDistance = 0;
    
    for (UIView* cell in self.gameView.boardView.checkers) {
        if (GVRSubViewTagBlackCell == cell.tag) {
            if ([self isFilledCell:cell]) {
                continue;
            }
            
            double newDistnance = [self distanceBetweenPoint:cell.center andPoint:self.draggingChecker.center];
            if (closestCell == nil) {
                closestCell = cell;
                closestDistance = newDistnance;
            } else {
                if (newDistnance < closestDistance) {
                    closestDistance = newDistnance;
                    closestCell = cell;
                }
            }
        }
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.draggingChecker.center = closestCell.center;
                         self.draggingChecker.transform = CGAffineTransformIdentity;
                         self.draggingChecker.alpha = 1.f;
                     }];
    
    self.draggingChecker = nil;
    */
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
}

#pragma mark - Helper function

- (double)distanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2 {
    return sqrt(pow(point1.x-point2.x,2) + pow(point1.y-point2.y,2));
}

- (BOOL)isEqualPoint:(CGPoint)point1 toPoint:(CGPoint)point2 {
    return point1.x == point2.x && point1.y == point2.y;
}

/*

- (BOOL)isFilledCell:(UIView *)cell {
    for (UIView* view in self.board.subviews) {
        
        if (view.tag == ASSubViewTagCheckers  && ![view isEqual:self.draggingView]) {
            
            if ([self distanceBetweenPoint:view.center andPoint:cell.center] < cell.bounds.size.width / 2) {
                
                return YES;
            }
        }
    }
    return NO;
}
 
 */

@end
