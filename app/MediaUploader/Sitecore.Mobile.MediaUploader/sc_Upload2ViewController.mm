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
    
    sc_BaseTheme* _theme;
    
    NSIndexPath* _processedIndexPath;
}

static NSString*  const CellIdentifier = @"cellSiteUrl";

-(IBAction)changeFilter:(UISegmentedControl*)sender
{
    switch ( sender.selectedSegmentIndex )
    {
        case 0:
        {
            [ self.appDataObject.uploadItemsManager setFilterOption: SHOW_ALL_ITEMS ];
            break;
        }
        case 1:
        {
            [ self.appDataObject.uploadItemsManager setFilterOption: SHOW_COMLETED_ITEMS ];
            break;
        }
        case 2:
        {
            [ self.appDataObject.uploadItemsManager setFilterOption: SHOW_NOT_COMLETED_ITEMS ];
            break;
        }
        default:
        {
            [ self.appDataObject.uploadItemsManager setFilterOption: SHOW_ALL_ITEMS ];
            break;
        }
    }
    
    [ self.sitesTableView reloadData ];
}

-(sc_GlobalDataObject*)appDataObject
{
    if ( self->_appDataObject == nil )
    {
        self->_appDataObject = [ sc_GlobalDataObject getAppDataObject ];
    }
    
    return self->_appDataObject;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [ self localizeFilterButtons ];
    
    self->_uploadInProgress = NO;
    
    self->_theme = [ sc_BaseTheme new ];
    
    [ self.appDataObject.uploadItemsManager setFilterOption: SHOW_ALL_ITEMS ];
    
    self->_uploadImageSize = [MUImageHelper loadUploadImageSize];
    
    //Localize UI
    self.navigationItem.title = NSLocalizedString(self.navigationItem.title, nil);

    [ _abortButton setTitle: NSLocalizedString(_abortButton.titleLabel.text, nil)
                   forState: UIControlStateNormal ];
    
    self->_uploadItemIndex = 0;
    
    [ _abortButton addTarget: self
                      action: @selector(abortButtonPressed:)
            forControlEvents: UIControlEventTouchUpInside ];
    _abortButton.enabled = NO;
    
    [ (sc_GradientButton*) _abortButton setButtonWithStyle: CUSTOMBUTTONTYPE_DANGEROUS ];
    
    self->_sitesTableView.delegate = self;
    self->_sitesTableView.dataSource = self;
    
    [ self uploadNextItem ];
}

-(IBAction)homePressed:(id)sender
{
    [ self abortButtonPressed: sender ];
    [ self.navigationController popToRootViewControllerAnimated: YES ];
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
    return  static_cast<NSInteger>( [ self.appDataObject.uploadItemsManager uploadCount ] );
}

-(MUUploadItemStatus*)statusForItemForCurrentIndexPath:(NSIndexPath*)indexPath
{
    NSInteger reversedIndex = [ self reversedIndexForIndexPath:indexPath ];
    MUMedia* media = [ self.appDataObject.uploadItemsManager mediaUploadAtIndex: reversedIndex ];
    
    return media.uploadStatusData;
}

-(UITableViewCell*)tableView:(UITableView*)tableView
       cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    sc_UploadItemCell *cell = [ self->_sitesTableView dequeueReusableCellWithIdentifier: CellIdentifier ];
    
    NSInteger reversedIndex = [ self reversedIndexForIndexPath: indexPath ];
    
    MUMedia* media = [ self.appDataObject.uploadItemsManager mediaUploadAtIndex: reversedIndex ];
    
    MUUploadItemStatus *status = media.uploadStatusData;

    [ cell.cellImageView setImage: media.thumbnail ];
    
    SCSite* siteForUpload = [ self.appDataObject.sitesManager siteBySiteId: media.siteForUploadingId ];
    
    cell.siteLabel.text   = siteForUpload.siteUrl;
    cell.folderLabel.text = [ sc_ItemHelper formatUploadFolder: siteForUpload ];
    cell.nameLabel.text = media.name;
    
    [ cell setCellStyleForUploadStatus: status
                             withTheme: self->_theme ];
    
    return cell;
}

