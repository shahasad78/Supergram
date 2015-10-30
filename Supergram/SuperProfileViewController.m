//
//  SuperProfileViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/22/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "SuperProfileViewController.h"
#import "LoginViewController.h"
#import "ThumbnailCollectionViewCell.h"
#import "PostDetailViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"
#import "SuperUser.h"
#import "Activity.h"

@interface SuperProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate,  UICollectionViewDelegateFlowLayout>

// IBOutlet properties
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *mediaCollection;
@property (weak, nonatomic) IBOutlet UIButton *editProfileImageBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editUserSettings;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;

// Data Model properties
@property NSMutableArray *userMedia;

// Parse properties
@property SuperUser *userView;
@property SuperUser *user;
@property Activity *activity;

@end

@implementation SuperProfileViewController

#pragma mark - View Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.userView = [SuperUser currentUser];
    self.user = [SuperUser currentUser];


    self.userMedia = [[NSMutableArray alloc] init];

    // Set up Collection View
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width/3 - 10, self.view.frame.size.width/3 - 10);
    flowLayout.minimumLineSpacing = 5.0f;
    flowLayout.minimumInteritemSpacing = 5.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 5.0f, 10.0f);

    self.mediaCollection.collectionViewLayout = flowLayout;


    // If the current visitor is not logged in, show the login scene

    if (self.userView == nil) {
        [self showLogInScreen];
    }  else {
        [self setupUI];

    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (nil == self.userView) {
        [self showLogInScreen];
    } else {
        [self setupUI];
    }
}

#pragma mark - Helper Methods
- (void) setupUI {
    // Show or hide UI elements based on whether the profile belongs to current user
    if (self.searchedUser != nil) {
        if (self.searchedUser != self.userView) {
            self.userView = self.searchedUser;
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    } else {
        self.editProfileImageBtn.hidden = false;
        self.followButton.hidden = true;
    }
    self.editProfileImageBtn.hidden = (self.searchedUser != nil) && (self.searchedUser != self.userView);
    self.followButton.hidden = (self.userView == self.user);


    // Show the current visitor's username
    if (self.userView.username) {
        self.usernameLabel.text = self.userView.username;

        self.fullnameLabel.text = [NSString stringWithFormat:@"%@ %@", self.userView.firstName , self.userView.lastName];
    }

    if (self.userView[kSuperUserAttributeKey.profilePic]) {
        self.profileImage.file = self.userView[kSuperUserAttributeKey.profilePic];

        [self.profileImage loadInBackground];
    }
    

    PFQuery *query = [PFQuery queryWithClassName:kPostClass];
    [query whereKey:@"author" equalTo:self.userView];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {

        for (Post *result in posts) {
            [self.userMedia addObject:result];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mediaCollection reloadData];
        });
    }];

    // TODO: add check logic to toggle text between "follow" and "unfollow"
    query = [PFQuery queryWithClassName:kActivityClass];
    [query whereKey:kActivityKey.fromUser equalTo:self.user];
    [query whereKey:kActivityKey.toUser equalTo:self.userView];
    [query whereKey:kActivityKey.type equalTo:kActivityType.follow];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (nil != objects && !error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.followButton.selected = (objects.count > 0);
                [self.mediaCollection reloadData];
            });
        }
    }];
}

- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message andButtonName:(NSString *)buttonName{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:buttonName
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okButton];

    [self presentViewController:alert animated:YES completion:NULL];
    
}


#pragma mark - Collection View

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return self.userMedia.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{


    ThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    Post *post = [self.userMedia objectAtIndex:indexPath.row] ;


    cell.thumbnailImage.file = post.media;

   [cell.thumbnailImage loadInBackground];



    return cell;
}

#pragma mark - Following/Unfollowing
- (IBAction)onFollowButtonPressed:(UIButton *)sender {

    self.followButton.enabled = NO;
    self.followButton.selected = !self.followButton.selected;
    SuperUser *user = [SuperUser currentUser];

    PFQuery *query = [PFQuery queryWithClassName:kActivityClass];
    [query whereKey:kActivityKey.fromUser equalTo:[SuperUser currentUser]];
    [query whereKey:kActivityKey.toUser equalTo:self.userView];
    [query whereKey:kActivityKey.type equalTo:kActivityType.follow];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects != nil) {
            if (objects.count > 0) {
                // User is currently following this profile. Unfollow and remove from activity feed
                for (Activity *object in objects) {
                    [user incrementKey:kSuperUserAttributeKey.followingCount byAmount:@(-1)];
                    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        self.followButton.enabled = YES;
                    }];
                }
            } else {
                // User is not currently following this profile
                // Create New Activity to reflect a new follow
                self.activity = [Activity object];
                self.activity[kActivityKey.fromUser]    = user;
                self.activity[kActivityKey.toUser]      = self.userView;
                self.activity[kActivityKey.type]        = kActivityType.follow;
                [user incrementKey:kSuperUserAttributeKey.followingCount byAmount:@(1)];

                [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.followButton.enabled = YES;
                    });
                }];
            }
        } else if (nil != error) {
            [self presentAlertControllerWithTitle:@"Error" message:@"Could not access the Network" andButtonName:@"Bummer!"];
        }
    }];
}


#pragma mark - segue

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
    [self setupUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UICollectionViewCell *)sender {

    if ([segue.identifier isEqualToString:@"PostDetailSegue"])
    {
        PostDetailViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.mediaCollection indexPathForCell:sender];
        vc.post = [self.userMedia objectAtIndex:indexPath.row];
    }
    
}



@end
