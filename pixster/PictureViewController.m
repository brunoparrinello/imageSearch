//
//  PictureViewController.m
//  pixster
//
//  Created by Bruno Parrinello on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "PictureViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PictureViewController ()

- (void)onClose;

@end

@implementation PictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Image";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onClose)];
    [self.pictureImageView setImageWithURL:self.picture.pictureURL];
    self.pictureTitleLabel.text = self.picture.pictureTitle;
}

- (void)onClose {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSwipe:(id)sender {
    
}
@end
