//
//  FeedViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/27/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "FeedViewController.h"
#import "PostCollectionViewCell.h"
#import "Post.h"
#import "SuperUser.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface FeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PostCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *feedCollectionView;
@property NSMutableArray *posts;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.posts = [[NSMutableArray alloc] init];

    [self setupUI];
    [self feedQuery];
}

#pragma mark - Helper Methods
- (void) setupUI {

    [self.feedCollectionView registerNib:[UINib nibWithNibName:@"PostCell" bundle:nil] forCellWithReuseIdentifier:@"PostCell"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width);
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);

    self.feedCollectionView.collectionViewLayout = flowLayout;

//    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
//   // [query whereKey:@"author" equalTo:self.userView];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
//
//        for (Post *result in posts) {
//            [self.posts addObject:result];
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.feedCollectionView reloadData];
//        });
//    }];
}

- (void) feedQuery {
    // Query for the friends the current user is following
    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:@"Activity"];
    [followingActivitiesQuery whereKey:@"activityType" equalTo:@"follow"];
    [followingActivitiesQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];

    // Using the activities from the query above, we find all of the photos taken by
    // the friends the current user is following
    PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:@"Post"];
    [photosFromFollowedUsersQuery whereKey:@"author" matchesKey:@"toUser" inQuery:followingActivitiesQuery];
    [photosFromFollowedUsersQuery whereKeyExists:@"media"];

    // We create a second query for the current user's photos
    PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:@"Post"];
    [photosFromCurrentUserQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [photosFromCurrentUserQuery whereKeyExists:@"media"];

    // We create a final compound query that will find all of the photos that were
    // taken by the user's friends or by the user
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromFollowedUsersQuery, photosFromCurrentUserQuery, nil]];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {

        for (Post *result in posts) {
            [self.posts addObject:result];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.feedCollectionView reloadData];
        });
    }];


}

#pragma mark - Collection View

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.posts.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{


    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCell" forIndexPath:indexPath];

    cell.delegate = self;

    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [nibArray objectAtIndex:0];
    }


    Post *post = [self.posts objectAtIndex:indexPath.row] ;

    cell.post = post;
    cell.postImage.file = post.media;
    cell.heartCount.text = [NSString stringWithFormat:@"%lu", post.likesCount];

    [cell.postImage loadInBackground];
    
    return cell;
}

#pragma - mark Cell Delegate Method

- (void) didTappedCell:(PostCollectionViewCell *)cell
{
    Post *aPost;
    aPost = cell.post;

    // change heart button image
    if (cell.heartButton.selected) {
        [cell.heartButton setSelected:NO];
    } else {
        [cell.heartButton setSelected:YES];
    }

}

- (void) didTappedMore:(PostCollectionViewCell *)cell
{
    cell.moreView.hidden = NO;
}

@end
