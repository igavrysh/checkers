//
//  GVRNameViewController.m
//  Checkers
//
//  Created by Ievgen on 1/25/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "GVRNameViewController.h"

#import "GVRNameView.h"

#import "GVRMacros.h"

@interface GVRNameViewController ()

@end

GVRViewControllerBaseViewProperty(GVRNameViewController, GVRNameView, nameView)

@implementation GVRNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self, firstPlayerName) = [[self.nameView.textField rac_textSignal] map:^id(NSString *firstPlayerName) {
        NSLog(@"fistPlayerName %@", self.firstPlayerName);
        
        return firstPlayerName;
    }];
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
