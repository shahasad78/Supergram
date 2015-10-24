//
//  UserSettingsViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/23/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "UserSettingsViewController.h"

@interface UserSettingsViewController()
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *viewTitle;

@end
@implementation UserSettingsViewController
- (IBAction)onChangePasswordPressed:(UIButton *)sender {
}
- (IBAction)onLogOutButtonPressed:(UIButton *)sender {
}

- (void) viewDidLoad{
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.77 green:0.33 blue:0.42 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;

}

- (IBAction) unwindToProfile:(UIStoryboardSegue *)segue {

}

@end
