//
//  GVRNameViewController.m
//  Checkers
//
//  Created by Ievgen on 1/25/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>

#import "GVRNameViewController.h"

#import "GVRNameView.h"

#import "GVRMacros.h"

@interface GVRNameViewController ()
@property (nonatomic, assign) GVRNameViewControllerDialogType   type;

- (NSString *)actionButtonTitle;

@end

GVRViewControllerBaseViewProperty(GVRNameViewController, GVRNameView, nameView)

@implementation GVRNameViewController

#pragma mark -
#pragma mark Class Methods

+ (instancetype)firstNameViewController {
    return [[self alloc] initWithDialogType:GVRNameViewControllerDialogTypeFirst];
}

+ (instancetype)lastNameViewController {
    return [[self alloc] initWithDialogType:GVRNameViewControllerDialogTypeLast];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithDialogType:(GVRNameViewControllerDialogType)type {
    self = [super init];
    self.type = type;
    
    return self;
}

#pragma mark - 
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nameView.actionButton setTitle:[self actionButtonTitle] forState:UIControlStateNormal];

    RACSignal *nameValid = [self.nameView.textField.rac_textSignal map:^id(NSString *name) {
        return @(name.length > 0);
    }];
    
    RAC(self, playerName) = [[self.nameView.textField rac_textSignal] map:^id(NSString *firstPlayerName) {
        return firstPlayerName;
    }];
    
    @weakify(self)
    RACCommand *nextActionCommand = [[RACCommand alloc] initWithEnabled:nameValid
                                                            signalBlock:^RACSignal *(id input)
    {
        @strongify(self)
        
        if (GVRNameViewControllerDialogTypeFirst == self.type) {
            
            [self.navigationController pushViewController:[GVRNameViewController lastNameViewController]
                                                 animated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
        return [RACSignal empty];
    }];
    
    [[self.nameView.actionButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         [nextActionCommand execute:sender];
     }];
    
    //RACEvent event;
    //event.eventType
    
    //RACSignal *buttonEnabled = RACAbleWithStart(nextActionCommand, enabled);
    RAC(self.nameView.actionButton, enabled) = nameValid;
    //RAC(self.nameView.actionButton, enabled) = buttonEnabled;
}

- (NSString *)actionButtonTitle {
    GVRNameViewControllerDialogType type = self.type;
    
    return type == GVRNameViewControllerDialogTypeFirst ? @"Next"
        : type == GVRNameViewControllerDialogTypeLast ? @"Start"
        : @"?";
}

@end
