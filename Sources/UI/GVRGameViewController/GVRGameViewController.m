//
//  GVRGameViewController.m
//  Checkers
//
//  Created by Ievgen on 1/12/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RACAlertAction/RACAlertAction.h>
#import <libextobjc/extobjc.h>

#import "GVRGameViewController.h"
#import "GVRNameViewController.h"
#import "GVRGame.h"
#import "GVRGameView.h"
#import "GVRCellView.h"
#import "GVRGCDQueue.h"

#import "UIViewController+GVRExtensions.h"
#import "NSMutableArray+GVRTrajectory.h"
#import "NSArray+GVRTrajectory.h"

#import "GVRMacros.h"
#import "GVRCompilerMacros.h"

kGVRStringVariableDefinition(GVRPlayer1Name, @"Player 1");
kGVRStringVariableDefinition(GVRPlayer2Name, @"Player 2");
kGVRStringVariableDefinition(GVRAlertTitle, @"New Game");
kGVRStringVariableDefinition(GVRAlertTitleMessage, @"the Checkers game is about to start");
kGVRStringVariableDefinition(GVRAlertStartGame, @"Start Game");
kGVRStringVariableDefinition(GVRAlertEnterNames, @"Enter Players Names");
kGVRStringVariableDefinition(GVRAlertTitleFirstName, @"First Player Name");
kGVRStringVariableDefinition(GVRAlertMessageFirstName, @"The name of white checkers player which is used during the game");
kGVRStringVariableDefinition(GVRAlertEnterSecondName, @"Second Player Name");
kGVRStringVariableDefinition(GVRAlertBack, @"Back");


@interface GVRGameViewController ()
@property (nonatomic, strong)   GVRGame             *game;
@property (nonatomic, assign)   GVRPlayer           activePlayer;
@property (nonatomic, readonly) NSString            *activePlayerName;
@property (nonatomic, strong)   UIView              *draggingChecker;
@property (nonatomic, assign)   CGPoint             touchOffset;
@property (nonatomic, strong)   NSMutableArray      *trajectory;
@property (nonatomic, assign)   GVRBoardCell        initialCell;

