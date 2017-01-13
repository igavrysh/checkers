//
//  GVRGameViewController.m
//  Checkers
//
//  Created by Ievgen on 1/12/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRGameViewController.h"

#import "GVRGameView.h"

#import "UIViewController+GVRExtensions.h"

#import "GVRMacros.h"
#import "GVRCompilerMacros.h"

@interface GVRGameViewController ()

@end

GVRViewControllerBaseViewProperty(GVRGameViewController, GVRGameView, gameView)

@implementation GVRGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
