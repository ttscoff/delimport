//
//  KeychainSearchTester.m
//  Keychain
//
//  Created by Wade Tregaskis on Sun Jun 11 2006.
//
//  Copyright (c) 2006 - 2007, Wade Tregaskis.  All rights reserved.
//  Redistribution and use in source and binary forms, with or without creation, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of Wade Tregaskis nor the names of any other contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Keychain/Keychain.h>
#import <Keychain/KeychainSearch.h>
#import <Keychain/SecurityUtils.h>

#import "TestingCommon.h"

// For pre-10.5 SDKs:
#ifndef NSINTEGER_DEFINED
typedef long NSInteger;
typedef unsigned long NSUInteger;
#define NSINTEGER_DEFINED
#endif

void template_searchByAttributeWithObjectValue(NSString *attributeName, SEL keychainItemGetter, SEL keychainSearchSetter, BOOL exhaustive) {
	KeychainSearch *search;
    NSArray *results;
    const char *attributeNameUTF8String = [attributeName UTF8String];
	
    START_TEST(attributeNameUTF8String);
	
    search = [KeychainSearch keychainSearchWithKeychains:nil];
    
    TEST(nil != (results = [search anySearchResults]), "Able to obtain results from blanket search (i.e. list)");
    
    if (nil != results) {
        TEST(0 < [results count], "\tHave at least one result");
        
        if (0 < [results count]) {
            NSUInteger currentIndex, originalIndex;
			KeychainItem *selection;
            id selectionsAttributeValue;
			
			if (exhaustive) {
				currentIndex = originalIndex = 0;
			}
			
			do {
				if (exhaustive) {
					do {						
						selectionsAttributeValue = [selection performSelector:keychainItemGetter];
						
						if (nil == selectionsAttributeValue) {
							currentIndex = (currentIndex + 1) % [results count];
						}
					} while ((nil == selectionsAttributeValue) && (currentIndex != originalIndex));
				} else {
					currentIndex = originalIndex = random() % [results count];
					
					do {
						selection = [results objectAtIndex:currentIndex];
						currentIndex = (currentIndex + 1) % [results count];
						
						selectionsAttributeValue = [selection performSelector:keychainItemGetter];
					} while ((nil == selectionsAttributeValue) && (currentIndex != originalIndex));
				}
				
				if (nil == selectionsAttributeValue) {
					TEST_NOTE("Cannot find suitable test data (item with non-nil %s).", attributeNameUTF8String);
				} else {
					TEST_NOTE("%s element at index %lu", (exhaustive ? "Testing" : "Randomly chose"), currentIndex - 1);
					
					TEST_NOTE("\tItem is: %s", [[selection description] UTF8String]);
					
					TEST_NOTE("\tItem's %s is: %s", attributeNameUTF8String, [[selectionsAttributeValue description] UTF8String]);
					
					[search performSelector:keychainSearchSetter withObject:selectionsAttributeValue];
					
					TEST_NOTE("\tSearch predicate: %s", [[[search predicate] description] UTF8String]);
					
					NSArray *refinedResults;
					
					TEST(nil != (refinedResults = [search anySearchResults]), "Able to refine search based on %s", attributeNameUTF8String);
					
					if (nil != refinedResults) {
						TEST(0 < [refinedResults count], "There is at least one result from refined search");
						
						if (0 < [refinedResults count]) {
							NSEnumerator *enumerator = [refinedResults objectEnumerator];
							KeychainItem *current;
							BOOL allHaveSameValue = YES;
							BOOL amMissingResults = NO;
							id currentsValue;
							
							while (current = [enumerator nextObject]) {
								currentsValue = [current performSelector:keychainItemGetter];
								
								if (![selectionsAttributeValue isEqualTo:currentsValue]) {
									allHaveSameValue = NO;
									
									TEST_NOTE("\tRefined result with different %s (value is %s): %s", attributeNameUTF8String, [[currentsValue description] UTF8String], [[current description] UTF8String]);
								}
							}
							
							TEST(allHaveSameValue, "All results have the expected %s", attributeNameUTF8String);
							
							enumerator = [results objectEnumerator];
							
							while (current = [enumerator nextObject]) {
								currentsValue = [current performSelector:keychainItemGetter];
								
								if ([selectionsAttributeValue isEqualTo:currentsValue]) {
									if (![refinedResults containsObject:current]) {
										amMissingResults = YES;
										
										TEST_NOTE("\tMissing result: %s", [[current description] UTF8String]);
									}
								}
							}
							
							TEST(!amMissingResults, "All expected results were returned");
						}
					}
					
					if (exhaustive) {
						currentIndex = (currentIndex + 1) % [results count];
					}
				}
			} while (exhaustive && (currentIndex != originalIndex));
        }
    }
    
    END_TEST();
}

