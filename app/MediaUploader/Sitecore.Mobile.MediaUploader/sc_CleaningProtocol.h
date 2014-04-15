//
//  sc_CleaningProtocol.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 14/01/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol sc_CleaningProtocol <NSObject>

-(void)cleaningComplete:(NSInteger)removedCount;

@end
