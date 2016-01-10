//
//  IconDownloaderPhotos.h
//  HenHouse
//
//  Created by dev on 13. 6. 21..
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoListData;

@protocol IconDownloaderPhotosDelegate;

@interface IconDownloaderPhotos : NSObject
{
    id listData;
    NSIndexPath *indexPathInTableView;
    id <IconDownloaderPhotosDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) PhotoListData *listData;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, retain) id <IconDownloaderPhotosDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol IconDownloaderPhotosDelegate

- (void)imageDidLoad:(NSIndexPath *)indexPath;

@end