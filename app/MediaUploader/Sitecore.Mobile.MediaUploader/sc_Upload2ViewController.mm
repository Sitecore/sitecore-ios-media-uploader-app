//
//  sc_Upload2ViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/20/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//
#import <ImageIO/CGImageProperties.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "sc_Upload2ViewController.h"
#import "sc_GlobalDataObject.h"
#import "sc_AppDelegateProtocol.h"
#import "sc_ReloadableViewProtocol.h"
#import "sc_Constants.h"
#import "sc_Media.h"
#import <MediaPlayer/MediaPlayer.h>
#import "sc_ViewsHelper.h"

#import "sc_GradientButton.h"
#import "sc_UploadItem.h"
#import "sc_ImageHelper.h"
#import "sc_ItemHelper.h"
#import "sc_DeviceHelper.h"

#import "sc_UploadItemCell.h"
#import "sc_UploadItemManager.h"
#import "sc_UploadItemStatus.h"
#import "sc_BaseTheme.h"

@interface sc_Upload2ViewController ()
@property (nonatomic)  NSArray* mediaItems;
@property (nonatomic) BOOL isPendingIemsUploading;
@property (nonatomic) UIImage* image;
@property (nonatomic) int uploadImageSize;

@end

typedef NS_ENUM(NSInteger, ItemsFilterMode)
{
    ShowAllFilter = 0,
    ShowCompletedItemsOnly,
    ShowNotCompletedOnly,
};

@implementation sc_Upload2ViewController
{
    SCCancelAsyncOperation _currentCancelOp;
    NSInteger _uploadItemIndex;
    sc_UploadItemManager *_statusManager;
    BOOL _uploadingInterrupted;
    
    sc_BaseTheme *_theme;
    ItemsFilterMode _currentFilterValue;
    
    NSMutableArray* _filteredItems;
}
static NSString*  const CellIdentifier = @"cellSiteUrl";

-(void)setMediaItems:(NSArray*)mediaItems
{
    self->_mediaItems = mediaItems;
    self->_filteredItems = [ NSMutableArray arrayWithArray: mediaItems ];
}

-(void) initWithMediaItems:(NSArray*)mediaItems
                      image:(UIImage*)image
     isPendingIemsUploading:(BOOL)isPendingIemsUploading
{
    self.mediaItems = [ mediaItems copy ];
    _isPendingIemsUploading = isPendingIemsUploading;
    _image = image;
}

-(IBAction)changeFilter:(UISegmentedControl*)sender
{
    ItemsFilterMode selectedIndex = static_cast<ItemsFilterMode>( sender.selectedSegmentIndex );
    
    [ self filterTableWithFilterValue: selectedIndex ];
}

-(void)filterTableWithFilterValue:(ItemsFilterMode)value
{
    self->_currentFilterValue = value;
    
    [ self->_filteredItems removeAllObjects ];
    
    NSNumber* currentNumber = nil;
    
    NSInteger mediaItemsCount = static_cast<NSInteger>( [ self.mediaItems count ] );
    
    for ( NSInteger index = 0; index < mediaItemsCount; ++index )
    {
        currentNumber = @(index);
        sc_UploadItemStatus *status = [ self->_statusManager statusForItemAtNumber: currentNumber ];
        
        if ( [ self isStatus: status matchesToFilter: self->_currentFilterValue ] )
        {
            [ self->_filteredItems addObject: [ self.mediaItems objectAtIndex:index ] ];
        }
    }
    
    [ self.sitesTableView reloadData ];
}

-(void)reloadFilteredTableData
{
    [ self filterTableWithFilterValue: self->_currentFilterValue ];
}

