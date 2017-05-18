//
//  VKMusicLibraryModel.m
//  MusicApp
//
//  Created by Vikas Kumar on 17/05/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//

#import "VKMusicLibraryModel.h"

@implementation VKMusicLibraryModel

-(instancetype)init{
    
    self = [super init];
    if (self) {
        self.mArtistName = nil;
        self.mTrackName = nil;
        self.mTrackGenre = nil;
        self.mTrackImage = nil;
        self.mTrackTime = nil;
        self.mTrackPreviewUrl = nil;
    }
    return self;
}

-(void)dealloc{
    self.mArtistName = nil;
    self.mTrackName = nil;
    self.mTrackGenre = nil;
    self.mTrackImage = nil;
    self.mTrackTime = nil;
    self.mTrackPreviewUrl = nil;
}

@end
