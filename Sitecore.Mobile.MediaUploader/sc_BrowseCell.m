//
//  sc_BrowseCell.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 03/12/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_BrowseCell.h"

@implementation sc_BrowseCell
{
    SCCancelAsyncOperation _cancelOp;
}

-(void)setCellType:(sc_CellType)cellType item:(SCItem *)item context:(SCApiContext *)context
{
    if ( self->_cancelOp )
        self->_cancelOp(YES);
    
    self.cellActivityView.hidden = YES;
    [ self.cellImageView setImage: nil ];
    self.label.text = @"";
    self.cellImageView.contentMode = UIViewContentModeCenter;
    
    switch ( cellType ) {
            
        case ArrowCellType:
            self.label.text = [ item.displayName lowercaseString ];
            [ self.cellImageView setImage:[ UIImage imageNamed: @"up.png" ] ];
            break;
            
        case FolderCellType:
            self.label.text = [ item.displayName lowercaseString ];
            [ self.cellImageView setImage: [ UIImage imageNamed: @"folder.png" ] ];
            break;
            
        case ImageCellType:
            [ self setupImageWithItem: item
                              context: context ];
            break;
            
        default:
            break;
    }

}

-(void)setupImageWithItem:(SCItem *)item context:(SCApiContext *)context
{
    self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.cellActivityView.hidden = NO;
    
    SCFieldImageParams *params = [ SCFieldImageParams new ];
    params.width = self.bounds.size.width;
    params.height = self.bounds.size.height;
    params.database = [sc_ItemHelper getDefaultDatabase];
    
    NSString *itemPath = [ sc_ItemHelper getPath: item.itemId ];
    
    SCExtendedAsyncOp imageReader = [ context.extendedApiContext imageLoaderForSCMediaPath: itemPath
                                                                               imageParams: params ];
    
    SCDidFinishAsyncOperationHandler doneHandler = (^(id result, NSError *error)
    {
        self->_cancelOp = NULL;
        
        self.cellActivityView.hidden=YES;
        
        if ( error ) {
            NSLog(@"%@",[ error localizedDescription ]);
        }
        else
        {
            [ self.cellImageView setImage: result ];
        }

    });
    
    self->_cancelOp = imageReader( nil, nil, doneHandler );
}

-(void)dealloc
{
    if ( self->_cancelOp )
        self->_cancelOp( YES );
}

@end
