//
//  GVRGameView.h
//  Checkers
//
//  Created by Ievgen on 1/12/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GVRBoardView.h"

@interface GVRGameView : UIView
@property (nonatomic, strong) IBOutlet GVRBoardView *boardView;

@end
