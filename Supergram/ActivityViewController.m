//
//  ActivityViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/29/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "Post.h"
#import "Activity.h"
#import "SuperUser.h"
#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"


@interface ActivityViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *userActivities;
@property SuperUser *user;

@end

@implementation ActivityViewController

# pragma mark - View Delegates

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userActivities = [[NSMutableArray alloc] init];
    self.user = [SuperUser currentUser];
    
    // Load the activities array
    [self loadUserActivities];
   
}

# pragma mark - Helper methods

- (void)loadUserActivities
{
    
    // Make a weak pointer to prevent memory leaks
    __weak ActivityViewController *weakSelf = self;
    
    // Build the Querry and include the User and Post objects
    PFQuery *userActivitiesQuery = [PFQuery queryWithClassName:kActivityClass];
    [userActivitiesQuery setLimit: 50];
    [userActivitiesQuery includeKey:@"fromUser"];
    [userActivitiesQuery includeKey:@"Post"];
    [userActivitiesQuery includeKey:@"toUser"];
    
    // Querry the database
    [userActivitiesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            // Populate the activities array
            weakSelf.userActivities = objects.mutableCopy;
            
            // Get back to the main queue to update the user interface
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}



# pragma mark - tableView Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Dequeue a cell
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Get a pointer to the Activity
    Activity *thisActivity = [self.userActivities objectAtIndex:indexPath.row];
    
    // Set label to two lines
    cell.activityLabel.numberOfLines = 2;
    
    // Get and load the User profile pic
    cell.userImage.file = thisActivity.fromUser.profilePic;
    [cell.userImage loadInBackground];
    
    // Get the post pic and load it in the background
    // TODO Load the post pic
    if ([thisActivity.post isDataAvailable]) {
        if ([thisActivity.post.media isDataAvailable]) {
            cell.postImage.file = thisActivity.post.media;
            
            // cell.userImage.file = cell.postImage.file;
            // cell.postImage.file = cell.userImage.file;
            [cell.postImage loadInBackground];
            
        }
       
    } else if ([thisActivity.toUser isDataAvailable]) {
        if ([thisActivity.toUser.profilePic isDataAvailable]) {
            
            // Load the toUser Profile Pic
            cell.postImage.file = thisActivity.toUser.profilePic;
            [cell.postImage loadInBackground];
            
        }
    } else {
        // No image loaded
        
    }
        
    
    // Build the label string
    if ([thisActivity.activityType isEqualToString:@"post"]) {
        
        // Set the label for a post
        cell.activityLabel.text = [NSString stringWithFormat:@"%@ posted a new pic", thisActivity.fromUser.username];
        
    } else if ([thisActivity.activityType isEqualToString:@"like"]) {
        
        // Set the label for a like
        cell.activityLabel.text = [NSString stringWithFormat:@"%@ likes what \n%@ did there", thisActivity.fromUser.username, thisActivity.toUser.username];
        
    } else if ([thisActivity.activityType isEqualToString:@"follow"]) {
        
        // Set the label for a follow
        cell.activityLabel.text = [NSString stringWithFormat:@"%@ followed %@", thisActivity.fromUser.username, thisActivity.toUser.username];
        
    } else if ([thisActivity.activityType isEqualToString:@"comment"]) {
        
        // Set the label for a comment
        cell.activityLabel.text = [NSString stringWithFormat:@"%@ commented on \n%@'s post", thisActivity.fromUser.username, thisActivity.toUser.username];
        
    } else {
        // Default case
        cell.activityLabel.text = [NSString stringWithFormat:@"No one knows WTF %@ did", thisActivity.fromUser.username];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //return array count
    return self.userActivities.count;
}

@end
