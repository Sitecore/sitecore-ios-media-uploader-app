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
#import <MediaPlayer/MediaPlayer.h>
#import "sc_ViewsHelper.h"

#import "sc_GradientButton.h"
#import "sc_ItemHelper.h"
#import "sc_DeviceHelper.h"

#import "sc_UploadItemCell.h"
#import "sc_BaseTheme.h"
#import "MUUploadItem.h"

@interface sc_Upload2ViewController ()

@property (nonatomic) BOOL isPendingIemsUploading;
@property (nonatomic) UIImage* image;
@property (nonatomic) MUImageQuality uploadImageSize;

@end

@implementation sc_Upload2ViewController
{
    SCCancelAsyncOperation _currentCancelOp;
    NSUInteger _uploadItemIndex;
    BOOL _uploadInProgress;
    
    sc_BaseTheme *_theme;
    MUItemsForUploadManager *_uploadManager;
}

static NSString*  const CellIdentifier = @"cellSiteUrl";

-(IBAction)changeFilter:(UISegmentedControl*)sender
{
    switch ( sender.selectedSegmentIndex ) {
        case 0:
        {
            [ self->_appDataObject.uploadItemsManager setFilterOption: SHOW_ALL_ITEMS ];
            break;
        }
        case 1:
        {
            [ self->_appDataObject.uploadItemsManager setFilterOption: SHOW_COMLETED_ITEMS ];
            break;
        }
        case 2:
        {
            [ self->_appDataObject.uploadItemsManager setFilterOption: SHOW_NOT_COMLETED_ITEMS ];
            break;
        }
        default:
        {
            [ self->_appDataObject.uploadItemsManager setFilterOption: SHOW_ALL_ITEMS ];
            break;
        }
    }
    
    [ self.sitesTableView reloadData ];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [ self localizeFilterButtons ];
    
    _uploadInProgress = NO;
    
    self->_theme = [ sc_BaseTheme new ];
    
    self->_appDataObject = [sc_GlobalDataObject getAppDataObject];
    [ self->_appDataObject.uploadItemsManager setFilterOption: SHOW_ALL_ITEMS ];
    self->_uploadManager = self->_appDataObject.uploadItemsManager;
    
    self->_uploadImageSize = [MUImageHelper loadUploadImageSize];
    
    //Localize UI
    self.navigationItem.title = NSLocalizedString(self.navigationItem.title, nil);
    _doneButton.title = NSLocalizedString(_doneButton.title, nil);
    [ _abortButton setTitle: NSLocalizedString(_abortButton.titleLabel.text, nil)
                   forState: UIControlStateNormal ];
    
    self.navigationItem.hidesBackButton = YES;
    self->_uploadItemIndex = 0;
    _doneButton.target = self;
    _doneButton.action = @selector(doneButtonPushed:);
    
    [ _abortButton addTarget: self
                      action: @selector(abortButtonPressed:)
            forControlEvents: UIControlEventTouchUpInside ];

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
    return  static_cast<NSInteger>( [ self->_appDataObject.uploadItemsManager uploadCount ] );
}

-(MUUploadItemStatus*)statusForItemForCurrentIndexPath:(NSIndexPath*)indexPath
{
    MUMedia* media = [ _appDataObject.uploadItemsManager mediaUploadAtIndex: indexPath.row ];
    return media.uploadStatusData;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    sc_UploadItemCell *cell = [ _sitesTableView dequeueReusableCellWithIdentifier: CellIdentifier ];
    
    MUMedia* media = [ _appDataObject.uploadItemsManager mediaUploadAtIndex: indexPath.row ];
    
    MUUploadItemStatus *status = media.uploadStatusData;

    [ cell.cellImageView setImage: media.thumbnail ];
    
    SCSite *siteForUpload = [ _appDataObject.sitesManager siteBySiteId: media.siteForUploadingId ];
    
    cell.siteLabel.text   = siteForUpload.siteUrl;
    cell.folderLabel.text = [ sc_ItemHelper formatUploadFolder: siteForUpload ];
    cell.nameLabel.text = media.name;
    
    [ cell setCellStyleForUploadStatus: status
                             withTheme: self->_theme ];
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MUUploadItemStatus *status = [ self statusForItemForCurrentIndexPath: indexPath ];

    switch ( status.statusId )
    {
        case READY_FOR_UPLOAD:
        {
            [ self uploadItemAtIndex: indexPath.row ];
            break;
        }
        case UPLOAD_CANCELED:
        {
            [ self uploadItemAtIndex: indexPath.row ];
            break;
        }
        case UPLOAD_ERROR:
        {
            NSString* description = NSLocalizedString(status.description, nil);
            [ sc_ErrorHelper showError: description ];
            break;
        }
        default:
        {
            NSLog(@"item status: %@", [ @(status.statusId) descriptionWithLocale: nil ]);
            break;
        }
    }
}

