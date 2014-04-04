//
//  sc_FolderHierarchy.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Steve Jennings on 7/21/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_FolderHierarchy.h"
#import "sc_QuickImageViewController.h"
#import "sc_ActivityIndicator.h"
#import "sc_Site.h"
#import "sc_Constants.h"
#import "sc_ErrorHelper.h"
#import "sc_ConnectivityHelper.h"
#import "sc_ItemHelper.h"

@interface sc_FolderHierarchy ()
@property sc_ActivityIndicator * activityIndicator;
@end

@implementation sc_FolderHierarchy

-(void)setCurrentSite:(sc_Site *)currentSite
{
    self->_currentSite = currentSite;
    [ self initializeCurrentPaths: currentSite ];
}

-(NSString *)currentPathInsideMediaLibrary
{
    if ( self->_currentPathInsideMediaLibrary == nil )
    {
        return @"";
    }
    
    return self->_currentPathInsideMediaLibrary;
}

-(void)initializeActivityIndicator
{
    _activityIndicator = [[sc_ActivityIndicator alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_activityIndicator];
}

-(void)itemTapped:(NSIndexPath *)indexPath
{
    SCItem * scItem=[self.items objectAtIndex:indexPath.row];
    
    NSString * itemType = [sc_ItemHelper itemType:scItem];
    
    if ([itemType isEqualToString:@"folder"])
    {
        [ self folderChoosenWithItem:scItem ];
    }
    else if ([itemType isEqualToString:@"image"])
    {
        [ self imageChoosenWithItem: scItem
                        atIndexPath: indexPath ];
    }
}

-(void)folderChoosenWithItem:(SCItem *)scItem
{
    self.itemId = scItem.itemId;
    [ self folderChoosenWithPath: scItem.path
                     displayName: scItem.displayName ];
}

-(void)folderChoosenWithPath:(NSString *)path displayName:(NSString *)displayName
{
    [ self setCurrentPaths: path
               displayName: displayName ];
    
    self.navigationItem.title = displayName;
 
    self.currentSite.uploadFolderPathInsideMediaLibrary = self.currentPathInsideMediaLibrary;
    
    [self readContents];
}

-(void)imageChoosenWithItem:(SCItem *)scItem atIndexPath:(NSIndexPath *)indexPath
{
    sc_QuickImageViewController *quickImageViewController = (sc_QuickImageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"sc_QuickImageViewController"];
    quickImageViewController.items = [self.items mutableCopy];
    quickImageViewController.selectedImage = indexPath.row;
    quickImageViewController.session = self.session;
    [self.navigationController pushViewController:quickImageViewController animated:YES];
}

-(void)initializeCurrentPaths: (sc_Site *) site
{
    NSString *currentFolder = site.uploadFolderPathInsideMediaLibrary;
    if ([currentFolder isEqualToString:@""])
    {
        currentFolder = [ sc_Site mediaLibraryDefaultNameWithSlash:NO ];
    }
    else
    {
        NSRange start = [currentFolder rangeOfString:@"/" options:NSBackwardsSearch];
        if (start.location != NSNotFound && start.location != 0)
        {
            currentFolder = [currentFolder substringFromIndex:start.location+1];
        }
    }
    
    _currentFolder = [currentFolder lowercaseString];
    NSString *mediafolderPath = [ sc_Site mediaLibraryDefaultNameWithSlash:YES ];
    NSString *folderPath = site.uploadFolderPathInsideMediaLibrary;
   
    _currentPathInsideSitecore = [ NSString stringWithFormat:@"%@%@", mediafolderPath, folderPath ];
    _currentPathInsideMediaLibrary = site.uploadFolderPathInsideMediaLibrary;
}

-(void)setCurrentPaths:(NSString *)path displayName:(NSString *)displayName
{
    _currentFolder = [ displayName lowercaseString ];
    
    _currentPathInsideSitecore = [ self getPathInsideSitecore: path ];
    _currentPathInsideMediaLibrary =  [ self getPathInsideMediaLibrary: _currentPathInsideSitecore ];
}

-(void)setContext
{
    _session = [sc_ItemHelper getContext: _currentSite];
}

-(void)setStartingFolder
{
   // _itemId = [ sc_Site mediaLibraryDefaultID ];
}

-(NSString *)getCurrentItemId
{
    return _itemId;
}

-(NSString *)getPathInsideSitecore:(NSString *)path
{
    return [path substringFromIndex:10];
}

-(NSString *)getPathInsideMediaLibrary:(NSString *)path
{
    NSString *parsedPath = path;
    
    NSString *mediafolderPath = [ sc_Site mediaLibraryDefaultNameWithSlash:YES ];
    
    NSRange start = [ [path lowercaseString] rangeOfString: mediafolderPath ];
    
    if (start.location != NSNotFound && start.location == 0)
    {
        parsedPath = [path substringFromIndex:start.length];
    }
    else
    {
        start = [ [path lowercaseString] rangeOfString: [ sc_Site mediaLibraryDefaultNameWithSlash: NO ] ];
        if (start.location != NSNotFound && start.location == 0)
        {
            
            parsedPath = [path substringFromIndex:start.length];
        }
    }
    
    return parsedPath;
}

-(void)readContents
{
    SCReadItemsRequest *request = [SCReadItemsRequest new];
    request.requestType = SCReadItemRequestItemId;
    request.flags = SCReadItemRequestIngnoreCache | SCReadItemRequestReadFieldsValues;
    request.fieldNames = [NSSet setWithObjects: @"__Created", nil];
    request.request = self.itemId;
    
    // NSString *rootFolderId = [ sc_Site mediaLibraryDefaultID ];
    
//    request.scope = ([ self.itemId isEqualToString: rootFolderId ]) ? SCReadItemChildrenScope : SCReadItemParentScope | SCReadItemChildrenScope ;
    
    [_activityIndicator showWithLabel:NSLocalizedString(@"Loading...", nil) afterDelay:0.5];
    
    __weak sc_FolderHierarchy *weakSelf = self;
    
    [self.session readItemsOperationWithRequest: request](^(NSArray* result, NSError *error)
    {
         [_activityIndicator hide];
        
        BOOL folderNotExists = ( !error && [result count] == 0 );
        
        if ( folderNotExists )
        {
            // NSString *rootFolderId = [ sc_Site mediaLibraryDefaultID ];
            
//            if ( [ self.itemId isEqualToString: rootFolderId ] )
//            {
//                [sc_ErrorHelper showError: NSLocalizedString(@"Server connection error", nil)];
//            }
//            else
//            {
//                [ weakSelf navigateToMediaFolderRoot ];
//            }
            
            return;
        }
        
        if ( error )
        {
            [sc_ErrorHelper showError: NSLocalizedString(@"Server connection error", nil)];
            return;
        }
        
        self.items = [self sortFolderFirst: [ result mutableCopy ] ];
        [self reloadCollection];
    });
}

-(void)navigateToMediaFolderRoot
{
   // NSString *rootFolderId = [ sc_Site mediaLibraryDefaultID ];
    NSString *mediafolderPath = [ sc_Site mediaLibraryDefaultNameWithSlash:NO ];
    
    self.currentPathInsideSitecore = mediafolderPath;
    [ self setCurrentPathLabelText ];
    
    //self.itemId = rootFolderId;
    [ self folderChoosenWithPath: nil
                     displayName: mediafolderPath ];
}

-(NSDate *)getDateFromItem:(SCItem *)item
{
    NSString * dateString = [ [ item fieldValueWithName: @"__Created" ] substringToIndex: 15 ];
    NSDateFormatter *df = [ [ NSDateFormatter alloc ] init ];
    [ df setDateFormat: @"yyyyMMdd'T'HHmmss" ];
    return [ df dateFromString: dateString ];
}

-(NSArray *)getOrderedArray:(NSArray *)array
{
    NSArray *sortedArray;
    sortedArray = [ array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first  = [ self getDateFromItem: a ];
        NSDate *second = [ self getDateFromItem: b ];
        return [ second compare: first ];
    }];
    return sortedArray;
}

