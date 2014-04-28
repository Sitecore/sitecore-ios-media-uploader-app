//
//  MULocationInfo.h
//  MUUploadManager
//
//  Created by Igor on 28/04/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MULocationInfo <NSObject>

-(void)setLatitude:(NSNumber*)latitude;
-(NSNumber*)latitude;

-(void)setLongitude:(NSNumber*)longitude;
-(NSNumber*)longitude;

-(void)setLocationDescription:(NSString*)locationDescription;
-(NSString*)locationDescription;

-(void)setCountryCode:(NSString*)countryCode;
-(NSString*)countryCode;

-(void)setCityCode:(NSString*)cityCode;
-(NSString*)cityCode;

@end
