#import <Foundation/Foundation.h>


@class SCSite;
@class NSError;


@interface SCSitesManager : NSObject

@property (nonatomic, readonly) SCSite *siteForBrowse;
@property (nonatomic, readonly) SCSite *siteForUpload;

-(BOOL)addSite:(SCSite*)site error:(NSError**)error __attribute__((nonnull));
-(SCSite*)siteAtIndex:(NSUInteger)index;

-(BOOL)removeSite:(SCSite*)site error:(NSError**)error __attribute__((nonnull));
-(BOOL)removeSiteAtIndex:(NSUInteger)index error:(NSError**)error __attribute__((nonnull));

-(NSUInteger)sitesCount;
-(NSUInteger)indexOfSite:(SCSite*)site __attribute__((nonnull));

-(BOOL)isSameSiteExist:(SCSite*)site __attribute__((nonnull));
-(NSUInteger)sameSitesCount:(SCSite*)site __attribute__((nonnull));

-(SCSite*)siteForBrowse;
-(SCSite*)siteBySiteId:(NSString*)siteId __attribute__((nonnull));

-(BOOL)saveSiteChanges:(SCSite*)site error:(NSError**)error __attribute__((nonnull));

-(BOOL)setSiteForUpload:(SCSite*)siteForUpload error:(NSError**)error __attribute__((nonnull));
-(BOOL)setSiteForBrowse:(SCSite*)siteForBrowse error:(NSError**)error __attribute__((nonnull));

-(BOOL)atLeastOneSiteExists;

@end