#define template_searchByAttributeWithPrimitiveType(/* NSString* */ attributeName, KEYCHAINITEM_GETTER, KEYCHAINSEARCH_SETTER, exhaustive, PRIMITIVE_TYPE, PRIMITIVE_TYPE_FORMATTER, PRIMITIVE_TYPE_CAST) { \
    KeychainSearch *search; \
    NSArray *results; \
	const char *attributeNameUTF8String = [attributeName UTF8String]; \
    \
    START_TEST(attributeNameUTF8String); \
    \
    search = [KeychainSearch keychainSearchWithKeychains:nil]; \
    \
    TEST(nil != (results = [search anySearchResults]), "Able to obtain results from blanket search (i.e. list)"); \
	\
    if (nil != results) { \
        TEST(0 < [results count], "\tHave at least one result"); \
        \
        if (0 < [results count]) { \
            NSUInteger currentIndex, originalIndex; \
			\
			if (exhaustive) { \
				currentIndex = originalIndex = 0; \
			} else { \
				currentIndex = originalIndex = random() % [results count]; \
			} \
			\
			do { \
				KeychainItem *selection = [results objectAtIndex:currentIndex]; \
				\
				TEST_NOTE("%s element at index %lu", (exhaustive ? "Testing" : "Randomly chose"), currentIndex - 1); \
				\
				TEST_NOTE("\tItem is: %s", [[selection description] UTF8String]); \
				\
				PRIMITIVE_TYPE selectionsValue = [selection KEYCHAINITEM_GETTER]; \
				\
				TEST_NOTE("\tItem's %s is: %" PRIMITIVE_TYPE_FORMATTER, attributeNameUTF8String, PRIMITIVE_TYPE_CAST selectionsValue); \
				\
				[search KEYCHAINSEARCH_SETTER:selectionsValue]; \
				\
				TEST_NOTE("\tSearch predicate: %s", [[[search predicate] description] UTF8String]); \
				\
				NSArray *refinedResults; \
				\
				TEST(nil != (refinedResults = [search anySearchResults]), "Able to refine search based on %s", attributeNameUTF8String); \
				\
				if (nil != refinedResults) { \
					TEST(0 < [refinedResults count], "There is at least one result from refined search"); \
					\
					if (0 < [refinedResults count]) { \
						NSEnumerator *enumerator = [refinedResults objectEnumerator]; \
						KeychainItem *current; \
						BOOL allHaveSameValue = YES; \
						BOOL amMissingResults = NO; \
						\
						while (current = [enumerator nextObject]) { \
							if (selectionsValue != [current KEYCHAINITEM_GETTER]) { \
								allHaveSameValue = NO; \
								\
								TEST_NOTE("\tRefined result with different %s (%" PRIMITIVE_TYPE_FORMATTER "): %s", attributeNameUTF8String, PRIMITIVE_TYPE_CAST [current KEYCHAINITEM_GETTER], [[current description] UTF8String]); \
							} \
						} \
						\
						TEST(allHaveSameValue, "All results have the expected %s", attributeNameUTF8String); \
						\
						enumerator = [results objectEnumerator]; \
						\
						while (current = [enumerator nextObject]) { \
							if (selectionsValue == [current KEYCHAINITEM_GETTER]) { \
								if (![refinedResults containsObject:current]) { \
									amMissingResults = YES; \
									\
									TEST_NOTE("\tMissing result: %s", [[current description] UTF8String]); \
								} \
							} \
						} \
						\
						TEST(!amMissingResults, "All expected results were returned"); \
					} \
				} \
				\
				if (exhaustive) { \
					currentIndex = (currentIndex + 1) % [results count]; \
				} \
			} while (exhaustive && (currentIndex != originalIndex)); \
        } \
    } \
    \
    END_TEST(); \
}

void test_keychainSearchByCreationDate(BOOL exhaustive) {
    template_searchByAttributeWithObjectValue(@"creation date", @selector(creationDate), @selector(setCreationDate:), exhaustive);
}

void test_keychainSearchByModificationDate(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"modification date", @selector(modificationDate), @selector(setModificationDate:), exhaustive);
}

void test_keychainSearchByDescription(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"description", @selector(typeDescription), @selector(setTypeDescription:), exhaustive);
}

void test_keychainSearchByComment(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"comment", @selector(comment), @selector(setComment:), exhaustive);
}

void test_keychainSearchByCreator(BOOL exhaustive) {
 	template_searchByAttributeWithObjectValue(@"creatorAsString", @selector(creatorAsString), @selector(setCreator:), exhaustive);
}

void test_keychainSearchByType(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"typeAsString", @selector(typeAsString), @selector(setType:), exhaustive);
}

void test_keychainSearchByLabel(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"label", @selector(label), @selector(setLabel:), exhaustive);
}

void test_keychainSearchByVisibility(BOOL exhaustive) {
	template_searchByAttributeWithPrimitiveType(@"visibility", isVisible, setIsVisible, exhaustive, BOOL, "d", (int));
}

void test_keychainSearchByPasswordValidity(BOOL exhaustive) {
	template_searchByAttributeWithPrimitiveType(@"validity", passwordIsValid, setPasswordIsValid, exhaustive, BOOL, "d", (int));
}

void test_keychainSearchByCustomIcon(BOOL exhaustive) {
	template_searchByAttributeWithPrimitiveType(@"has custom icon", hasCustomIcon, setHasCustomIcon, exhaustive, BOOL, "d", (int));
}