-(NSInteger)reversedIndexForIndexPath:(NSIndexPath*)indexPath
{
    return [ self reversedIndexForIndex: indexPath.row ];
}

-(NSInteger)reversedIndexForIndex:(NSInteger)index
{
    return static_cast<NSInteger>( self.appDataObject.uploadItemsManager.uploadCount ) - static_cast<NSInteger>( index + 1 );
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MUUploadItemStatus *status = [ self statusForItemForCurrentIndexPath: indexPath ];
    
    switch ( status.statusId )
    {
        case READY_FOR_UPLOAD:
        {
            NSInteger index = [ self reversedIndexForIndexPath: indexPath ];
            [ self.appDataObject.uploadItemsManager setUploadStatus: UPLOAD_IN_PROGRESS
                                                    withDescription: nil
                                              forMediaUploadAtIndex: index ];
            [ self uploadNextItem ];
            [ self.sitesTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic ];
            break;
        }
        case UPLOAD_CANCELED:
        {
            [ self showErrorMessageWithRetryOption: status.statusDescription
                                forItemAtIndexPath: indexPath ];
            break;
        }
        case UPLOAD_ERROR:
        {
            [ self showErrorMessageWithRetryOption: status.statusDescription
                                forItemAtIndexPath: indexPath ];
            break;
        }
        case DATA_IS_NOT_AVAILABLE:
        {
            [ sc_ErrorHelper showError: status.statusDescription ];
            [ self reloadVisibleCells ];
            break;
        }
        default:
        {
            NSLog(@"item status: %@", [ @(status.statusId) descriptionWithLocale: nil ]);
            break;
        }
    }
}

-(void)showErrorMessageWithRetryOption:(NSString*)message
                    forItemAtIndexPath:(NSIndexPath*)indexPath
{
    self->_processedIndexPath = indexPath;
    UIAlertView* alert = [ [UIAlertView alloc] initWithTitle: @""
                                                     message: NSLocalizedString( message, nil )
                                                    delegate: self
                                           cancelButtonTitle: NSLocalizedString( @"OK", nil )
                                           otherButtonTitles: NSLocalizedString( @"Retry", nil ), nil ];
    [ alert show ];
}

-(void)uploadNextItem
{
    if ( !self->_uploadInProgress )
    {
        MUMedia *mediaForUpload = [ self.appDataObject.uploadItemsManager mediaUploadWithUploadStatus: UPLOAD_IN_PROGRESS ];
        if ( mediaForUpload != nil )
        {
            [ self uploadItem: mediaForUpload ];
        }
    }
}

//TODO: @igk make access to items bu item id, not by index
-(void)uploadItem:(MUMedia *)media
{
    NSInteger mediaIndex = [ self.appDataObject.uploadItemsManager indexOfMediaUpload: media ];
    [ self uploadItemAtIndex: mediaIndex ];
}

