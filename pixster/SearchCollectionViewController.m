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

static NSString *GIMAGE_SEARCH_PREFIX = @"http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=";
static NSString *GIMAGE_SEARCH_RESULT_SIZE_PARAMETER = @"&rsz=";
static NSString *GIMAGE_SEARCH_RESULT_OFFSET_PARAMETER = @"&start=";

@interface SearchCollectionViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *imageSearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *imageSearchCollectionView;
@property (nonatomic, strong) NSMutableArray *imageResults;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (NSURLRequest *)constructRequest:(NSString *)queryPrefix withQueryString:(NSString *)queryString andSize:(int)responseSize startingAt:(int)start;

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
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.imageResults count];
}

#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSURLRequest *request = [self constructRequest:GIMAGE_SEARCH_PREFIX withQueryString:searchBar.text andSize:8 startingAt:0];
    
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height) {
        NSURLRequest *request = [self constructRequest:GIMAGE_SEARCH_PREFIX withQueryString:self.imageSearchBar.text andSize:8 startingAt:[self.imageResults count]];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            id results = [JSON valueForKeyPath:@"responseData.results"];
            NSLog(@"Next batch of results: %@", results);
            if ([results isKindOfClass:[NSArray class]]) {
                //[self.imageResults removeAllObjects];
                [self.imageResults addObjectsFromArray:results];
                [self.imageSearchCollectionView reloadData];
            }
        } failure:^(NSURLRequest *operation, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Failure encountered during search: %d - %@",error.code, error.description);
        }];
        
        [operation start];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //Getting size of the images
    float imageWidth = [[self.imageResults[indexPath.item] valueForKeyPath:@"width"] floatValue];
    float imageHeight = [[self.imageResults[indexPath.item] valueForKeyPath:@"height"] floatValue];

    float cellWidth = imageWidth <= 140.0 ? imageWidth+10.0 : 150.0;
    float cellHeight = imageHeight <= 140.0 ? imageHeight+10.0 : 150.0;
    
    CGSize cellSize = CGSizeMake(cellWidth, cellHeight);
    
    return cellSize;
}

# pragma mark - private methods

- (NSURLRequest *)constructRequest:(NSString *)queryPrefix withQueryString:(NSString *)queryString andSize:(int)responseSize startingAt:(int)start {
    NSString *formattedQueryString = [queryString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *resultSizeParameter = [GIMAGE_SEARCH_RESULT_SIZE_PARAMETER stringByAppendingString:[NSString stringWithFormat:@"%d",responseSize]];
    NSString *offsetParameter = [GIMAGE_SEARCH_RESULT_OFFSET_PARAMETER stringByAppendingString:[NSString stringWithFormat:@"%d",start]];
    NSString *rszStartParams = [resultSizeParameter stringByAppendingString:offsetParameter];
    NSURL *url = [NSURL URLWithString:[[queryPrefix stringByAppendingString:formattedQueryString] stringByAppendingString:rszStartParams]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"URL: %@",url);
    
        return request;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
