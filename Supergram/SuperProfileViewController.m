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
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *mediaCollection;
@property (weak, nonatomic) IBOutlet UIButton *editProfileImageBtn;
@property SuperUser *userView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editUserSettings;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property NSMutableArray *userMedia;
@end

@implementation SuperProfileViewController

#pragma mark - View Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.userView = [SuperUser currentUser];

    if (self.searchedUser != nil) {
        if (self.searchedUser != self.userView) {
            self.userView = self.searchedUser;
            self.editProfileImageBtn.hidden = true;
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    } else {
        self.editProfileImageBtn.hidden = false;
    }

    self.userMedia = [[NSMutableArray alloc] init];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.mediaCollection.frame.size.width/3 - 10, self.mediaCollection.frame.size.width/3 - 10);
    flowLayout.minimumLineSpacing = 10.0f;
    flowLayout.minimumInteritemSpacing = 10.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 5.0f, 10.0f);


//
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
    // Show the current visitor's username
    if (self.userView.username) {
        self.usernameLabel.text = self.userView.username;

        self.fullnameLabel.text = [NSString stringWithFormat:@"%@ %@", self.userView.firstName , self.userView.lastName];
    }

    if (self.userView[kSuperUserAttributeKey.profilePic]) {
        self.profileImage.file = self.userView[kSuperUserAttributeKey.profilePic];

        [self.profileImage loadInBackground];
    }

    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:self.userView];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {

        for (Post *result in posts) {
            [self.userMedia addObject:result];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mediaCollection reloadData];
        });
    }];
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
//
//    SuperUser *user = [SuperUser currentUser];
//
//    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (error) {
//            // Handle error
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                           message:@"Unable to save an error."
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay!"
//                                                               style:UIAlertActionStyleDefault
//                                                             handler:nil];
//            [alert addAction:okButton];
//
//            [self presentViewController:alert animated:YES completion:nil];
//        } else {
//            if (succeeded) {
//
//                [user incrementKey:@"postCount"];
//                [user saveInBackground];
//            }
//            
//        }
//        
//        
//    }];
//    
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