-(void)uploadItemAtIndex:(NSInteger)index
{
//    index = [ self reversedIndexForIndex: index ];

    if ( !_uploadInProgress )
    {
        MUMedia* media = [ self.appDataObject.uploadItemsManager mediaUploadAtIndex: index ];
        
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
        __block NSInteger itemIndex = [ self.appDataObject.uploadItemsManager indexOfMediaUpload: media ];
        SCSite *siteForUpload = [ self.appDataObject.sitesManager siteBySiteId: media.siteForUploadingId ];
        
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
        
        __block sc_Upload2ViewController *weakSelf = self;
        
        SCDidFinishAsyncOperationHandler doneHandler = (^( SCItem* item, NSError* error )
        {
            weakSelf->_abortButton.enabled = NO;
            if (error)
            {
                [ self.appDataObject.uploadItemsManager setUploadStatus: UPLOAD_ERROR
                                                        withDescription: error.localizedDescription
                                                  forMediaUploadAtIndex: itemIndex ];
            }
            else
            {
                [ self setFields: item
                         Context: session
                      uploadItem: uploadItem ];
                
                [ self.appDataObject.uploadItemsManager setUploadStatus: UPLOAD_DONE
                                                        withDescription: nil
                                                  forMediaUploadAtIndex: itemIndex ];
            }

            [ weakSelf itemUploadFinished ];
        });
        
        SCCancelAsyncOperationHandler cancelHandler = ^(BOOL cancelInfo)
        {
            weakSelf->_abortButton.enabled = NO;
            [ self.appDataObject.uploadItemsManager setUploadStatus: UPLOAD_CANCELED
                                                    withDescription: @"Upload was canceled"
                                              forMediaUploadAtIndex: itemIndex ];
            
            [ weakSelf itemUploadFinished ];
        };
        
        SCExtendedAsyncOp loader = [session.extendedApiSession uploadMediaOperationWithRequest:request];
    
        self->_uploadInProgress = YES;
        self->_currentCancelOp = loader( nil, cancelHandler, doneHandler );
        [ self reloadVisibleCells ];
        
        weakSelf->_abortButton.enabled = YES;
    }
    else
    {
        [ sc_ErrorHelper showError:@"Upload is pending" ];
    }
}

-(void)itemUploadFinished
{
    [ self saveUploadItemsChanges ];
    [ self reloadVisibleCells ];
    self->_uploadInProgress = NO;
    [ self uploadNextItem ];
}

-(void)reloadVisibleCells
{
    NSArray *visibleIndexPaths = self.sitesTableView.indexPathsForVisibleRows;
    [ self.sitesTableView reloadRowsAtIndexPaths: visibleIndexPaths
                                withRowAnimation: UITableViewRowAnimationAutomatic ];
}

-(void)saveUploadItemsChanges
{
    [ self.appDataObject.uploadItemsManager save ];
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
    NSInteger uploadItemsCount = static_cast<NSInteger>( [ self.appDataObject.uploadItemsManager uploadCount ] );
    
    if ( uploadItemsCount > 1)
    {
        self.navigationItem.title  = [NSString stringWithFormat:NSLocalizedString(@"Uploading  %d of %lu", nil), self->_uploadItemIndex, (unsigned long)(uploadItemsCount)];
    }
    else
    {
         self.navigationItem.title  = NSLocalizedString(@"Uploading", nil);
    }
}

-(int)uploadingFilesCount
{
    int result = static_cast<int>( [ self.appDataObject.uploadItemsManager uploadCount ] );
    
    return result;
}

-(IBAction)abortButtonPressed:(id)sender
{
    if ( self->_currentCancelOp )
    {
        self->_currentCancelOp( YES );
    }

    self.navigationItem.title = NSLocalizedString(@"Cancelled", nil);
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
    if ( self.appDataObject.isIpad )
    {
        return 100.f;
    }
    
    return 80.f;
}

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL retryButtonPressed = (buttonIndex == 1);
    if ( retryButtonPressed )
    {
#define HOTFIX_SHOW_INDICATION_IMMEDIATELY 1
#if HOTFIX_SHOW_INDICATION_IMMEDIATELY
        {
            sc_UploadItemCell* cell = (sc_UploadItemCell*)[ self.sitesTableView cellForRowAtIndexPath: self->_processedIndexPath ];
            if ( nil != cell )
            {
                NSParameterAssert( [ cell isMemberOfClass: [ sc_UploadItemCell class ] ] );
                
                MUUploadItemStatus* inProgressStatus = [ MUUploadItemStatus new ];
                inProgressStatus.statusId = UPLOAD_IN_PROGRESS;
                
                 [ cell setCellStyleForUploadStatus: inProgressStatus
                                         withTheme: self->_theme ];
            }
        }
#endif
        
        NSInteger index = [ self reversedIndexForIndexPath: self->_processedIndexPath ];
        [ self.appDataObject.uploadItemsManager setUploadStatus: UPLOAD_IN_PROGRESS
                                                withDescription: nil
                                          forMediaUploadAtIndex: index ];
        [ self uploadNextItem ];
    }
}

@end
