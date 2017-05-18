//
//  VKMusicDetailViewController.m
//  MusicApp
//
//  Created by Vikas Kumar on 17/05/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//

#import "VKMusicDetailViewController.h"

@interface VKMusicDetailViewController ()
{
    AVPlayer *musicPlayer;
    BOOL musicStatus;
}
@end

@implementation VKMusicDetailViewController

#pragma mark - ViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupControlCenterEvents];
    [self updateMusicDetailView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if(_selectedIndex == _musicArray.count-1)
        _nextButton.enabled = NO;
    else if(_selectedIndex == 0)
        _previousButton.enabled = NO;
    [self addActivityIndicator];
    if(!musicPlayer)
        [self createMusicPlayerWithUrl:_musicLibraryModel.mTrackPreviewUrl];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if(self.isMovingFromParentViewController){
        [musicPlayer pause];
        musicPlayer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [musicPlayer pause];
    musicPlayer = nil;
}

#pragma mark - Private Methods

-(void)setupControlCenterEvents{
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[[MPRemoteCommandCenter sharedCommandCenter] playCommand] addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //Play Song
        [musicPlayer play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [[[MPRemoteCommandCenter sharedCommandCenter] pauseCommand] addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //Pause Song
        [musicPlayer pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [[[MPRemoteCommandCenter sharedCommandCenter] nextTrackCommand] addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //Play Next Song
        [self nextMusic:nil];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [[[MPRemoteCommandCenter sharedCommandCenter] previousTrackCommand] addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //Play Previous Song
        [self previousMusic:nil];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

-(void)updateMusicDetailView{
    
    //Perform Initial Setup
    self.musicTrackTitleLabel.text = _musicLibraryModel.mTrackName;
    self.musicTrackArtistLabel.text = _musicLibraryModel.mArtistName;
    self.musicTrackImageView.image = [UIImage imageNamed:@"placeHolderImage"];
    self.musicSlider.maximumValue = 3+_musicLibraryModel.mTrackTime.intValue/10000;
    
    _nextButton.enabled = YES;
    _previousButton.enabled = YES;
    
    [[VKMusicLibraryDownloader sharedInstance] fetchMusicImageWithUrl:_musicLibraryModel.mTrackImage withDelegate:self];
}

-(void)createMusicPlayerWithUrl:(NSString*)musicUrl{
    
    //Create and Play Music From Url
    NSURL *url = [NSURL URLWithString:musicUrl];
    AVPlayer *player = [[AVPlayer alloc] initWithURL:url];
    NSAssert(player, @"player is nil");
    [player play];
    musicPlayer = player;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
}

- (void)updateSlider {
    // Update the slider about the music time
    
    if(musicStatus)
        return;

    [self removeActivityIndicator];
    
    //Put Animation While changing the seek bar
    [UIView beginAnimations:@"returnSliderToInitialValue" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:7];
    _musicSlider.continuous = YES;
    
    [_musicSlider setValue:CMTimeGetSeconds(musicPlayer.currentTime) animated:YES];
    
    [UIView commitAnimations];
}

#pragma mark - Operation Delegate Methods
-(void)operationDidFinish:(id)operationResult{
    
    if (operationResult) {
        UIImage *image = [UIImage imageWithData:operationResult];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.musicTrackImageView.image = image;
            [self.view setNeedsLayout];
        });
    }
}

-(void)operationDidFailed:(id)operationError{
    
    //Display Error Message
}

#pragma mark - IBAction Methods

-(IBAction)pausePlayMusic:(id)sender{
    
    if(musicPlayer.rate == 1){
        [musicPlayer pause];
        [_pausePlayButton setImage:[UIImage imageNamed:@"Play Filled-100"] forState:UIControlStateNormal];
    }else{
        [musicPlayer play];
        [_pausePlayButton setImage:[UIImage imageNamed:@"Pause Filled-100"] forState:UIControlStateNormal];
    }
    musicStatus=!musicStatus;
    //    [self.view layoutIfNeeded];
}

-(IBAction)nextMusic:(id)sender{
    
    _musicSlider.value = 0;
    _nextButton.enabled = YES;
    _previousButton.enabled = YES;
    _selectedIndex++;
    if(_selectedIndex < _musicArray.count){
        _musicLibraryModel = [_musicArray objectAtIndex:_selectedIndex];
        [self createMusicPlayerWithUrl:_musicLibraryModel.mTrackPreviewUrl];
        [self updateMusicDetailView];
    }
    if(_selectedIndex == _musicArray.count-1)
        _nextButton.enabled = NO;
    [self pausePlayMusic:nil];
}

-(IBAction)previousMusic:(id)sender{
    
    _musicSlider.value = 0;
    _nextButton.enabled = YES;
    _previousButton.enabled = YES;
    _selectedIndex--;
    if(_selectedIndex>0 && _selectedIndex <= _musicArray.count){
        _musicLibraryModel = [_musicArray objectAtIndex:_selectedIndex];
        [self createMusicPlayerWithUrl:_musicLibraryModel.mTrackPreviewUrl];
        [self updateMusicDetailView];
    }
    if(_selectedIndex == 0)
        _previousButton.enabled = NO;
    [self pausePlayMusic:nil];
}

-(IBAction)sliderValueChanged:(id)sender{
    
    musicStatus = YES;
    if(musicPlayer){
        [musicPlayer pause];
        CMTime t = CMTimeMake(_musicSlider.value,1);
        [musicPlayer seekToTime:t];
        [musicPlayer play];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            musicStatus = NO;
        });
    }
}

#pragma mark - Activity Indicator Methods

-(void)addActivityIndicator{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(size.width/2, size.height/2+70);
    activityIndicator.tag = 111;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
}

-(void)removeActivityIndicator{
    
    UIActivityIndicatorView *activityIndicator = [self.view viewWithTag:111];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}


@end
