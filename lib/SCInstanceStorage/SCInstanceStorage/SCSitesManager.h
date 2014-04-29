#import <Foundation/Foundation.h>


@class SCSite;
@class NSError;


@interface SCSitesManager : NSObject

@property (nonatomic, readonly) SCSite *siteForBrowse;
@property (nonatomic, readonly) SCSite *siteForUpload;

-(BOOL)addSite:(SCSite*)site error:(NSError**)error;
-(SCSite*)siteAtIndex:(NSUInteger)index;

-(BOOL)removeSite:(SCSite*)site error:(NSError**)error;
-(NSUInteger)sitesCount;

-(BOOL)isSameSiteExist:(SCSite*)site;

-(SCSite*)siteForBrowse;
-(SCSite*)siteBySiteId:(NSString*)siteId;

-(BOOL)saveSiteChanges:(SCSite*)site error:(NSError**)error;

-(BOOL)setSiteForUpload:(SCSite*)siteForUpload error:(NSError**)error;
-(BOOL)setSiteForBrowse:(SCSite*)siteForBrowse error:(NSError**)error;

-(BOOL)atLeastOneSiteExists;

@end