-(void)uploadNextItem
{
//    BOOL isItemExists = ( self->_uploadItemIndex < [_mediaItems count] );
//
//    if ( !isItemExists )
//    {
//        self.navigationItem.title = NSLocalizedString(@"Uploaded", nil);
//        [self uploadTerminated];
//        
//        return;
//    }
//    
//    if ( !_uploadingInterrupted )
//    {
//        [ self uploadItemAtIndex:  self->_uploadItemIndex ];
//        //++self->_uploadItemIndex;
//    }
}

-(void)uploadItemAtIndex:(NSInteger)index
{
    //TODO: @igk make stack of itemf for upload
    if ( !_uploadInProgress )
    {
        [ self->_uploadManager setUploadStatus: UPLOAD_IN_PROGRESS
                               withDescription: nil
                         forMediaUploadAtIndex: index ];
        
        MUMedia* media = [_appDataObject.uploadItemsManager mediaUploadAtIndex: index ];
        
        NSIndexPath *indexPath = [ NSIndexPath indexPathForItem: index
                                                      inSection: 0 ];
        
        [ self.sitesTableView reloadRowsAtIndexPaths: @[indexPath]
                                    withRowAnimation: UITableViewRowAnimationNone ];
        
        if ( [ media isVideo ] )

        {
            [ self uploadVideoWithMediaItem: media ];
        }
        else
            if ( [ media isImage ] )
            {
                [ self uploadImageWithMediaItem: media ];
            }
            else
            {
                //[ self uploadNextItem ];
                NSLog(@"Error: no media url found:");
            }
    }
    else
    {
        [ sc_ErrorHelper showError:@"Upload is pending" ];
    }
}

-(void)uploadVideoWithMediaItem:(MUMedia*)media
{
    __block NSData*data;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^void()
    {
        data = [ NSData dataWithContentsOfURL: media.videoUrl ];
    });
    MUUploadItem * uploadItem = [ [ MUUploadItem alloc ] initWithObjectData: media
                                                                     data: data ];
    
    [ self sendUploadRequest: uploadItem ];
}