-(BOOL)isStatus:(sc_UploadItemStatus*)status matchesToFilter:(ItemsFilterMode)filter
{
    switch ( filter ) {
        case ShowAllFilter:
            return YES;
            break;
        case ShowCompletedItemsOnly:
            if ( status.statusId == doneStatus )
            {
                return YES;
            }
            break;
        case ShowNotCompletedOnly:
            if (   status.statusId == errorStatus
                || status.statusId == canceledStatus
                || status.statusId == inProgressStatus )
            {
                return YES;
            }
            break;
        default:
            return NO;
            break;
    }
    
    return NO;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self->_currentFilterValue = ShowAllFilter;
    
    [ self localizeFilterButtons ];
    
    self->_theme = [ sc_BaseTheme new ];
    
    _appDataObject = [sc_GlobalDataObject getAppDataObject];
    
    self->_statusManager = [ sc_UploadItemManager new ];
    self->_uploadImageSize = [sc_ImageHelper loadUploadImageSize];
    
    //Localize UI
    self.navigationItem.title = NSLocalizedString(self.navigationItem.title, nil);
    _doneButton.title = NSLocalizedString(_doneButton.title, nil);
    [ _abortButton setTitle: NSLocalizedString(_abortButton.titleLabel.text, nil)
                   forState: UIControlStateNormal ];
    
    _doneButton.enabled = false;
    self.navigationItem.hidesBackButton = YES;
    self->_uploadItemIndex = 0;
    _doneButton.target = self;
    _doneButton.action = @selector(doneButtonPushed:);
    
    [ _abortButton addTarget: self
                      action: @selector(abortButtonPressed:)
            forControlEvents: UIControlEventTouchUpInside ];
    
    _uploadingInterrupted = NO;

    [ (sc_GradientButton*) _abortButton setButtonWithStyle: CUSTOMBUTTONTYPE_DANGEROUS ];
    
    self->_sitesTableView.delegate = self;
    self->_sitesTableView.dataSource = self;
}

-(void)localizeFilterButtons
{
    [ self.filterControl setTitle: NSLocalizedString(@"ALL_ITEMS_FILTER_TITLE", nil) forSegmentAtIndex: 0 ];
    [ self.filterControl setTitle: NSLocalizedString(@"COMPLETED_ITEMS_FILTER_TITLE", nil) forSegmentAtIndex: 1 ];
    [ self.filterControl setTitle: NSLocalizedString(@"NOT_COMPLETED_ITEMS_FILTER_TITLE", nil) forSegmentAtIndex: 2 ];
}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear: animated ];
    [ self uploadNextItem ];
}

-(IBAction)doneButtonPushed:(id)sender
{
    [ self.navigationController popToRootViewControllerAnimated: YES ];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController)
    {
        [ sc_ViewsHelper reloadParentController: self.navigationController
                                         levels: 1 ];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self->_filteredItems.count;
}

-(sc_UploadItemStatus*)statusForItemForCurrentIndexPath:(NSIndexPath*)indexPath
{
    sc_Media* media = self->_filteredItems[ indexPath.row ];
    
    NSNumber* itemNumber = @([ self->_mediaItems indexOfObject: media ]);
    
    return [ self->_statusManager statusForItemAtNumber: itemNumber ];
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    sc_UploadItemCell *cell = [ _sitesTableView dequeueReusableCellWithIdentifier: CellIdentifier ];
    
    sc_UploadItemStatus *status = [ self statusForItemForCurrentIndexPath: indexPath ];
    
    sc_Media* media = self->_filteredItems[ indexPath.row ];
    
    if ( status.statusId == inProgressStatus && self->_uploadingInterrupted  )
    {
        status.statusId = canceledStatus;
    }

    [ cell.cellImageView setImage: media.thumbnail ];
    cell.siteLabel.text   = media.siteForUploading.siteUrl;
    cell.folderLabel.text = [ sc_ItemHelper formatUploadFolder: media.siteForUploading ];
    
    [ cell setCellStyleForUploadStatus: status
                             withTheme: self->_theme ];
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    sc_UploadItemStatus *status = [ self statusForItemForCurrentIndexPath: indexPath ];

    if ( status.statusId == errorStatus )
    {
        NSString* description = status.localizedDescription;
        [ sc_ErrorHelper showError: description ];
    }
    
}

-(void)uploadNextItem
{
    BOOL isItemExists = ( self->_uploadItemIndex < [_mediaItems count] );

    if ( !isItemExists )
    {
        self.navigationItem.title = NSLocalizedString(@"Uploaded", nil);
        [self uploadTerminated];
        
        return;
    }
    
    if ( !_uploadingInterrupted )
    {
        sc_Media* media = _mediaItems[self->_uploadItemIndex];
        ++self->_uploadItemIndex;
        media.status = MEDIASTATUS_PENDING;
        
        if ( [ media isVideo ] )
        {
            [ self uploadVideoWithMediaItem: media ];
        }
        else if ( [ media isImage ] )
        {
            [ self uploadImageWithMediaItem: media ];
        }
        else
        {
            [ self uploadNextItem ];
            NSLog(@"Error: no media url found:");
        }
    }
}

