#import "sc_Site.h"

@interface sc_SitesManager : NSObject

@property (nonatomic, readonly) sc_Site* siteForBrowse;
@property (nonatomic, readonly) sc_Site* siteForUpload;

-(void)addSite:(sc_Site*)site error:( NSError** )error;
-(sc_Site* )siteAtIndex:(NSUInteger)index;
-(void)removeSite:(sc_Site*)site;
-(void)removeSiteAtIndex:(NSUInteger)index;
-(NSUInteger)sitesCount;
-(NSUInteger)indexOfSite:(sc_Site*)site;

-(BOOL)saveSites;

-(BOOL)isSameSiteExist:(sc_Site*)site;
-(NSUInteger)sameSitesCount:(sc_Site*)site;

-(sc_Site* )siteForBrowse;
-(void)setSiteForUpload:(sc_Site*)siteForUpload;
-(void)setSiteForBrowse:(sc_Site*)siteForBrowse;

-(BOOL)atLeastOneSiteExists;

@end
