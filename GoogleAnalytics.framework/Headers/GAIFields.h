/*!
 @header    GAIFields.h
 @abstract  Google Analytics iOS SDK Hit Format Header
 @copyright Copyright 2013 Google Inc. All rights reserved.
 */

#import <runtime/objc-api.h>
#import <Foundation/Foundation.h>

/*!
 These fields can be used for the wire format parameter names required by
 the |GAITracker| get, set and send methods as well as the set methods in the
 |GAIDictionaryBuilder| class.
 */
OBJC_EXTERN NSString *const kGAIUseSecure;

OBJC_EXTERN NSString *const kGAIHitType;
OBJC_EXTERN NSString *const kGAITrackingId;
OBJC_EXTERN NSString *const kGAIClientId;
OBJC_EXTERN NSString *const kGAIAnonymizeIp;
OBJC_EXTERN NSString *const kGAISessionControl;
OBJC_EXTERN NSString *const kGAIScreenResolution;
OBJC_EXTERN NSString *const kGAIViewportSize;
OBJC_EXTERN NSString *const kGAIEncoding;
OBJC_EXTERN NSString *const kGAIScreenColors;
OBJC_EXTERN NSString *const kGAILanguage;
OBJC_EXTERN NSString *const kGAIJavaEnabled;
OBJC_EXTERN NSString *const kGAIFlashVersion;
OBJC_EXTERN NSString *const kGAINonInteraction;
OBJC_EXTERN NSString *const kGAIReferrer;
OBJC_EXTERN NSString *const kGAILocation;
OBJC_EXTERN NSString *const kGAIHostname;
OBJC_EXTERN NSString *const kGAIPage;
OBJC_EXTERN NSString *const kGAIDescription;  // synonym for kGAIScreenName
OBJC_EXTERN NSString *const kGAIScreenName;   // synonym for kGAIDescription
OBJC_EXTERN NSString *const kGAITitle;
OBJC_EXTERN NSString *const kGAIAppName;
OBJC_EXTERN NSString *const kGAIAppVersion;
OBJC_EXTERN NSString *const kGAIAppId;
OBJC_EXTERN NSString *const kGAIAppInstallerId;

OBJC_EXTERN NSString *const kGAIEventCategory;
OBJC_EXTERN NSString *const kGAIEventAction;
OBJC_EXTERN NSString *const kGAIEventLabel;
OBJC_EXTERN NSString *const kGAIEventValue;

OBJC_EXTERN NSString *const kGAISocialNetwork;
OBJC_EXTERN NSString *const kGAISocialAction;
OBJC_EXTERN NSString *const kGAISocialTarget;

OBJC_EXTERN NSString *const kGAITransactionId;
OBJC_EXTERN NSString *const kGAITransactionAffiliation;
OBJC_EXTERN NSString *const kGAITransactionRevenue;
OBJC_EXTERN NSString *const kGAITransactionShipping;
OBJC_EXTERN NSString *const kGAITransactionTax;
OBJC_EXTERN NSString *const kGAICurrencyCode;

OBJC_EXTERN NSString *const kGAIItemPrice;
OBJC_EXTERN NSString *const kGAIItemQuantity;
OBJC_EXTERN NSString *const kGAIItemSku;
OBJC_EXTERN NSString *const kGAIItemName;
OBJC_EXTERN NSString *const kGAIItemCategory;

OBJC_EXTERN NSString *const kGAICampaignSource;
OBJC_EXTERN NSString *const kGAICampaignMedium;
OBJC_EXTERN NSString *const kGAICampaignName;
OBJC_EXTERN NSString *const kGAICampaignKeyword;
OBJC_EXTERN NSString *const kGAICampaignContent;
OBJC_EXTERN NSString *const kGAICampaignId;

OBJC_EXTERN NSString *const kGAITimingCategory;
OBJC_EXTERN NSString *const kGAITimingVar;
OBJC_EXTERN NSString *const kGAITimingValue;
OBJC_EXTERN NSString *const kGAITimingLabel;

OBJC_EXTERN NSString *const kGAIExDescription;
OBJC_EXTERN NSString *const kGAIExFatal;

OBJC_EXTERN NSString *const kGAISampleRate;

OBJC_EXTERN NSString *const kGAIIdfa;
OBJC_EXTERN NSString *const kGAIAdTargetingEnabled;

// hit types
OBJC_EXTERN NSString *const kGAIAppView;
OBJC_EXTERN NSString *const kGAIEvent;
OBJC_EXTERN NSString *const kGAISocial;
OBJC_EXTERN NSString *const kGAITransaction;
OBJC_EXTERN NSString *const kGAIItem;
OBJC_EXTERN NSString *const kGAIException;
OBJC_EXTERN NSString *const kGAITiming;

/*!
 This class provides several fields and methods useful as wire format parameter
 names.  The methods are used for wire format parameter names that are indexed.
 */

@interface GAIFields : NSObject

/*!
 Generates the correct parameter name for a content group with an index.

 @param index the index of the content group.

 @return an NSString representing the content group parameter for the index.
 */
+ (NSString *)contentGroupForIndex:(NSUInteger)index;

/*!
 Generates the correct parameter name for a custon dimension with an index.

 @param index the index of the custom dimension.

 @return an NSString representing the custom dimension parameter for the index.
 */
+ (NSString *)customDimensionForIndex:(NSUInteger)index;

/*!
 Generates the correct parameter name for a custom metric with an index.

 @param index the index of the custom metric.

 @return an NSString representing the custom metric parameter for the index.
 */
+ (NSString *)customMetricForIndex:(NSUInteger)index;

@end
