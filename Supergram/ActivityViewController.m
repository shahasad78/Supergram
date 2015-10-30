//
//  ActivityViewController.m
//  Supergram
//
//  Created by Rumiya Murtazina on 10/29/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"
#import <ParseUI/ParseUI.h>

@interface ActivityViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //return array cunt
    return 1;
}

@end
