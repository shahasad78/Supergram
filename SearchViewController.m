//
//  SearchViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/27/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "SearchViewController.h"
#import <Parse/Parse.h>
#import "SuperUser.h"

@interface SearchViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;
@property NSMutableArray *filteredUsers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *userSearchBar;
@property BOOL isSearching;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filteredUsers = [NSMutableArray new];
   // [self initializeSearchController];
}

//- (void) updateSearchResultsForSearchController:(UISearchController *)searchController
//{
//    PFQuery *query = [PFQuery queryWithClassName:@"User"];
//    [query whereKey:@"username" equalTo: searchController.searchBar.text];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
//
//        for (SuperUser *user in users) {
//            [self.filteredUsers addObject:user];
//            //  NSLog(@"%@", result.objectId);
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    }];
//}

//- (void) initializeSearchController
//{
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.definesPresentationContext = YES;
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.searchBar.placeholder = @"Search people";
//    [self.searchController.searchBar sizeToFit];
//    self.searchController.searchBar.tintColor = [UIColor whiteColor];
//    self.tableView.tableHeaderView = self.searchController.searchBar;
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.searchBar.delegate = self;
//}

#pragma mark - searchBar
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

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
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isSearching = YES;
    
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

@end
