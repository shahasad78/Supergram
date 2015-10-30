//
//  ActivityTableViewCell.h
//  Supergram
//
//  Created by Rumiya Murtazina on 10/29/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;

@end
