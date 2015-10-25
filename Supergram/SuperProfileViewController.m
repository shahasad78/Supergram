//
//  SuperProfileViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "SuperProfileViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface SuperProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;

@property (weak, nonatomic) IBOutlet UIButton *editProfileImageBtn;

@end

@implementation SuperProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFUser *user = [PFUser currentUser];

    // If the current visitor is not logged in, show the login scene

    if (user == nil ) {
        [self showLogInScreen];
    }

    // Show the current visitor's username
    if (user.username) {
        self.usernameLabel.text = user.username;
    }

    if (user[@"profilePic"]) {
        self.profileImage.file = user[@"profilePic"];
        
        [self.profileImage loadInBackground];
    }
}

- (void) showLogInScreen {

    __weak SuperProfileViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{

        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        LoginViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    });
}

- (IBAction) unwindToProfile:(UIStoryboardSegue *)segue {

}


@end
