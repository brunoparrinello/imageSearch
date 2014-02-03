//
//  PictureViewController.h
//  pixster
//
//  Created by Bruno Parrinello on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picture.h"

@interface PictureViewController : UIViewController

@property (strong, nonatomic) Picture *picture;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *pictureTitleLabel;

- (IBAction)onSwipe:(id)sender;
@end
