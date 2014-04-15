#import <Foundation/Foundation.h>

@protocol sc_CleaningProtocol;

@interface sc_ResourseCleaner : NSObject

@property (nonatomic, weak) id<sc_CleaningProtocol> delegate;

-(id)initWithDelegate:(id<sc_CleaningProtocol>)delegate;
-(void)checkResoursesAvailability;

@end
