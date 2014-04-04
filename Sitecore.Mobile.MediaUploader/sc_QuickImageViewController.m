//
//  sc_QuickImageViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Steve Jennings on 6/9/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_QuickImageViewController.h"
#import "sc_ItemHelper.h"

@interface sc_QuickImageViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@end

@implementation sc_QuickImageViewController

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentCell = (int) ( scrollView.contentOffset.x / scrollView.frame.size.width + 0.5 );

    BOOL itemExists = ( currentCell < [ _items count ]  );
    
    NSLog(@"%d", currentCell);
    
    if ( itemExists )
    {
        [ self setNavBarTitleForIndex: currentCell ];
    }
}

-(void) setNavBarTitleForIndex:(int)index
{
    self.navigationItem.title = ( (SCItem *)[ _items objectAtIndex: index ] ).displayName;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

-(void)viewDidLayoutSubviews
{
    [ self setNavBarTitleForIndex: _selectedImage ];
    
    [ super viewDidLayoutSubviews ];
    
    NSIndexPath *indexPath = [ NSIndexPath indexPathForRow: _selectedImage inSection: 0 ];
    
    [ self.collectionView scrollToItemAtIndexPath: indexPath
                                 atScrollPosition: UICollectionViewScrollPositionCenteredHorizontally
                                         animated: NO ];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCItem * cellObject = [ _items objectAtIndex: indexPath.row ];
    
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [ collectionView dequeueReusableCellWithReuseIdentifier: identifier
                                                                            forIndexPath: indexPath ];
    SCImageView *imageView = (SCImageView *)[ cell viewWithTag: 100 ];
    UIActivityIndicatorView * cellActivityView = ( UIActivityIndicatorView * )[ cell viewWithTag: 33 ];
    cellActivityView.hidden = NO;
    [ imageView setImage: NULL ];
    
    SCDownloadMediaOptions *params = [ SCDownloadMediaOptions new ];
    params.width = cell.frame.size.width;
    params.height = cell.frame.size.height;
    params.database = [ sc_ItemHelper getDefaultDatabase ];
    
    NSString *itemPath = [ sc_ItemHelper getPath: cellObject.itemId ];
    
    SCAsyncOp imageReader = [ self.session downloadResourceOperationForMediaPath: itemPath
                                                                     imageParams: params ];
    
    imageReader(^( id result, NSError *error )
                {
                    if ( error == NULL )
                    {
                        cellActivityView.hidden = YES;
                        [ imageView setImage: result ];
                    }
                    else
                    {
                        NSLog( @"%@", [ error localizedDescription ] );
                    }
                });

    return cell;
}

-(void)excludeFoldersFromItemsList
{
    NSMutableArray *discardedItems = [ NSMutableArray array ];
  
    SCItem *item;
    for ( item in _items )
    {
        NSString * itemType = [ sc_ItemHelper itemType: item ];
        if ( [ itemType isEqualToString: @"folder" ] )
        {
            [ discardedItems addObject: item ];
            _selectedImage--;
        }
        else
        {
            //Folders always come first in the array, so no need to keep testing 
            break;
        }
    }

    [ _items removeObjectsInArray: discardedItems ];
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell = NULL;
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    [ self excludeFoldersFromItemsList ];
}

@end
