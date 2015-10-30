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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userActivities = [[NSMutableArray alloc] init];
    self.user = [SuperUser currentUser];
    
    // Load the activities array
    [self loadUserActivities];
    
    //NSLog(@"%@", self.userActivities);
   
}

# pragma mark - Helper functions

- (void)loadUserActivities
{
    // Initialize the array
    
    
    // Build the querry
    
    // Query for the friends activities
    
    // Make a weak pointer to prevent memory leaks
    __weak ActivityViewController *weakSelf = self;
    
    // Build the Querry and include the User and Post objects
    PFQuery *userActivitiesQuery = [PFQuery queryWithClassName:kActivityClass];
    [userActivitiesQuery setLimit: 50];
    [userActivitiesQuery includeKey:@"fromUser"];
    [userActivitiesQuery includeKey:@"Post"];
    
    // Querry the database
    [userActivitiesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            weakSelf.userActivities = objects.mutableCopy;
             NSLog(@"%@", self.userActivities);
            
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
    
    //Bbuild the label string
    cell.activityLabel.text = [NSString stringWithFormat:@"%@ has %@ed stuff", thisActivity.fromUser.username, thisActivity.activityType];
    
    // Get and load the User profile pic
    cell.userImage.file = thisActivity.fromUser.profilePic;
    [cell.userImage loadInBackground];
    
//    if ([thisActivity.activityType isEqualToString:@"post"]) {
//        
//        // Get the post image
//        cell.postImage.file = thisActivity.post.media;
//        [cell.postImage loadInBackground];
//    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //return array cunt
    return self.userActivities.count;
}

@end
