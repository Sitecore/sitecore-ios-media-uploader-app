#import <Foundation/Foundation.h>


@class SCSite;
@class NSError;


@interface SCSitesManager : NSObject

+(instancetype)new  __attribute__(( unavailable("Unsupported initializer") ));
-(instancetype)init __attribute__(( unavailable("Unsupported initializer") ));

/**
 
 @param rootDir A full path to the directory for storing list of connection records in.
 For example, "/PATH/TO/MediaUploaderSandbox/Documents/v1.1"
 
 @return A properly initialized object.
 */
-(instancetype)initWithCacheFilesRootDirectory:( NSString* )rootDir __attribute__((nonnull));


@property (nonatomic, readonly) SCSite *siteForBrowse;
@property (nonatomic, readonly) SCSite *siteForUpload;

-(BOOL)addSite:(SCSite*)site error:(NSError**)error __attribute__((nonnull));
-(SCSite*)siteAtIndex:(NSUInteger)index;

-(BOOL)removeSite:(SCSite*)site error:(NSError**)error __attribute__((nonnull));
-(NSUInteger)sitesCount __attribute__((const));

-(BOOL)isSameSiteExist:(SCSite*)site __attribute__((nonnull));

-(SCSite*)siteForBrowse;
-(SCSite*)siteBySiteId:(NSString*)siteId __attribute__((nonnull));

-(BOOL)saveSiteChanges:(SCSite*)site error:(NSError**)error __attribute__((nonnull));

-(BOOL)setSiteForUpload:(SCSite*)siteForUpload error:(NSError**)error __attribute__((nonnull));
-(BOOL)setSiteForBrowse:(SCSite*)siteForBrowse error:(NSError**)error __attribute__((nonnull));

-(BOOL)atLeastOneSiteExists;

@end
