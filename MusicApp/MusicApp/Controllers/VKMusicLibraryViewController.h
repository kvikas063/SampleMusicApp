//
//  ViewController.h
//  MusicApp
//
//  Created by Vikas Kumar on 17/05/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

//Local Imports
#import "VKMusicLibraryDownloader.h"
#import "VKMusicLibraryTableViewCell.h"
#import "VKMusicDetailViewController.h"

@interface VKMusicLibraryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,VKMusicLibraryDownloaderDelegate>

//Outlets
@property(nonatomic, weak)IBOutlet UITableView *musicTableView;
@property(nonatomic, strong)UISearchBar *musicSearchBar;

//Action Methods
-(IBAction)musicSearchBar:(id)sender;
@end

