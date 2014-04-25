#import <Foundation/Foundation.h>


@class SCSite;
@class NSError;


@interface SCSitesManager : NSObject

@property (nonatomic, readonly) SCSite *siteForBrowse;
@property (nonatomic, readonly) SCSite *siteForUpload;

-(BOOL)addSite:(SCSite*)site error:(NSError**)error;
-(SCSite*)siteAtIndex:(NSUInteger)index;

-(void)removeSite:(SCSite*)site;
-(void)removeSiteAtIndex:(NSUInteger)index;

-(NSUInteger)sitesCount;
-(NSUInteger)indexOfSite:(SCSite*)site;

-(BOOL)saveSites;

-(BOOL)isSameSiteExist:(SCSite*)site;
-(NSUInteger)sameSitesCount:(SCSite*)site;

-(SCSite*)siteForBrowse;
-(void)setSiteForUpload:(SCSite*)siteForUpload;
-(void)setSiteForBrowse:(SCSite*)siteForBrowse;

-(BOOL)atLeastOneSiteExists;

@end
