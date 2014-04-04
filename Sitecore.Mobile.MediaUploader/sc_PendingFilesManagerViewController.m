
//
//  sc_PendingFilesManagerViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 7/7/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_PendingFilesManagerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "sc_GlobalDataObject.h"
#import "sc_AppDelegateProtocol.h"
#import "sc_Upload2ViewController.h"
#import "sc_GradientButton.h"
#import "sc_Media.h"
#import "sc_Constants.h"
#import "sc_ResourseCleaner.h"

@interface sc_PendingFilesManagerViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation sc_PendingFilesManagerViewController
{
    sc_ResourseCleaner *_cleaner;
}

-(IBAction)removeButtonClickEvent:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];    
    CGPoint currentTouchPosition =[touch locationInView:_collectionView];
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint: currentTouchPosition];
   [self removeItem:indexPath.item];
}

-(void)removeItem:(NSInteger)index
{
    ((sc_Media* )[_appDataObject.mediaUpload objectAtIndex:index]).status = MEDIASTATUS_REMOVED;
    [_appDataObject saveMediaUpload];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];
    
    [ self checkIfUploadingAvailable ];
}



-(void)checkIfUploadingAvailable
{
    BOOL itemsForUploadingAvailable = [ _appDataObject.mediaUpload count ] > 0;
    
    if ( itemsForUploadingAvailable )
    {
        _uploadButton.hidden = NO;
    }
    else
    {
        _uploadButton.hidden = YES;
    }
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [_appDataObject.mediaUpload count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int index=indexPath.item;
    
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *cellImageView = (UIImageView *)[cell viewWithTag:100];
    cellImageView.contentMode = UIViewContentModeScaleAspectFill;

    sc_GradientButton * removeButton = (sc_GradientButton *)[cell viewWithTag:2000] ;
    [removeButton setButtonWithStyle:CUSTOMBUTTONTYPE_DANGEROUS];
    [removeButton addTarget:self action:@selector(removeButtonClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];

    //Get image thumbnails
    sc_Media * media= (sc_Media *)[_appDataObject.mediaUpload objectAtIndex:index];
    
    [cellImageView setImage:media.thumbnail];
      
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"uploadPendingMedia"])
    {
        // Obtain handles on the current and destination controllers
        sc_Upload2ViewController * destinationController = (sc_Upload2ViewController * ) segue.destinationViewController;
        [ destinationController initWithMediaItems: _appDataObject.mediaUpload
                                             image: nil
                            isPendingIemsUploading: true ];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Localize UI
    self.navigationItem.title = NSLocalizedString(self.navigationItem.title, nil);
    [_uploadButton setTitle:NSLocalizedString(_uploadButton.titleLabel.text, nil) forState:UIControlStateNormal];

    _appDataObject = [sc_GlobalDataObject getAppDataObject];
    [_uploadButton setButtonWithStyle:CUSTOMBUTTONTYPE_IMPORTANT];
    
    self->_cleaner = [ [sc_ResourseCleaner alloc] initWithDelegate: self ];
    [ self->_cleaner checkResoursesAvailability ];
    
}

-(void)cleaningComplete:(NSInteger)removedCount
{
    self->_cleaner = nil;
    [ self checkIfUploadingAvailable ];
    [ self.collectionView reloadData ];
    
    if ( removedCount > 0 )
    {
        NSString *errorText = [ NSString stringWithFormat:NSLocalizedString(@"%d items was removed from library", nil), removedCount ];
        [ sc_ErrorHelper showError: errorText ];
    }
}

@end

