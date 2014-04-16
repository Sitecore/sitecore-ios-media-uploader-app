
#import <SCInstanceStorage/SessionInfo/MUUploadSettingsFormatter.h>
#import <Foundation/Foundation.h>

@protocol MUUploadSettings;
@protocol MUUploadSettings_Legacy;


@interface MUUploadSettingsStringFormatter : NSObject<MUUploadSettingsFormatter>


/**
 Unsupported initializer.
 
 @return nil for disabled asserts. Thows an exception otherwise.
 */
-(instancetype)init;

-(instancetype)initWithRootMediaPath:( NSString* )rootMediaPath;

-(NSString*)formatSettings:( id<MUUploadSettings, MUUploadSettings_Legacy> )uploadSettings;

@end
