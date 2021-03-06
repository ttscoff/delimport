//
//  DIFileController.h
//  delimport
//
//  Created by Ian Henderson on 28.04.05.
//  Copyright 2005 Ian Henderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DIURLKey @"URL"
#define DIDeliciousURLKey @"href"
#define DINameKey @"Name"
#define DIDeliciousNameKey @"description"
#define DIHashKey @"hash"
#define DITimeKey @"time"
#define DITagKey @"tag"

#define DIDefaultsFAILKey @"failed web page downloads"
#define DIFAILStateNumberKey @"error code"
#define DIFAILDateKey @"date"


@class WebView;
@class DIBookmarksController;



@interface DIFileController : NSObject {
	NSMutableArray * bookmarksToLoad;
	BOOL running;
	
	WebView * webView;
}

+ (NSString *) metadataPathForSubfolder: (NSString *) folderName;
+ (NSString *) bookmarkPathForHash: (NSString*) hash;
+ (NSString *) webarchivePathForHash: (NSString*) hash;
+ (NSString *) filenameExtensionForPreferredService;

- (NSDictionary*) readDictionaryForHash:(NSString*) hash;
- (void) saveDictionary:(NSDictionary *)dictionary;
- (void) saveDictionaries:(NSArray *)dictionaries;
- (void) deleteDictionaries:(NSArray *)dictionaries;

- (void) fetchWebArchiveForDictionary: (NSDictionary *) dictionary;
- (void) saveNextWebArchive;
- (void) startSavingWebArchiveFor: (NSDictionary *) dictionary;
- (void) writeWhereFromsXattrForHash: (NSString*) hash;
- (void) doneSavingWebArchiveWithStatus: (long) status;

- (BOOL)openFile:(NSString *)filename;

@end