-(void)uploadVideoWithMediaItem:(sc_Media*)media
{
    __block NSData*data;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^void()
    {
        data = [ NSData dataWithContentsOfURL: media.videoUrl ];
    });
    sc_UploadItem * uploadItem = [ [sc_UploadItem alloc] initWithObjectData: media
                                                                       data: data ];
    
    [ self sendUploadRequest: uploadItem ];
}


-(void)uploadImageWithMediaItem:(sc_Media*)media
{
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^void(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        
        UIImageOrientation orientation = UIImageOrientationUp;
        
        
        // @apple : NSNumber containing an asset's orientation as defined by ALAssetOrientation.
        NSNumber* orientationValue = [ myasset valueForProperty: ALAssetPropertyOrientation ];
        if ( nil != orientationValue )
        {
            NSParameterAssert( [ orientationValue isKindOfClass: [ NSNumber class ] ] );
            ALAssetOrientation assetOrientation = static_cast<ALAssetOrientation>( [ orientationValue intValue ] );

            orientation = static_cast<UIImageOrientation>( assetOrientation );
        }
        
        __block NSData*data;
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^void()
        {
            
            UIImage* imageSource = [UIImage imageWithCGImage: [rep fullResolutionImage]];
            
            UIImage* image = [ sc_ImageHelper normalize: imageSource
                                         forOrientation: orientation ];
            
            UIImage* resizedImage = [ sc_ImageHelper resizeImageToSize: image
                                                       uploadImageSize: self->_uploadImageSize ];
            
            data = UIImageJPEGRepresentation(resizedImage,[sc_ImageHelper getCompressionFactor: self->_uploadImageSize]);
        });
        sc_UploadItem * uploadItem = [ [sc_UploadItem alloc] initWithObjectData: media
                                                                           data: data ];
        [ self sendUploadRequest: uploadItem ];
        
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^void(NSError* myerror)
    {
        NSLog(@"Cannot get image - %@",[myerror localizedDescription]);
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];

    [ assetslibrary assetForURL: media.imageUrl
                    resultBlock: resultblock
                   failureBlock: failureblock ];
}

-(void)sendUploadRequest:(sc_UploadItem*) uploadItem
{
    SCApiSession *session = [ sc_ItemHelper getContext: uploadItem.mediaItem.siteForUploading ];
    SCUploadMediaItemRequest *request = [SCUploadMediaItemRequest new];
    request.itemName =  uploadItem.mediaItem.name;

    if ( !uploadItem.isImage && !uploadItem.isVideo )
    {
        NSLog(@"Error: no media url found:");
        return;
    }
    
    request.fileName = uploadItem.fileName;
    request.itemTemplate = uploadItem.itemTemplate;
    request.mediaItemData = uploadItem.data;
    request.fieldNames = [NSSet new];
    request.contentType = uploadItem.contentType;
    request.folder = uploadItem.mediaItem.siteForUploading.uploadFolderPathInsideMediaLibrary;
    
    SCDidFinishAsyncOperationHandler doneHandler = (^( SCItem* item, NSError* error )
    {
        NSNumber* itemNumber = @(self->_uploadItemIndex - 1);
        
        sc_UploadItemStatus *status = [ self->_statusManager statusForItemAtNumber: itemNumber ];
        
        if (error)
        {
            uploadItem.mediaItem.status = MEDIASTATUS_ERROR;

            status.statusId = errorStatus;
            status.description = error.localizedDescription;
        }
        else
        {
            [ self setFields: item
                     Context: session
                  uploadItem: uploadItem ];
            
            uploadItem.mediaItem.status = MEDIASTATUS_UPLOADED;
            
            [ [ sc_GlobalDataObject getAppDataObject ].uploadItemsManager removeTmpVideoFileFromMediaItem: uploadItem.mediaItem ];
            
            status.statusId = doneStatus;
        }
        
        [ self uploadNextItem ];
        [ self reloadFilteredTableData ];
        
    });
    
    SCExtendedAsyncOp loader = [session.extendedApiSession uploadMediaOperationWithRequest:request];
    
    if ( !_uploadingInterrupted )
    {
        self->_currentCancelOp = loader( nil, nil, doneHandler );
    }
    
}

