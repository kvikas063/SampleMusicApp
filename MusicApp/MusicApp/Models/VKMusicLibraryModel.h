//
//  VKMusicLibraryModel.h
//  MusicApp
//
//  Created by Vikas Kumar on 17/05/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKMusicLibraryModel : NSObject

//Class Properties
@property(nonatomic, strong)NSString *mArtistName;
@property(nonatomic, strong)NSString *mTrackName;
@property(nonatomic, strong)NSString *mTrackGenre;
@property(nonatomic, strong)NSString *mTrackTime;
@property(nonatomic, strong)NSString *mTrackImage;
@property(nonatomic, strong)NSString *mTrackPreviewUrl;

@end
