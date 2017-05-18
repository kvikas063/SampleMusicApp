//
//  VKMusicDetailViewController.h
//  MusicApp
//
//  Created by Vikas Kumar on 17/05/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

//Framework Imports
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

//Local Imports
#import "VKMusicLibraryModel.h"
#import "VKMusicLibraryDownloader.h"

@interface VKMusicDetailViewController : UIViewController<AVAudioPlayerDelegate,VKMusicLibraryDownloaderDelegate>

//Outlets
@property(nonatomic, weak)IBOutlet UILabel *musicTrackTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel *musicTrackArtistLabel;
@property(nonatomic, weak)IBOutlet UIImageView *musicTrackImageView;
@property(nonatomic, weak)IBOutlet UIButton *previousButton;
@property(nonatomic, weak)IBOutlet UIButton *pausePlayButton;
@property(nonatomic, weak)IBOutlet UIButton *nextButton;
@property(nonatomic, weak)IBOutlet UISlider *musicSlider;

//Action Methods
-(IBAction)pausePlayMusic:(id)sender;
-(IBAction)nextMusic:(id)sender;
-(IBAction)previousMusic:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;

//Class Properties
@property(nonatomic, assign)int selectedIndex;
@property(nonatomic, strong)NSArray *musicArray;
@property(nonatomic, strong)VKMusicLibraryModel *musicLibraryModel;

@end
