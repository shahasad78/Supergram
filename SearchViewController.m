//
//  SearchViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/27/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "SearchViewController.h"
#import "SuperProfileViewController.h"
#import <Parse/Parse.h>
#import "SuperUser.h"

@interface SearchViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property NSMutableArray *filteredUsers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *userSearchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filteredUsers = [NSMutableArray new];
}

#pragma mark - searchBar
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.filteredUsers removeAllObjects];
    
    if ([searchBar.text length] != 0)
    {


        PFQuery *queryUsername = [PFQuery queryWithClassName:@"_User"];
        [queryUsername whereKey:@"username" containsString:searchBar.text];

        PFQuery *queryFirstname = [PFQuery queryWithClassName:@"_User"];
        [queryFirstname whereKey:@"firstName" containsString:searchBar.text];

        PFQuery *queryLastname = [PFQuery queryWithClassName:@"_User"];
        [queryLastname whereKey:@"lastName" containsString:searchBar.text];

        PFQuery *finalQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryUsername, queryFirstname, queryLastname,nil]];

        [finalQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

            for (SuperUser *user in objects) {
                [self.filteredUsers addObject:user];
                  NSLog(@"%@", user.username);
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];

    }

    [searchBar resignFirstResponder];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.filteredUsers objectAtIndex:indexPath.row] username];

    NSString *fullName = [NSString stringWithFormat:@"%@ %@", [[self.filteredUsers objectAtIndex:indexPath.row] valueForKey:@"firstName"], [[self.filteredUsers objectAtIndex:indexPath.row] valueForKey:@"lastName"]];
    cell.detailTextLabel.text = fullName;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self filteredUsers].count;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    SuperProfileViewController *vc = segue.destinationViewController;
    vc.searchedUser = [self.filteredUsers objectAtIndex:indexPath.row];
}

@end
