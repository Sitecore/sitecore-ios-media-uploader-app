#import <Foundation/Foundation.h>


/**
 An object that can be written to the log.
*/
@protocol MUTrackable

/**
 A message to be used for string formatting and NSLog() messages.
 
 @return Events log message.
*/
-(NSString*)description;

@end

/**
 MUTrackable that conforms to NSObject
 */
@protocol MUTrackableObject <MUTrackable, NSObject>
@end


