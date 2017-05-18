//
//  VKMusicLibraryTableViewCell.h
//  MusicApp
//
//  Created by Vikas Kumar on 17/05/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

//Local Imports
#import "VKMusicLibraryModel.h"
#import "VKMusicLibraryDownloader.h"

@interface VKMusicLibraryTableViewCell : UITableViewCell<VKMusicLibraryDownloaderDelegate>

//Outlets
@property(nonatomic, weak)IBOutlet UILabel *songTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel *artistTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel *songGenreLabel;
@property(nonatomic, weak)IBOutlet UIImageView *songImageView;
@property(nonatomic, weak)IBOutlet UIView *lineSeparatorView;

//Cell Update Method
-(void)configureLibraryTableViewCell:(VKMusicLibraryModel *)musicLibraryModel;

@end