@property (nonatomic, strong) UIAlertController     *alertController;
@property (nonatomic, strong) UIAlertController     *enterNameController;
@property (nonatomic, strong) GVRNameViewController *nameViewController;

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

    @weakify(self)
    
    self.enterNameController
    = [UIAlertController alertControllerWithTitle:GVRAlertTitleFirstName
                                          message:GVRAlertMessageFirstName
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    [self.enterNameController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter First Player Name";
        //textField.textColor = [UIColor redColor];
    }];
    
    
    self.alertController
        = [UIAlertController alertControllerWithTitle:GVRAlertTitle
                                              message:GVRAlertTitleMessage
                                       preferredStyle:UIAlertControllerStyleActionSheet];
    
    RACAlertAction *newGameAction = [RACAlertAction actionWithTitle:GVRAlertStartGame style:UIAlertActionStyleDefault];

    newGameAction.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [self.game begin:^(BOOL success) {
                @strongify(self)

                GVRAsyncPerformInMainQueue(^{
                    if (success) {
                        self.activePlayer = self.game.activePlayer;
                        self.gameView.boardView.board = self.game.board;
                    }
                });
            }];
            
            return nil;
        }];
    }];
    [self.alertController addAction:newGameAction];
    
    RACAlertAction *enterNameAction = [RACAlertAction actionWithTitle:GVRAlertEnterNames style:UIAlertActionStyleDefault];
    enterNameAction.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            
            self.nameViewController = [GVRNameViewController new];
            
            [self.navigationController pushViewController:self.nameViewController animated:YES];
            
            //[self presentViewController:self.enterNameController animated:YES completion:nil];
            
            return nil;
        }];
    }];
    [self.alertController addAction:enterNameAction];
    
    
    RACAlertAction *nextPlayerAction = [RACAlertAction actionWithTitle:GVRAlertEnterSecondName style:UIAlertActionStyleDefault];
    nextPlayerAction.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            [self presentViewController:self.enterNameController animated:YES completion:nil];
            
            return nil;
        }];
    }];
    [self.enterNameController addAction:nextPlayerAction];
    
    RACAlertAction *backAction = [RACAlertAction actionWithTitle:GVRAlertBack style:UIAlertActionStyleDefault];
    backAction.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            [self.enterNameController dismissViewControllerAnimated:NO completion:nil];
            
            [self presentViewController:self.alertController animated:YES completion:nil];
            
            return nil;
        }];
    }];
    [self.enterNameController addAction:backAction];
    
    
    [self presentViewController:self.alertController animated:YES completion:nil];
    
    /*
    [alert addAction:[UIAlertAction actionWithTitle:
                                              style:
                                            handler:^(UIAlertAction * action)
    {
        //@weakify(self)
        [self.game begin:^(BOOL success) {
            //@strongify(self)
            
            GVRAsyncPerformInMainQueue(^{
                if (success) {
                    self.activePlayer = self.game.activePlayer;
                    self.gameView.boardView.board = self.game.board;
                }
            });
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:GVRAlertEnterNames
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action)
    {
        UIAlertController *enterNameController
            = [UIAlertController alertControllerWithTitle:GVRAlertTitleFirstName
                                                  message:GVRAlertMessageFirstName
                                           preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Next"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action)
        {
            NSLog(@"Next button tapped!");
            NSLog(@"Textfield text - %@", enterNameController.textFields.firstObject.text);
        }];
        
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"Back"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action)
        {
            NSLog(@"Next button tapped!");
            NSLog(@"Textfield text - %@", enterNameController.textFields.firstObject.text);
        }];
        
        [enterNameController addAction:backAction];
        [enterNameController addAction:alertAction];
        
        [enterNameController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Enter First Player Name";
            //textField.textColor = [UIColor redColor];
        }];
        
        [self presentViewController:enterNameController animated:YES completion:nil];
    }]];
    
    // show the alert
    [self presentViewController:alert animated:YES completion:^{
    
    }];
     
     */
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
        GVRBoardCell lastCell = [trajectory cellAtIndex:cellCount - 1];
        
        if (cellCount == 1) {
            [self.trajectory addCell:cell];
            
            return;
        }
        
        
        if (cellCount >= 1
            && GVRBoardCellIsEqualToBoardCell(lastCell, cell))
        {
            return;
        }
        
        
        GVRBoardCell previousCell = [trajectory cellAtIndex:cellCount - 2];
        GVRBoardDirection direction = GVRBoardDirectionUsingCells(lastCell, cell);
        GVRBoardDirection previousDirection = GVRBoardDirectionUsingCells(previousCell, lastCell);
        
        GVRBoardPosition *victimPosition = [self.game.board victimPositionFromCell:lastCell
                                                                            toCell:cell
                                                                         forPlayer:self.activePlayer
                                                                             error:nil];
        if (victimPosition
            || !GVRBoardDirectionIsEqualToBoardDirection(direction, previousDirection))
        {
            [trajectory addCell:cell];
        } else {
            [trajectory setCell:cell atIndex:cellCount - 1];
        }
        
        if (self.trajectory.count > 2 &&
            ![self.game.board victimPositionFromCell:[self.trajectory cellAtIndex:0]
                                             toCell:[self.trajectory cellAtIndex:1]
                                          forPlayer:self.activePlayer
                                              error:nil])
        {
            [self.trajectory removeObjectAtIndex:1];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.draggingChecker) {
        return;
    }
    
    @weakify(self)
    GVRAsyncPerformInBackgroundQueue(^{
        [self.game moveChekerBySteps:self.trajectory
                           forPlayer:self.activePlayer
               withCompletionHandler:^(BOOL success)
         {
             @strongify(self)
             GVRAsyncPerformInMainQueue(^{
                 self.activePlayer = self.game.activePlayer;
                 
                 [self.gameView.boardView updateCheckers];
             });
         }];
    });
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.gameView.boardView updateCheckers];
}

@end
