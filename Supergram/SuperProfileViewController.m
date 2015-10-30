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
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

// Data Model properties
@property NSMutableArray *userMedia;

// Parse properties
@property SuperUser *user;
@property Activity *activity;
@property SuperUser *userView;
@property NSUInteger userViewFollowerCount;
@property NSUInteger userViewFollowingCount;

@end

@implementation SuperProfileViewController

#pragma mark - View Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.user     = [SuperUser currentUser];
    self.userView = [SuperUser currentUser];

    self.userMedia = [[NSMutableArray alloc] init];

    // Set up Collection View
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width/3 - 10, self.view.frame.size.width/3 - 10);
    flowLayout.minimumLineSpacing = 5.0f;
    flowLayout.minimumInteritemSpacing = 5.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);

    self.mediaCollection.collectionViewLayout = flowLayout;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // If the current visitor is not logged in, show the login scene
    if (nil == self.userView) {
        [self showLogInScreen];
    } else {
        [self setupUI];
    }
}

#pragma mark - Helper Methods
- (void) setupUI {
    [self.userMedia removeAllObjects];
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
    // Show the current profile pic
    if (self.userView[kSuperUserAttributeKey.profilePic]) {
        self.profileImage.file = self.userView[kSuperUserAttributeKey.profilePic];
        [self.profileImage loadInBackground];
    }

    // Show the current visitor's username
    self.navigationItem.title = self.userView.username;

    // Show the  current visitor's bio
    self.bioLabel.text = self.userView.bio;

    // Update the FollowerCount Label
    self.followerCountLabel.text = (self.userView.followerCount) ? [@(self.userView.followerCount.integerValue) stringValue] : [@(0) stringValue];

    // Update the Following Count label
    self.followingCountLabel.text = (self.userView.followingCount) ? [@(self.userView.followingCount.integerValue) stringValue] : [@(0) stringValue];

    // Load the profile posts
    // -------------------------------------------------------------------------------------------------
    __weak SuperProfileViewController *weakSelf = self;
    PFQuery *query = [PFQuery queryWithClassName:kPostClass];
    [query whereKey:kPostAttributeKey.author equalTo:self.userView];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {

        for (Post *result in posts) {
            [weakSelf.userMedia addObject:result];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.mediaCollection reloadData];
            weakSelf.postCountLabel.text = [@(weakSelf.userMedia.count) stringValue];
        });
    }];
    // *************************************************************************************************

    // Follow Activity
    // -------------------------------------------------------------------------------------------------
    query = [PFQuery queryWithClassName:kActivityClass];
    [query whereKey:kActivityKey.fromUser equalTo:self.user];
    [query whereKey:kActivityKey.toUser equalTo:self.userView];
    [query whereKey:kActivityKey.type equalTo:kActivityType.follow];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (nil != objects && !error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.followButton.selected = (objects.count > 0);
                [weakSelf.mediaCollection reloadData];
            });
        }
    }];

    query = [PFQuery queryWithClassName:kActivityClass];
    [query whereKey:kActivityKey.fromUser equalTo:self.userView];
    [query whereKey:kActivityKey.type equalTo:kActivityType.follow];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {
            weakSelf.userViewFollowingCount = objects.count;
            weakSelf.followingCountLabel.text = [@(weakSelf.userViewFollowingCount) stringValue];
        }
    }];
    query = [PFQuery queryWithClassName:kActivityClass];
    [query whereKey:kActivityKey.toUser equalTo:self.userView];
    [query whereKey:kActivityKey.type equalTo:kActivityType.follow];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {
            weakSelf.userViewFollowerCount = objects.count;
            weakSelf.followerCountLabel.text = [@(weakSelf.userViewFollowerCount) stringValue];
        }
    }];
    // *************************************************************************************************


}

- (void)updateLabels {;
    PFQuery *followerCountQuery  =[PFQuery queryWithClassName:kActivityClass];
    [followerCountQuery whereKey:kActivityKey.toUser equalTo:self.userView];
    [followerCountQuery whereKey:kActivityKey.type equalTo:kActivityType.follow];
    [followerCountQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {

            dispatch_async(dispatch_get_main_queue(), ^{
                self.followerCountLabel.text = [@(objects.count) stringValue];
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

    __weak SuperProfileViewController *weakSelf = self;
    PFQuery *query = [PFQuery queryWithClassName:kActivityClass];
    [query whereKey:kActivityKey.fromUser equalTo:[SuperUser currentUser]];
    [query whereKey:kActivityKey.toUser equalTo:self.userView];
    [query whereKey:kActivityKey.type equalTo:kActivityType.follow];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects != nil) {
            if (objects.count > 0) {
                // User is currently following this profile. Unfollow and remove from activity feed
                for (Activity *object in objects) {
                    user.followingCount         = @(user.followingCount.integerValue - 1);
                    [user saveInBackground];
//                    weakSelf.followingCountLabel.text = [@(weakSelf.userView.followingCount.integerValue) stringValue];
//                    weakSelf.followerCountLabel.text = [@(weakSelf.userView.followerCount.integerValue) stringValue];

                    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (error) {
                            [self presentAlertControllerWithTitle:@"Error" message:@"Could not Authenticate unfollow" andButtonName:@"Are you kidding me?"];
                        }
                        weakSelf.followButton.enabled = YES;
                        [self updateLabels];

                    }];
                }
            } else {
                // User is not currently following this profile
                // Create New Activity to reflect a new follow
                weakSelf.activity = [Activity object];
                weakSelf.activity[kActivityKey.fromUser]    = user;
                weakSelf.activity[kActivityKey.toUser]      = weakSelf.userView;
                weakSelf.activity[kActivityKey.type]        = kActivityType.follow;

                // Increment respective follower and following counts
                user.followingCount = @(user.followingCount.integerValue + 1);
                [user saveInBackground];
                self.followerCountLabel.text = [@(weakSelf.userView.followerCount.integerValue + 1) stringValue];

                [weakSelf.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error) {
                        [self presentAlertControllerWithTitle:@"Error" message:@"Cannot authenticate User." andButtonName:@"Aww Phooey!"];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self updateLabels];
                        weakSelf.followButton.enabled = YES;
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
   // [self setupUI];
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
