#import "sc_QuickImageViewController.h"
#import "sc_ItemHelper.h"


@interface sc_QuickImageViewController ()
<
    UITextFieldDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@end

@implementation sc_QuickImageViewController

-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    NSUInteger currentCell = 0;
    CGFloat rawCurrentCellNumber = scrollView.contentOffset.x / scrollView.frame.size.width + 0.5f;
    if ( rawCurrentCellNumber >= 0 )
    {
        currentCell = static_cast<NSUInteger>( rawCurrentCellNumber );
    }
    
    BOOL itemExists = ( currentCell < [ self->_items count ]  );
    
    if ( itemExists )
    {
        [ self setNavBarTitleForIndex: currentCell ];
    }
}

-(void)setNavBarTitleForIndex:(NSUInteger)index
{
    SCItem* item = [ self->_items objectAtIndex: index ];
    self.navigationItem.title = item.displayName;
}

-(NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return static_cast<NSInteger>( [ self->_items count ] );
}

-(void)viewDidLayoutSubviews
{
    [ self setNavBarTitleForIndex: self->_selectedImage ];
    
    [ super viewDidLayoutSubviews ];
    
    NSInteger selectedRow = static_cast<NSInteger>( self->_selectedImage );
    NSIndexPath *indexPath = [ NSIndexPath indexPathForRow: selectedRow
                                                 inSection: 0 ];
    
    [ self.collectionView scrollToItemAtIndexPath: indexPath
                                 atScrollPosition: UICollectionViewScrollPositionCenteredHorizontally
                                         animated: NO ];
}

-(CGSize)collectionView:(UICollectionView*)collectionView
                 layout:(UICollectionViewLayout*)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return self.view.frame.size;
}

-(UICollectionViewCell*)collectionView:(UICollectionView*)collectionView
                cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger selectedCellIndex = static_cast<NSUInteger>( indexPath.row );
    SCItem*  cellObject = [ self->_items objectAtIndex: selectedCellIndex ];
    
    static NSString* identifier = @"Cell";
    UICollectionViewCell *cell = [ collectionView dequeueReusableCellWithReuseIdentifier: identifier
                                                                            forIndexPath: indexPath ];
    UIImageView *imageView = (UIImageView*)[ cell viewWithTag: 100 ];
    UIActivityIndicatorView*  cellActivityView = ( UIActivityIndicatorView* )[ cell viewWithTag: 33 ];
    cellActivityView.hidden = NO;
    [ imageView setImage: nil ];
    
    SCDownloadMediaOptions *params = [ SCDownloadMediaOptions new ];
    params.width = static_cast<float>( cell.frame.size.width );
    params.height = static_cast<float>( cell.frame.size.height );
    params.database = [ sc_ItemHelper getDefaultDatabase ];
    
    //TODO: @igk fix hardcode
    params.backgroundColor = @"white";
    NSString* itemPath = [ sc_ItemHelper getPath: cellObject.itemId ];
    
    SCExtendedAsyncOp imageReader = [ self.session.extendedApiSession downloadResourceOperationForMediaPath: itemPath
                                                                                                imageParams: params ];
    
    
    
    SCDidFinishAsyncOperationHandler onImageLoadFinished = ^void( UIImage* result, NSError* error )
    {
        cellActivityView.hidden = YES;
        
        if ( nil == error  )
        {
            NSParameterAssert( nil != result );
            NSParameterAssert( [ result isKindOfClass: [ UIImage class ] ] );

            [ imageView setContentMode: UIViewContentModeScaleToFill ];
            [ imageView setImage: result ];
        }
        else
        {
            NSParameterAssert( nil != error );
            
            sc_BaseTheme* theme = [ [ sc_BaseTheme alloc ] init ];
            UIImage* errorPlaceholder = [ theme uploadErrorIconImage ];

            [ imageView setContentMode: UIViewContentModeCenter ];
            [ imageView setImage: errorPlaceholder ];
            
            NSLog( @"[ERROR] Image download failed : %@", error );
        }
    };
    
    imageReader( nil, nil, onImageLoadFinished );

    return cell;
}

-(void)excludeFoldersFromItemsList
{
    NSMutableArray* discardedItems = [ NSMutableArray array ];
    SCItem* item = nil;
    
    for ( item in self->_items )
    {
        NSString*  itemType = [ sc_ItemHelper itemType: item ];
        if ( [ itemType isEqualToString: @"folder" ] )
        {
            [ discardedItems addObject: item ];
            --self->_selectedImage;
        }
    }

    [ self->_items removeObjectsInArray: discardedItems ];
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    [ self excludeFoldersFromItemsList ];
}

@end