-(void)setFields:(SCItem*) item
         Context:(SCApiSession*) session
      uploadItem:(sc_UploadItem*) uploadItem
{
    NSSet * fieldNames = [NSSet setWithObjects:
                          @"DateTime",
                          @"Make",
                          @"Model",
                          @"Software",
                          @"Latitude",
                          @"Longitude",
                          @"LocationDescription",
                          @"CountryCode",
                          @"ZipCode",
                          nil];
    
    SCReadItemsRequest * request = [SCReadItemsRequest requestWithItemId:item.itemId fieldsNames:fieldNames];
    [session readItemsOperationWithRequest:request](^(NSArray* items, NSError*  fieldsError)
     {
         if (fieldsError)
         {
             NSLog(@"Fields error %@",[fieldsError localizedDescription]);
         }
         
         SCItem*  fieldItem = [items count] == 0 ? nil : [items lastObject];
         
         if (fieldItem)
         {
             SCField *fieldDateTime = [fieldItem fieldWithName: @"DateTime"];
             fieldDateTime.rawValue = [self getUTCFormatDate: uploadItem.mediaItem.dateTime];
             
             SCField *fieldMake = [fieldItem fieldWithName: @"Make"];
             fieldMake.rawValue = @"Apple";
             
             SCField *fieldModel = [fieldItem fieldWithName: @"Model"];
             fieldModel.rawValue = [sc_DeviceHelper getDeviceType];
             
             SCField *fieldSoftware = [fieldItem fieldWithName: @"Software"];
             fieldSoftware.rawValue = @"Sitecore Up";
             
             SCField *fieldLatitude = [fieldItem fieldWithName: @"Latitude"];
             fieldLatitude.rawValue = [uploadItem.mediaItem.latitude stringValue];
             
             SCField *fieldLongitude = [fieldItem fieldWithName: @"Longitude"];
             fieldLongitude.rawValue = [uploadItem.mediaItem.longitude stringValue];
             
             SCField *fieldLocationDescription = [fieldItem fieldWithName: @"LocationDescription"];
             fieldLocationDescription.rawValue = uploadItem.mediaItem.locationDescription;
             
             SCField *fieldCountryCode = [fieldItem fieldWithName: @"CountryCode"];
             fieldCountryCode.rawValue = uploadItem.mediaItem.countryCode;
             
             SCField *fieldCityCode = [fieldItem fieldWithName: @"ZipCode"];
             fieldCityCode.rawValue = uploadItem.mediaItem.cityCode;
             
             [fieldItem saveItemOperation] (^(SCItem*  editedItem, NSError*  fieldSaveError)
               {
                   NSLog(@"readFieldsByName: %@", editedItem.allFields);
               });
         }
     });
    
}

-(NSString*)getUTCFormatDate:(NSDate*)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

-(void)setHeader
{
    if (self->_mediaItems.count > 1)
    {
        self.navigationItem.title  = [NSString stringWithFormat:NSLocalizedString(@"Uploading  %d of %lu", nil), self->_uploadItemIndex, (unsigned long)(self->_mediaItems.count)];
    }
    else
    {
         self.navigationItem.title  = NSLocalizedString(@"Uploading", nil);
    }
}

-(void)uploadTerminated
{
    [ _appDataObject.uploadItemsManager saveMediaUpload ];

    _doneButton.enabled = YES;
    _abortButton.hidden = YES;
}

-(int)uploadingFilesCount
{
    int result = static_cast<int>( self->_mediaItems.count );
    
    return result;
}

-(IBAction)abortButtonPressed:(id)sender
{
    _uploadingInterrupted = YES;
    
    if ( self->_currentCancelOp )
    {
        self->_currentCancelOp( YES );
    }

    self.navigationItem.title = NSLocalizedString(@"Cancelled", nil);
    
    [ self uploadTerminated ];
    
    [ self reloadFilteredTableData ];
}

-(void)showUploadError
{
    UIAlertView* alert = [[ UIAlertView alloc ] initWithTitle: NSLocalizedString(@"ERROR_ALERT_TITLE", nil)
                                                      message: NSLocalizedString(@"CANT_CREATE_ERROR_TEXT", nil)
                                                     delegate: nil
                                            cancelButtonTitle: NSLocalizedString(@"OK", nil)
                                            otherButtonTitles: nil ];
    [ alert show ];
}

-(void)dealloc
{
    self->_sitesTableView.delegate = nil;
    self->_sitesTableView.dataSource = nil;
}

-(CGFloat)cellHeight
{
    if ( _appDataObject.isIpad )
    {
        return 99.f;
    }
    
    return 79.f;
}

@end
