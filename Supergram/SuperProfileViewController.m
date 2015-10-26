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
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"
#import "SuperUser.h"

@interface SuperProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *mediaCollection;
@property (weak, nonatomic) IBOutlet UIButton *editProfileImageBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *userMedia;
@end

@implementation SuperProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFUser *user = [PFUser currentUser];
     self.userMedia = [[NSMutableArray alloc] init];

    // If the current visitor is not logged in, show the login scene

    if (user == nil ) {
        [self showLogInScreen];
    }  else {

    // Show the current visitor's username
    if (user.username) {
        self.usernameLabel.text = user.username;
    }

    if (user[@"profilePic"]) {
        self.profileImage.file = user[@"profilePic"];

        [self.profileImage loadInBackground];
    }

        PFQuery *query = [PFQuery queryWithClassName:@"Post"];
        [query whereKey:@"author" equalTo:user];
        [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {

            for (Post *result in posts) {
                //Post *post;
               // post.media = [result  objectForKey:@"media"];
//                PFFile *image = [result  objectForKey:@"media"];
                [self.userMedia addObject:result];
                 NSLog(@"%@", result.objectId);
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }];

     }
}

#pragma mark - Collection View

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return self.userMedia.count;

;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{


    ThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    Post *post = [self.userMedia objectAtIndex:indexPath.row] ;


    cell.thumbnailImage.file = post.media;

   [cell.thumbnailImage loadInBackground];



    return cell;
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


@end
