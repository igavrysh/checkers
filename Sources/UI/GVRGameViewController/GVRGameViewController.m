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
#import "GVRCellView.h"

#import "UIViewController+GVRExtensions.h"
#import "NSMutableArray+GVRTrajectory.h"
#import "NSArray+GVRTrajectory.h"

#import "GVRMacros.h"
#import "GVRCompilerMacros.h"

kGVRStringVariableDefinition(GVRPlayer1Name, @"Player 1");
kGVRStringVariableDefinition(GVRPlayer2Name, @"Player 2");

@interface GVRGameViewController ()
@property (nonatomic, strong)   GVRGame         *game;
@property (nonatomic, assign)   GVRPlayer       activePlayer;
@property (nonatomic, readonly) NSString        *activePlayerName;
@property (nonatomic, strong)   UIView          *draggingChecker;
@property (nonatomic, assign)   CGPoint         touchOffset;
@property (nonatomic, strong)   NSMutableArray  *trajectory;
@property (nonatomic, assign)   GVRBoardCell    initialCell;

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

- (UIView *)viewWithTouch:(UITouch *)touch event:(UIEvent *)event {
    return [self.view hitTest:[touch locationInView:self.gameView] withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *hitView = [self viewWithTouch:touch event:event];
    
    if (GVRSubViewTagChecker != hitView.tag) {
        self.draggingChecker = nil;
        
        return;
    }
    
    self.trajectory = [NSMutableArray new];
    
    if ([self.gameView.boardView.checkers containsObject:hitView]) {
        GVRCellView *cellView = [self.gameView.boardView cellForInBoardTouch:touch];
        if (cellView) {
            self.initialCell = cellView.boardCell;
            
            [self.trajectory addCell:self.initialCell];
        }
        
        self.draggingChecker = hitView;
        
        [self.gameView.boardView.baseBoardView bringSubviewToFront:hitView];
        
        CGPoint touchPoint = [touch locationInView:hitView];
        
        CGRect checkerBounds = hitView.bounds;
        
        self.touchOffset = CGPointMake(CGRectGetMidX(checkerBounds) - touchPoint.x,
                                       CGRectGetMidY(checkerBounds) - touchPoint.y);
        
        [UIView animateWithDuration:0.3
                         animations:
         ^{
             self.draggingChecker.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
             self.draggingChecker.alpha = 0.8f;
         }];
        
        return;
    } else {
        self.draggingChecker = nil;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.draggingChecker) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint pointOnMainView = [self.gameView.boardView locationInBaseBoardViewForTouch:touch];
    
    CGPoint correction = CGPointMake(pointOnMainView.x + self.touchOffset.x,
                                     pointOnMainView.y + self.touchOffset.y);
    
    self.draggingChecker.center = correction;
    
    GVRCellView *cellView = [self.gameView.boardView cellForInBoardTouch:touch];
    
    NSMutableArray *trajectory = self.trajectory;
    
    if (cellView) {
        GVRBoardCell cell = cellView.boardCell;

        GVRBoardPosition *position = [self.game.board positionForCell:cell];
        
        if (position.isFilled || GVRBoardPositionColorWhite == position.color) {
            return;
        }
        
        NSUInteger cellCount = trajectory.count;
        if (cellCount >= 1
            && GVRBoardCellIsEqualToBoardCell([trajectory cellAtIndex:cellCount - 1], cell))
        {
            return;
        }
        
        GVRBoardDirection oldDirection = GVRBoardDirectionMake(0, 0);
        GVRBoardDirection newDirection = GVRBoardDirectionMake(1, 1);
        if (cellCount >= 2) {
            GVRBoardCell lastCell = [trajectory cellAtIndex:cellCount - 1];
            GVRBoardCell last2Cell = [trajectory cellAtIndex:cellCount - 2];
            oldDirection = GVRBoardDirectionUsingCells(last2Cell, lastCell);
            newDirection = GVRBoardDirectionUsingCells(lastCell, cell);
        }
        
        if (GVRBoardDirectionIsEqualToBoardDirection(oldDirection, newDirection)) {
            [trajectory setCell:cell atIndex:cellCount - 1];
        } else {
            [self.trajectory addCell:cell];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.draggingChecker) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    [self.game moveChekerBySteps:self.trajectory
                       forPlayer:self.activePlayer
           withCompletionHandler:^(BOOL success)
    {
        
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
