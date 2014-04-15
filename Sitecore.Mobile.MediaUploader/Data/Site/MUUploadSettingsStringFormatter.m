#import "MUUploadSettingsStringFormatter.h"

#import "MUUploadSettings.h"

@implementation MUUploadSettingsStringFormatter

-(NSString*)formatSettings:( id<MUUploadSettings> )uploadSettings
{
    static NSString* SITE_FORMAT =
    @"Instance      : %@ \n"
    @"Site          : %@ \n"
    @"Login         : %@ \n"
    @"Upload Folder : %@ \n";
    
    NSString* instance          = [ uploadSettings siteUrl ];
    NSString* site              = [ uploadSettings site ];
    NSString* login             = [ uploadSettings username ];
    NSString* relativeMediaPath = [ uploadSettings uploadFolderPathInsideMediaLibrary ];
    
    NSString* result = [ NSString stringWithFormat: SITE_FORMAT, instance, site, login, relativeMediaPath ];
    
    return result;
}

@end
