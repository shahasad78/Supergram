//
//  PostCollectionReusableView.h
//  Supergram
//
//  Created by Rumiya Murtazina on 10/29/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface PostCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet PFImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end
