//
//  sc_Sites.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/17/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sc_Sites : NSObject<NSCoding> {
    NSMutableArray *sites;
}

@property(nonatomic,retain) NSMutableArray *sites;

@end
