//
//  VKMusicLibraryDownloader.h
//  MusicApp
//
//  Created by Vikas Kumar on 17/05/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

//Download Operation Protocol
@protocol VKMusicLibraryDownloaderDelegate <NSObject>

@optional
-(void)operationDidFinish:(id)operationResult;
-(void)operationDidFailed:(id)operationError;

@end

@interface VKMusicLibraryDownloader : NSObject

@property(nonatomic, strong)NSMutableArray *musicLibraryArray;

+ (instancetype)sharedInstance;
-(void)fetchMusicLibraryWithUrl:(NSString*)musicUrl withDelegate:(id<VKMusicLibraryDownloaderDelegate>)delegate;
-(void)fetchMusicImageWithUrl:(NSString*)musicUrl withDelegate:(id<VKMusicLibraryDownloaderDelegate>)delegate;

@end
