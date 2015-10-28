//
//  ThumbnailCollectionViewCell.h
//  Supergram
//
//  Created by Rumiya Murtazina on 10/25/15.
//  Copyright © 2015 Shotty Shack Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface ThumbnailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *thumbnailImage;

@end
