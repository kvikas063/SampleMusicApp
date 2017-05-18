//
//  VKMusicLibraryTableViewCell.m
//  MusicApp
//
//  Created by Vikas Kumar on 17/05/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//

#import "VKMusicLibraryTableViewCell.h"

@implementation VKMusicLibraryTableViewCell

#pragma mark - Cell Update Methods
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configureLibraryTableViewCell:(VKMusicLibraryModel *)musicLibraryModel{
    
    NSString *genreString = [NSString stringWithFormat:@"%@ Music",musicLibraryModel.mTrackGenre];
    self.songTitleLabel.text = musicLibraryModel.mTrackName;
    self.songGenreLabel.text = genreString;
    self.artistTitleLabel.text = musicLibraryModel.mArtistName;
    self.songImageView.image = [UIImage imageNamed:@"placeHolderImage"];
    [[VKMusicLibraryDownloader sharedInstance] fetchMusicImageWithUrl:musicLibraryModel.mTrackImage withDelegate:self];
}

#pragma mark - Operation Delegate Methods

-(void)operationDidFinish:(id)operationResult{
    
    if (operationResult) {
        UIImage *image = [UIImage imageWithData:operationResult];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.songImageView.image = image;
            [self setNeedsLayout];
        });
    }
}

-(void)operationDidFailed:(id)operationError{
    
    //Display Error Message
}

@end
