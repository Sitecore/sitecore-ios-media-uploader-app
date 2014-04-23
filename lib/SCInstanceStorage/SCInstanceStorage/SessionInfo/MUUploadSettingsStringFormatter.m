#import "MUUploadSettingsStringFormatter.h"

#import "MUUploadSettings.h"
#import "MUUploadSettings_Legacy.h"

@implementation MUUploadSettingsStringFormatter
{
    NSString* _rootMediaPath;
}


-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithRootMediaPath:(NSString*)rootMediaPath
{
    NSParameterAssert( nil != rootMediaPath );
    
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_rootMediaPath = rootMediaPath;
    
    return self;
}

-(NSString*)formatSettings:(id<MUUploadSettings, MUUploadSettings_Legacy> )uploadSettings
{
    static NSString* SITE_FORMAT =
        @"siteId        : %@ \n"
        @"Instance      : %@ \n"
        @"Site          : %@ \n"
        @"Login         : %@ \n"
        @"Upload Folder : %@ \n";
    
    NSString* siteId = [ uploadSettings siteId ];
    NSString* host = [ uploadSettings siteUrl ];
    NSString* urlScheme = [ uploadSettings siteProtocol ];
    NSString* instance = [ NSString stringWithFormat: @"%@%@", urlScheme, host ];

    NSString* site              = [ uploadSettings site ];
    NSString* login             = [ uploadSettings username ];
    NSString* relativeMediaPath = [ uploadSettings uploadFolderPathInsideMediaLibrary ];
    NSString* absoluteMediaPath = [ self->_rootMediaPath stringByAppendingPathComponent: relativeMediaPath ];
    
    
    NSString* result = [ NSString stringWithFormat: SITE_FORMAT, siteId, instance, site, login, absoluteMediaPath ];
    
    return result;
}

@end
