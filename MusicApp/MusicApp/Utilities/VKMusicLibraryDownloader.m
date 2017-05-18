//
//  VKMusicLibraryDownloader.m
//  MusicApp
//
//  Created by Vikas Kumar on 17/05/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//

#import "VKMusicLibraryDownloader.h"

#import "VKMusicLibraryModel.h"

@implementation VKMusicLibraryDownloader

+ (instancetype)sharedInstance
{
    static VKMusicLibraryDownloader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[VKMusicLibraryDownloader alloc] init];
    });
    return sharedInstance;
}

-(void)fetchMusicLibraryWithUrl:(NSString*)musicUrl withDelegate:(id<VKMusicLibraryDownloaderDelegate>)delegate{
    
    NSURL *url = [NSURL URLWithString:musicUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error==nil && data) {
            NSError *error=nil;
            NSDictionary *musicDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            NSArray *musicArray = [musicDictionary valueForKey:@"results"];
            if (musicArray) {
                _musicLibraryArray = [self getMusicLibraryFromDictionary:musicArray];
                if([delegate respondsToSelector:@selector(operationDidFinish:)])
                    [delegate operationDidFinish:_musicLibraryArray];
            }
        }else{
            if([delegate respondsToSelector:@selector(operationDidFailed:)])
                [delegate operationDidFailed:error];
        }
    }];
    [sessionDataTask resume];
}

-(void)fetchMusicImageWithUrl:(NSString*)musicUrl withDelegate:(id<VKMusicLibraryDownloaderDelegate>)delegate{
    
    NSURL *url = [NSURL URLWithString:musicUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error==nil && data) {
                if([delegate respondsToSelector:@selector(operationDidFinish:)])
                    [delegate operationDidFinish:data];
        }else{
            if([delegate respondsToSelector:@selector(operationDidFailed:)])
                [delegate operationDidFailed:error];
        }
    }];
    [sessionDataTask resume];
}

-(NSMutableArray*)getMusicLibraryFromDictionary:(NSArray*)musicArray{
    
    NSMutableArray *array = [NSMutableArray array];
    for(NSDictionary *dictionary in musicArray){
        if(dictionary){
            VKMusicLibraryModel* musicLibraryModel = [[VKMusicLibraryModel alloc] init];
            musicLibraryModel.mArtistName = [dictionary valueForKey:@"artistName"];
            musicLibraryModel.mTrackName = [dictionary valueForKey:@"trackName"];
            musicLibraryModel.mTrackGenre = [dictionary valueForKey:@"primaryGenreName"];
            musicLibraryModel.mTrackImage = [dictionary valueForKey:@"artworkUrl100"];
            musicLibraryModel.mTrackPreviewUrl = [dictionary valueForKey:@"previewUrl"];
            musicLibraryModel.mTrackTime = [dictionary valueForKey:@"trackTimeMillis"];
            [array addObject:musicLibraryModel];
        }
    }
    return array;
}

@end
