//
//  FeedViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/27/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "FeedViewController.h"
#import "PostCollectionViewCell.h"
#import "Post.h"
#import "SuperUser.h"
#import "Activity.h"

@interface FeedViewController () <UICollectionViewDataSource,
                                  UICollectionViewDelegate,
                                  UICollectionViewDelegateFlowLayout,
                                  PostCollectionViewCellDelegate>

// IBOutlet Properties
@property (weak, nonatomic) IBOutlet UICollectionView *feedCollectionView;

// Data Model
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) NSMutableArray *likes;
// Parse Properties
@property SuperUser *user;
@property Activity *activity;

@end

@implementation FeedViewController

#pragma mark - View Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.posts = [[NSMutableArray alloc] init];
    self.user = [SuperUser currentUser];

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
    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kActivityClass];
    [followingActivitiesQuery whereKey:kActivityKey.type equalTo:kActivityType.follow];
    [followingActivitiesQuery whereKey:@"fromUser" equalTo:self.user];

    // Using the activities from the query above, we find all of the photos taken by
    // the friends the current user is following
    PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:kPostClass];
    [photosFromFollowedUsersQuery whereKey:kPostAttributeKey.author matchesKey:kActivityKey.toUser inQuery:followingActivitiesQuery];
    [photosFromFollowedUsersQuery whereKeyExists:kPostAttributeKey.media];

    // We create a second query for the current user's photos
    PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:kPostClass];
    [photosFromCurrentUserQuery whereKey:kPostAttributeKey.author equalTo:self.user];
    [photosFromCurrentUserQuery whereKeyExists:kPostAttributeKey.media];

    // Fetch all the posts the current user has liked
    PFRelation *relation = [self.user relationForKey:kSuperUserAttributeKey.likedPosts];
    PFQuery *likesQuery = [relation query];
    [likesQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.likes = objects.mutableCopy;
    }];

    // We create a final compound query that will find all of the photos that were
    // taken by the user's friends or by the user
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromFollowedUsersQuery, photosFromCurrentUserQuery, nil]];
    [query includeKey:kPostAttributeKey.author];
    [query orderByDescending:kPFObjectAttributeKey.createdAt];

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
    cell.userPic.file = post.author.profilePic;
    cell.usernameLabel.text = post.author.username;
    cell.heartButton.selected = [self.likes containsObject:post];

    if (post.isFlagged) {
        // toggle "dangerous" image
        cell.dangerImage.hidden = NO;
        
        // hide moreView view
        cell.moreView.hidden = YES;
        
        // hide like more view
        cell.likeMoreView.hidden = YES;
    } else {
        
        // toggle "dangerous" image
        cell.dangerImage.hidden = YES;
        
        // show moreView view
        cell.moreView.hidden = YES;
        
        // show like more view
        cell.likeMoreView.hidden = NO;
        
    }
    
    
    [cell.postImage loadInBackground];
    
    return cell;
}

#pragma - mark Cell Delegate Method

- (void) didTappedCell:(PostCollectionViewCell *)cell
{
    Post *aPost;
    aPost = cell.post;

    cell.heartButton.selected = !cell.heartButton.selected;

    // If the cell is selected, increment the like count and post new Activity
    if (cell.heartButton.selected) {

        [aPost incrementKey:kPostAttributeKey.likesCount];
        [aPost addObject:self.user forKey:@"likes"];
        [aPost saveInBackground];

        // Add like to user's likedPosts
        PFRelation *relation = [self.user relationForKey:kSuperUserAttributeKey.likedPosts];
        [relation addObject:aPost];
        [self.user saveInBackground];

        // Save New Activity
        self.activity = [Activity object];
        self.activity[kActivityKey.fromUser]    = self.user;
        self.activity[kActivityKey.toUser]      = aPost.author;
        self.activity[kActivityKey.type]        = kActivityType.like;
        self.activity[kActivityKey.post]        = aPost;

        [self.activity saveInBackground];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:kActivityClass];
        [query whereKey:kActivityKey.fromUser equalTo:self.user];
        [query whereKey:kActivityKey.toUser equalTo:aPost.author];
        [query whereKey:kActivityKey.type equalTo:kActivityType.like];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (nil != objects) {
                if (objects > 0) {
                    for (Activity *activity in objects) {
                        [activity deleteInBackground];
                    }
                }
            }
        }];
    }

}

- (void) didTappedMore:(PostCollectionViewCell *)cell
{
    cell.moreView.hidden = NO;
}

- (void) didTappedDelete:(PostCollectionViewCell *)cell
{
    // Get a pointer to the Post object
    Post *aPost;
    aPost = cell.post;
    
    // Check to see that the user is the owner of the post
    // TODO: create an if statement to check if user is the creator
    
    // Create an array of the selected Items
    NSArray *selectedItemsIndexPaths = [self.feedCollectionView indexPathsForSelectedItems];
    
    // Remove the Post from the mutable array
    [self.posts removeObject:aPost];

    // dismiss moreView
    cell.moreView.hidden = YES;
    
    // Reload the collection view
    [self.feedCollectionView reloadData];
    
    // Remove the Post from Parse in the background
    [aPost deleteInBackground];

}

- (void) didTappedReport:(PostCollectionViewCell *)cell
{
    
    // Get a pointer to the Post object
    Post *aPost;
    aPost = cell.post;
    
    aPost.isFlagged = YES;
    
    [aPost saveInBackground];
    [self.feedCollectionView reloadData];
    
}

@end
