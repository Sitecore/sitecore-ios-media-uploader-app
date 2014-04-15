
#import <Sitecore.Mobile.MediaUploader/Data/Site/MUUploadSettingsFormatter.h>
#import <Foundation/Foundation.h>

@interface MUUploadSettingsStringFormatter : NSObject<MUUploadSettingsFormatter>

-(NSString*)formatSettings:( id<MUUploadSettings> )uploadSettings;

@end
