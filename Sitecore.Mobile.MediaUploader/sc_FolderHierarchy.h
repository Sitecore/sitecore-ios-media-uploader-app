//
//  sc_FolderHierarchy.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Steve Jennings on 7/21/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sc_Site.h"

@interface sc_FolderHierarchy : UIViewController 

@property(nonatomic, strong) NSString *currentFolder;
@property(nonatomic, strong) NSString *currentPathInsideSitecore;
@property(nonatomic, strong) NSString *currentPathInsideMediaLibrary;
@property(nonatomic, strong) NSString *itemId;
@property(nonatomic, strong) NSMutableArray * items;
@property(nonatomic, strong) SCApiSession *session;
@property(nonatomic, strong) sc_Site *currentSite;
@property (nonatomic, strong) UIActivityIndicatorView * activityView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UILabel *loadingLabel;

-(void)setContext;
-(void)setStartingFolder;
-(NSString *)getCurrentItemId;
-(NSString *)getPathInsideSitecore: (NSString *) path;
-(NSString *)getPathInsideMediaLibrary: (NSString *) path;
-(void)readContents;
-(void)setCurrentPathLabelText;
-(void)itemTapped:(NSIndexPath *)indexPath;
-(void)initializeActivityIndicator;
-(void)initializeCurrentPaths: (sc_Site *) site;
-(void)reloadState;
-(void)folderChoosenWithPath:(NSString *)path displayName:(NSString *)displayName;
-(void)navigateToMediaFolderRoot;
-(void)setCurrentPaths:(NSString *)path displayName:(NSString *)displayName;

@end







