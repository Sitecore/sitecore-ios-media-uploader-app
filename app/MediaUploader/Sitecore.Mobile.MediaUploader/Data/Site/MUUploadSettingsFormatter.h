#import <Foundation/Foundation.h>

@protocol MUUploadSettings;


/**
 Serializes settings to some target format.
 */
@protocol MUUploadSettingsFormatter <NSObject>


/**
 Performs serialization of ulpoad settings to some target format.
 
 @param uploadSettings An object to serialize.
 
 @return Serialized data. Usually it is NSString or NSData.
 */
-(id)formatSettings:( id<MUUploadSettings> )uploadSettings;

@end
