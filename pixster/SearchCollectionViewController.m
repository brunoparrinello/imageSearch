//
//  SearchCollectionViewController.m
//  pixster
//
//  Created by Bruno Parrinello on 1/29/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "SearchCollectionViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "CustomCell.h"

@interface SearchCollectionViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *imageSearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *imageSearchCollectionView;
@property (nonatomic, strong) NSMutableArray *imageResults;

@end

@implementation SearchCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Pixster";
        self.imageResults = [NSMutableArray array];
        
        [self.imageSearchCollectionView reloadData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *customCellNib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.imageSearchCollectionView registerNib:customCellNib forCellWithReuseIdentifier:@"CustomCell"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = nil;
    [cell.imageView setImageWithURL:[NSURL URLWithString:[self.imageResults[indexPath.item] valueForKeyPath:@"url"]]];
    
//    UIImageView *imageView = nil;
//    const int IMAGE_TAG = 1;
//    if (cell == nil) {
//        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 300, 310)];
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.tag = IMAGE_TAG;
//        [cell.contentView addSubview:imageView];
//    } else {
//        imageView = (UIImageView *)[cell.contentView viewWithTag:IMAGE_TAG];
//    }
    
    // Clear the previous image
    //imageView.image = nil;
    //[imageView setImageWithURL:[NSURL URLWithString:[self.imageResults[indexPath.item] valueForKeyPath:@"url"]]];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.imageResults count];
}

#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@", [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id results = [JSON valueForKeyPath:@"responseData.results"];
        NSLog(@"%@", results);
        if ([results isKindOfClass:[NSArray class]]) {
            [self.imageResults removeAllObjects];
            [self.imageResults addObjectsFromArray:results];
            [self.imageSearchCollectionView reloadData];
        }
    } failure:^(NSURLRequest *operation, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure encountered during search: %d - %@",error.code, error.description);
    }];
    
    [operation start];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
