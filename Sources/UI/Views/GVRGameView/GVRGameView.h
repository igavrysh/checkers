//
//  GVRGameView.h
//  Checkers
//
//  Created by Ievgen on 1/12/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GVRBoardView.h"
#import "GVRGame.h"

@interface GVRGameView : UIView
@property (nonatomic, strong)   IBOutlet GVRBoardView   *boardView;
@property (nonatomic, assign)   GVRPlayer               activePlayer;           
@property (nonatomic, strong)   IBOutlet UILabel        *playerNameLabel;

@end