void test_keychainSearchByAccount(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"account", @selector(account), @selector(setAccount:), exhaustive);
}

void test_keychainSearchByService(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"service", @selector(service), @selector(setService:), exhaustive);
}

void test_keychainSearchByUserDefinedAttribute(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"user-defined attribute", @selector(userDefinedAttribute), @selector(setUserDefinedAttribute:), exhaustive);
}

void test_keychainSearchBySecurityDomain(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"securityDomain", @selector(securityDomain), @selector(setSecurityDomain:), exhaustive);
}

void test_keychainSearchByServer(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"server", @selector(server), @selector(setServer:), exhaustive);
}

void test_keychainSearchByAuthenticationType(BOOL exhaustive) {
	template_searchByAttributeWithPrimitiveType(@"authentication type", authenticationType, setAuthenticationType, exhaustive, SecAuthenticationType, PRIu32, (uint32_t));
}

void test_keychainSearchByPort(BOOL exhaustive) {
	template_searchByAttributeWithPrimitiveType(@"port", port, setPort, exhaustive, uint16_t, PRIu16, (uint16_t));
}

void test_keychainSearchByPath(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"path", @selector(path), @selector(setPath:), exhaustive);
}

void test_keychainSearchByAppleShareVolume(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"AppleShare volume", @selector(appleShareVolume), @selector(setAppleShareVolume:), exhaustive);
}

void test_keychainSearchByAppleShareAddress(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"AppleShare address", @selector(appleShareAddress), @selector(setAppleShareAddress:), exhaustive);
}

/* - (BOOL exhaustive)setAppleShareSignature:(SecAFPServerSignature*)sig; */

void test_keychainSearchByProtocol(BOOL exhaustive) {
	template_searchByAttributeWithPrimitiveType(@"protocol", protocol, setProtocol, exhaustive, SecProtocolType, PRIu32, (uint32_t));
}

void test_keychainSearchByCertificateType(BOOL exhaustive) {
	template_searchByAttributeWithPrimitiveType(@"certificate type", certificateType, setCertificateType, exhaustive, CSSM_CERT_TYPE, PRIu32, (uint32_t));
}

void test_keychainSearchByCertificateEncoding(BOOL exhaustive) {
	template_searchByAttributeWithPrimitiveType(@"certificate encoding", certificateEncoding, setCertificateEncoding, exhaustive, CSSM_CERT_ENCODING, PRIu32, (uint32_t));
}

void test_keychainSearchByCRLType(BOOL exhaustive) {
	template_searchByAttributeWithPrimitiveType(@"CRL type", CRLType, setCRLType, exhaustive, CSSM_CRL_TYPE, PRIu32, (uint32_t));
}

void test_keychainSearchByCRLEncoding(BOOL exhaustive) {
	template_searchByAttributeWithPrimitiveType(@"CRL encoding", CRLEncoding, setCRLEncoding, exhaustive, CSSM_CRL_ENCODING, PRIu32, (uint32_t));
}

void test_keychainSearchByAlias(BOOL exhaustive) {
	template_searchByAttributeWithObjectValue(@"alias", @selector(alias), @selector(setAlias:), exhaustive);
}

int main(int argc, char const *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BOOL exhaustive = NO;
	
#if __DARWIN_UNIX03
	srandom((unsigned int)time(NULL));
#else
	srandom(time(NULL));
#endif
	
	if (1 < argc) {
		if (0 == strcasecmp("exhaustive", argv[1])) {
			exhaustive = YES;
		}
	}
	
    test_keychainSearchByCreationDate(exhaustive);
    test_keychainSearchByModificationDate(exhaustive);
    test_keychainSearchByDescription(exhaustive);
    test_keychainSearchByComment(exhaustive);
    test_keychainSearchByCreator(exhaustive);
    test_keychainSearchByType(exhaustive);
    test_keychainSearchByLabel(exhaustive);
    test_keychainSearchByVisibility(exhaustive);
    test_keychainSearchByPasswordValidity(exhaustive);
    test_keychainSearchByCustomIcon(exhaustive);
    test_keychainSearchByAccount(exhaustive);
    test_keychainSearchByService(exhaustive);
    test_keychainSearchByUserDefinedAttribute(exhaustive);
    test_keychainSearchBySecurityDomain(exhaustive);
    test_keychainSearchByServer(exhaustive);
    test_keychainSearchByAuthenticationType(exhaustive);
    test_keychainSearchByPort(exhaustive);
    test_keychainSearchByPath(exhaustive);
    test_keychainSearchByAppleShareVolume(exhaustive);
    test_keychainSearchByAppleShareAddress(exhaustive);
    test_keychainSearchByProtocol(exhaustive);
    test_keychainSearchByCertificateType(exhaustive);
    test_keychainSearchByCertificateEncoding(exhaustive);
    test_keychainSearchByCRLType(exhaustive);
    test_keychainSearchByCRLEncoding(exhaustive);
    test_keychainSearchByAlias(exhaustive);

    [pool release];
    
    FINAL_SUMMARY();    
}
