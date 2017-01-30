//
//  GVRNameViewController.h
//  Checkers
//
//  Created by Ievgen on 1/25/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GVRNameViewControllerDialogType) {
    GVRNameViewControllerDialogTypeFirst,
    GVRNameViewControllerDialogTypeLast
};

@interface GVRNameViewController : UIViewController
@property (nonatomic, strong)   NSString    *playerName;

+ (instancetype)firstNameViewController;

+ (instancetype)lastNameViewController;

- (instancetype)initWithDialogType:(GVRNameViewControllerDialogType)type;

@end
