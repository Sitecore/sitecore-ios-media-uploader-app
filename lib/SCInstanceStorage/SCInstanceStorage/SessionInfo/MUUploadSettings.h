#import <Foundation/Foundation.h>

@protocol MUUploadSettings <NSObject>


@required

/**
 Id of the site object
 */
-(NSString*)siteId;

/**
 URL of the sitecore instance
 */
-(NSString*)siteUrl;

/**
 A site from web.config.
 For example, "/sitecore/shell"
 */
-(NSString*)site;

/**
 Sitecore user and domain.
 For example "sitecore/admin"
 */
-(NSString*)username;

/**
 A relative path in the content tree
 */
-(NSString*)uploadFolderPathInsideMediaLibrary;

@optional
-(NSString*)password;

@end
