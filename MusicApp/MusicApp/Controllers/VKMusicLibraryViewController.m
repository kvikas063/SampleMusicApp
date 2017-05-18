//
//  ViewController.m
//  MusicApp
//
//  Created by Vikas Kumar on 17/05/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//

#import "VKMusicLibraryViewController.h"

//Constants
#define kMusicSearchAPI @"https://itunes.apple.com/search?term=@searchText&entity=song&limit=20"
#define kSearchPlaceHolderText @"Search Music"
#define kNavigationTitleText @"Apple Music Library"

@interface VKMusicLibraryViewController ()
{
    NSArray *musicLibraryArray;
}
@end

@implementation VKMusicLibraryViewController

#pragma mark - ViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setNavigationTitleView];
    [self setupSearchBar];
    [self fetchMusicLibraryWithText:@"Bruno"];
}

-(void)dealloc{
    
    musicLibraryArray = nil;
}

#pragma mark - Private Methods

-(void)setupSearchBar{
    
    _musicSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _musicSearchBar.hidden = YES;
    _musicSearchBar.placeholder = kSearchPlaceHolderText;
    _musicSearchBar.delegate = self;
}

-(void)setNavigationTitleView{
    
    //Setup Navigation Title View
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = kNavigationTitleText;
    self.navigationItem.titleView = titleView;
}

-(void)fetchMusicLibraryWithText:(NSString*)searchText{
    
    [self addActivityIndicator];
    
    NSString *musicUrl = kMusicSearchAPI;
    musicUrl = [musicUrl stringByReplacingOccurrencesOfString:@"@searchText" withString:searchText];
    [[VKMusicLibraryDownloader sharedInstance] fetchMusicLibraryWithUrl:musicUrl withDelegate:self];
}

#pragma mark - Search Action Methods

-(IBAction)musicSearchBar:(id)sender{
    
    //Display Search Bar in Navigation Bar
    if(_musicSearchBar.isHidden){
        _musicSearchBar.hidden = NO;
        self.navigationItem.titleView = _musicSearchBar;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(musicSearchBar:)];
    }else{
        _musicSearchBar.hidden = YES;
        [self setNavigationTitleView];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(musicSearchBar:)];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self addActivityIndicator];
    [searchBar endEditing:YES];
    [self fetchMusicLibraryWithText:searchBar.text];
    searchBar.text = @"";
    [self musicSearchBar:nil];
}

#pragma mark - Activity Indicator Methods

-(void)addActivityIndicator{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.color = [UIColor blackColor];
    activityIndicator.center = CGPointMake(size.width/2, size.height/2);
    activityIndicator.tag = 1234;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
}

-(void)removeActivityIndicator{
    
    UIActivityIndicatorView *activityIndicator = [self.view viewWithTag:1234];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

#pragma mark - Operation Delegate Methods

-(void)operationDidFinish:(id)operationResult{
    
    if (operationResult) {
        musicLibraryArray = operationResult;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_musicTableView reloadData];
            [_musicTableView scrollsToTop];
            [self removeActivityIndicator];
            });
    }
}

-(void)operationDidFailed:(id)operationError{
    
    //Display Error Message
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeActivityIndicator];
    });
}


#pragma mark - TableView DataSouce Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(musicLibraryArray.count>0)
        return musicLibraryArray.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VKMusicLibraryModel *musicLibraryModel = nil;
    if(musicLibraryArray.count>0)
        musicLibraryModel = [musicLibraryArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"MusicLibraryCell";
    VKMusicLibraryTableViewCell *musicLibraryCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(musicLibraryCell==nil)
        musicLibraryCell = [[VKMusicLibraryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [musicLibraryCell configureLibraryTableViewCell:musicLibraryModel];

    if(indexPath.row > 0)
        musicLibraryCell.lineSeparatorView.hidden = NO;
    else
        musicLibraryCell.lineSeparatorView.hidden = YES;
    
    return musicLibraryCell;
}

#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VKMusicDetailViewController *musicDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VKMusicDetailViewController"];
    if(musicLibraryArray.count>0){
        musicDetailVC.musicLibraryModel = [musicLibraryArray objectAtIndex:indexPath.row];
        musicDetailVC.musicArray = musicLibraryArray;
        musicDetailVC.selectedIndex = (int)indexPath.row;
    }
    [self.navigationController pushViewController:musicDetailVC animated:YES];
}


@end