-(NSMutableArray*)sortFolderFirst:(NSMutableArray *)array
{
    NSMutableArray *folderItems = [ NSMutableArray array ];
    NSMutableArray *imageItems =  [ NSMutableArray array ];
    
    SCItem *item;
    for ( item in array )
    {
        NSString * itemType = [ sc_ItemHelper itemType:item ];
        if ( [ itemType isEqualToString:@"folder" ] )
        {
            [ folderItems addObject: item ];
        }
        else if ( [ itemType isEqualToString:@"image" ] )
        {
            [ imageItems addObject: item ];
        }
    }
    
    return [ self returnRequired: folderItems
                            with: imageItems ];
}

-(NSMutableArray*)returnRequired:(NSMutableArray *)folderArray with:(NSMutableArray *)imageArray
{
    [folderArray addObjectsFromArray: [ [ self getOrderedArray:imageArray ] copy ] ];
    return folderArray;
}

-(void)reloadCollection
{
    [ self doesNotRecognizeSelector: _cmd ];
    return;
}

-(void)setCurrentPathLabelText
{
    [ self doesNotRecognizeSelector: _cmd ];
    return;
}

-(void)setDefaultSite
{
    [ self doesNotRecognizeSelector: _cmd ];
    return;
}

-(void)reloadState
{
    [self setContext];
    [self setStartingFolder];
    [self setCurrentPathLabelText];
    [self readContents];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
  
    [ self reloadState ];
}

@end
