//
//  sc_Validator.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Steve Jennings on 8/1/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_Validator.h"

@interface sc_Validator ()
@end

@implementation sc_Validator

+(NSString*) getInvalidItemItemNameChars {

    return @"\\/:?\"<>|[]";
}

+(NSString*) proposeValidItemName:(NSString*) name withDefault:(NSString*) defaultValue {
    
	if (name.length == 0)
    {
        return defaultValue;
    }

    //Trim
    NSString*  proposedName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Remove invalid characters
    NSCharacterSet * InvalidItemNameChars = [NSCharacterSet characterSetWithCharactersInString:[self getInvalidItemItemNameChars]];
    proposedName = [[proposedName componentsSeparatedByCharactersInSet: InvalidItemNameChars] componentsJoinedByString: @""];

    //Replace remaining non alphanumeric characters with underscore
    NSMutableCharacterSet *whitelistedCharacters = [NSCharacterSet alphanumericCharacterSet];
    [whitelistedCharacters addCharactersInString:@" "];
    NSCharacterSet * charactersToRemove = [whitelistedCharacters invertedSet ] ;
    proposedName = [[proposedName componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@"_" ];
    
    
    if ([self isItemNameValid:proposedName])
    {
        return proposedName;
    }

    return defaultValue;
}

+(BOOL) isItemNameValid:(NSString*) name {
    
    return ([self getItemNameError:name].length == 0);
}

+(NSString*) getItemNameError:(NSString*) name {
    
    if (name.length == 0)
    {
        return @"AN_ITEM_NAME_MAY_NOT_BE_BLANK";
    }
   
   if ([name characterAtIndex:(name.length-1)] == '.')
    {
        return @"AN_ITEM_NAME_MAY_NOT_END_IN_A_PERIOD";
    }
    
    if (name.length != [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length)
    {
        return @"AN_ITEM_NAME_MAY_NOT_START_OR_END_WITH_BLANKS";
    }
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:[self getInvalidItemItemNameChars]];
    NSRange range = [name rangeOfCharacterFromSet:charSet];
    
    BOOL isLocationNotFound = !(range.location == NSNotFound);
    if ( isLocationNotFound )
    {
        NSString*  chars = [self getInvalidItemItemNameChars];
        return [NSString stringWithFormat:@"AN_ITEM_NAME_MAY_NOT_CONTAIN_ANY_OF_THE_FOLLOWING_CHARACTERS_%@_CONTROLLED_BY_THE_SETTING_INVALIDITEMNAMECHARS", chars];
    }
    
    
    return @"";
}

@end