-(void)uploadImageWithMediaItem:(MUMedia*)media
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
            
            UIImage* image = [ MUImageHelper normalize: imageSource
                                         forOrientation: orientation ];
            
            UIImage* resizedImage = [ MUImageHelper resizeImageToSize: image
                                                       uploadImageSize: self->_uploadImageSize ];
            
            image = nil;
            
            CGFloat resizeFactor = [ MUImageHelper getCompressionFactor: self->_uploadImageSize ];
            
            data = UIImageJPEGRepresentation( resizedImage, resizeFactor );
        });
        MUUploadItem * uploadItem = [ [MUUploadItem alloc] initWithObjectData: media
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

-(void)sendUploadRequest:(MUUploadItem*) uploadItem
{
    //TODO: @igk make stack of itemf for upload
    if ( !_uploadInProgress )
    {
        MUMedia* media = uploadItem.mediaItem;
        __block NSInteger itemIndex = [ self->_uploadManager indexOfMediaUpload: media ];
        SCSite *siteForUpload = [ _appDataObject.sitesManager siteBySiteId: media.siteForUploadingId ];
        
        SCApiSession *session = [ sc_ItemHelper getContext: siteForUpload ];
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
        request.folder = siteForUpload.uploadFolderPathInsideMediaLibrary;
        
        SCDidFinishAsyncOperationHandler doneHandler = (^( SCItem* item, NSError* error )
        {
            if (error)
            {
                [ self->_uploadManager setUploadStatus: UPLOAD_ERROR
                                       withDescription: error.description
                                 forMediaUploadAtIndex: itemIndex ];
            }
            else
            {
                [ self setFields: item
                         Context: session
                      uploadItem: uploadItem ];
                
                [ self->_uploadManager setUploadStatus: UPLOAD_DONE
                                       withDescription: nil
                                 forMediaUploadAtIndex: itemIndex ];
            }
            
            [ self saveUploadItemsChanges ];
            [ self.sitesTableView reloadData ];
            
            self->_uploadInProgress = NO;
        });
        
        SCCancelAsyncOperationHandler cancelHandler = ^(BOOL cancelInfo)
        {
            [ self->_uploadManager setUploadStatus: UPLOAD_CANCELED
                                   withDescription: nil
                             forMediaUploadAtIndex: itemIndex ];
            
            [ self saveUploadItemsChanges ];
            [ self.sitesTableView reloadData ];
            
            self->_uploadInProgress = NO;
        };
        
        SCExtendedAsyncOp loader = [session.extendedApiSession uploadMediaOperationWithRequest:request];
    
    
        self->_uploadInProgress = YES;
        self->_currentCancelOp = loader( nil, cancelHandler, doneHandler );
    }
    else
    {
        [ sc_ErrorHelper showError:@"Upload is pending" ];
    }
}

-(void)saveUploadItemsChanges
{
    [ self->_appDataObject.uploadItemsManager save ];
}

-(void)setFields:(SCItem*) item
         Context:(SCApiSession*) session
      uploadItem:(MUUploadItem*) uploadItem
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
             fieldLatitude.rawValue = [uploadItem.mediaItem.locationInfo.latitude stringValue];
             
             SCField *fieldLongitude = [fieldItem fieldWithName: @"Longitude"];
             fieldLongitude.rawValue = [uploadItem.mediaItem.locationInfo.longitude stringValue];
             
             SCField *fieldLocationDescription = [fieldItem fieldWithName: @"LocationDescription"];
             fieldLocationDescription.rawValue = uploadItem.mediaItem.locationInfo.locationDescription;
             
             SCField *fieldCountryCode = [fieldItem fieldWithName: @"CountryCode"];
             fieldCountryCode.rawValue = uploadItem.mediaItem.locationInfo.countryCode;
             
             SCField *fieldCityCode = [fieldItem fieldWithName: @"ZipCode"];
             fieldCityCode.rawValue = uploadItem.mediaItem.locationInfo.cityCode;
             
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
    NSInteger uploadItemsCount = static_cast<NSInteger>( [ _appDataObject.uploadItemsManager uploadCount ] );
    
    if ( uploadItemsCount > 1)
    {
        self.navigationItem.title  = [NSString stringWithFormat:NSLocalizedString(@"Uploading  %d of %lu", nil), self->_uploadItemIndex, (unsigned long)(uploadItemsCount)];
    }
    else
    {
         self.navigationItem.title  = NSLocalizedString(@"Uploading", nil);
    }
}

-(void)uploadTerminated
{
    _doneButton.enabled = YES;
}

-(int)uploadingFilesCount
{
    int result = static_cast<int>( [ _appDataObject.uploadItemsManager uploadCount ] );
    
    return result;
}

-(IBAction)abortButtonPressed:(id)sender
{
    if ( self->_currentCancelOp )
    {
        self->_currentCancelOp( YES );
    }

    self.navigationItem.title = NSLocalizedString(@"Cancelled", nil);
    
    [ self uploadTerminated ];
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
        return 100.f;
    }
    
    return 80.f;
}

@end
