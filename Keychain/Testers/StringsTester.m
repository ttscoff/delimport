//
//  StringsTester.m
//  Keychain
//
//  Created by Wade Tregaskis on Wed May 25 2005.
//
//  Copyright (c) 2005 - 2007, Wade Tregaskis.  All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of Wade Tregaskis nor the names of any other contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Keychain/CSSMUtils.h>
#import <Keychain/SecurityUtils.h>

#import "TestingCommon.h"


#pragma mark CSSMUtils.h

void test_algorithmStrings(void) {
    NSString *result;
    
	START_TEST("Algorithms");
    
    result = nameOfAlgorithmConstant(CSSM_ALGID_SHA1WithRSA);
    
    TEST(nil != result, "nameOfAlgorithmConstant(CSSM_ALGID_SHA1WithRSA) returns result [Algorithm Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSM_ALGID_SHA1WithRSA"], "\tResult is as expected");
    }
    
    result = nameOfAlgorithm(CSSM_ALGID_RUNNING_COUNTER);
    
    TEST(nil != result, "nameOfAlgorithm(CSSM_ALGID_RUNNING_COUNTER) returns result [Algorithm Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Running Counter"], "\tResult is as expected");
    }
    
    result = nameOfAlgorithmModeConstant(CSSM_ALGMODE_PKCS1_EME_OAEP);
    
    TEST(nil != result, "nameOfAlgorithmModeConstant(CSSM_ALGMODE_PKCS1_EME_OAEP) returns result [Algorithm Mode Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSM_ALGMODE_PKCS1_EME_OAEP"], "\tResult is as expected");
    }
    
    result = nameOfAlgorithmMode(CSSM_ALGMODE_X9_31);
    
    TEST(nil != result, "nameOfAlgorithmMode(CSSM_ALGMODE_X9_31) returns result [Algorithm Mode Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"X9 31"], "\tResult is as expected");
    }
    
    END_TEST();
}

void test_BERStrings(void) {
    NSString *result;
    
    START_TEST("BER");
    
	result = nameOfBERCodeConstant(BER_TAG_PKIX_UTF8_STRING);
    
    TEST(nil != result, "nameOfBERCodeConstant(BER_TAG_PKIX_UTF8_STRING) returns result [BER Code Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"BER_TAG_PKIX_UTF8_STRING"], "\tResult is as expected");
    }
	
    result = nameOfBERCode(BER_TAG_PKIX_BMP_STRING);
    
    TEST(nil != result, "nameOfBERCode(BER_TAG_PKIX_BMP_STRING) returns result [BER Code Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"PKIX BMP String"], "\tResult is as expected");
    }
    
    END_TEST();
}

void test_certificateStrings(void) {
    NSString *result;
    
    START_TEST("Certificates");
    
    result = nameOfCertificateEncodingConstant(CSSM_CERT_ENCODING_DER);
    
    TEST(nil != result, "nameOfCertificateEncodingConstant(CSSM_CERT_ENCODING_DER) returns result [Certificate Encoding Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSM_CERT_ENCODING_DER"], "\tResult is as expected");
    }
    
    result = nameOfCertificateEncoding(CSSM_CERT_ENCODING_MULTIPLE);
    
    TEST(nil != result, "nameOfCertificateEncoding(CSSM_CERT_ENCODING_MULTIPLE) returns result [Certificate Encoding Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Multiple"], "\tResult is as expected");
    }
    
	
    result = nameOfCertificateTypeConstant(CSSM_CERT_X_509v1);
    
    TEST(nil != result, "nameOfCertificateTypeConstant(CSSM_CERT_X_509v1) returns result [Certificate Type Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSM_CERT_X_509v1"], "\tResult is as expected");
    }
    
    result = nameOfCertificateType(CSSM_CERT_MULTIPLE);
    
    TEST(nil != result, "nameOfCertificateType(CSSM_CERT_MULTIPLE) returns result [Certificate Type Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Multiple"], "\tResult is as expected");
    }
    
	
	result = nameOfExtensionFormatConstant(CSSM_X509_DATAFORMAT_PARSED);
    
    TEST(nil != result, "nameOfExtensionFormatConstant(CSSM_X509_DATAFORMAT_PARSED) returns result [Extension Format Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSM_X509_DATAFORMAT_PARSED"], "\tResult is as expected");
    }
	
	result = nameOfExtensionFormat(CSSM_X509_DATAFORMAT_PAIR);
    
    TEST(nil != result, "nameOfExtensionFormat(CSSM_X509_DATAFORMAT_PAIR) returns result [Extension Format Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Pair"], "\tResult is as expected");
    }
	
    END_TEST();
}

void test_CRLStrings(void) {
    NSString *result;
    
    START_TEST("CRLs");
    
    result = nameOfCRLEncodingConstant(CSSM_CRL_ENCODING_DER);
    
    TEST(nil != result, "nameOfCRLEncodingConstant(CSSM_CRL_ENCODING_DER) returns result [CRL Encoding Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSM_CRL_ENCODING_DER"], "\tResult is as expected");
    }
	
    result = nameOfCRLEncoding(CSSM_CRL_ENCODING_BER);
    
    TEST(nil != result, "nameOfCRLEncoding(CSSM_CRL_ENCODING_BER) returns result [CRL Encoding Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"BER"], "\tResult is as expected");
    }
    
    result = nameOfCRLTypeConstant(CSSM_CRL_TYPE_X_509v1);
    
    TEST(nil != result, "nameOfCRLTypeConstant(CSSM_CRL_TYPE_X_509v1) returns result [CRL Type Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSM_CRL_TYPE_X_509v1"], "\tResult is as expected");
    }
    
    result = nameOfCRLType(CSSM_CRL_TYPE_X_509v2);
    
    TEST(nil != result, "nameOfCRLType(CSSM_CRL_TYPE_X_509v2) returns result [CRL Type Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"X.509v2"], "\tResult is as expected");
    }
    
    END_TEST();
}

void test_CSSMErrorStrings(void) {
    NSString *result;
    
    START_TEST("CSSM Errors");
	
	result = CSSMErrorConstant(CSSMERR_APPLEDL_FILE_TOO_BIG);
    
    TEST(nil != result, "CSSMErrorConstant(CSSMERR_APPLEDL_FILE_TOO_BIG) returns result [CSSM Error Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSMERR_APPLEDL_FILE_TOO_BIG"], "\tResult is as expected");
    }
	
	result = CSSMErrorName(CSSMERR_APPLETP_INCOMPLETE_REVOCATION_CHECK);
    
    TEST(nil != result, "CSSMErrorName(CSSMERR_APPLETP_INCOMPLETE_REVOCATION_CHECK) returns result [CSSM Error Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Revocation check not successful for each certificate"], "\tResult is as expected");
    }
	
	result = CSSMErrorDescription(CSSMERR_CSP_INVALID_ATTR_START_DATE);
    
    TEST(nil != result, "CSSMErrorDescription(CSSMERR_CSP_INVALID_ATTR_START_DATE) returns result [CSSM Error Descriptions.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"The operation creates an object with a validity date and the starting date is invalid"], "\tResult is as expected");
    }
	
    result = CSSMErrorAsString(CSSMERR_APPLE_DOTMAC_REQ_SERVER_SERVICE_ERROR);
    
    TEST(nil != result, "CSSMErrorAsString(CSSMERR_APPLE_DOTMAC_REQ_SERVER_SERVICE_ERROR) returns result");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSMERR_APPLE_DOTMAC_REQ_SERVER_SERVICE_ERROR (#2147558508) - .Mac server reported: Service error"], "\tResult is as expected");
    }
    
    END_TEST();
}

void test_GUIDStrings(void) {
    NSString *result;
    
    START_TEST("GUIDs");
    
    result = nameOfGUID(&gGuidAppleDotMacDL);
    
    TEST(nil != result, "nameOfGUID(&gGuidAppleDotMacDL) returns result [GUID Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Apple .Mac DL"], "\tResult is as expected");
    }
    
    END_TEST();
}

void test_KeyStrings(void) {
    NSString *result;
    
    START_TEST("Keys");
    
	result = descriptionOfKeyAttributesUsingConstants(0x20010023);
    
    TEST(nil != result, "descriptionOfKeyAttributesUsingConstants(0x20010023) returns result [Key Attribute Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"(CSSM_KEYATTR_PERMANENT | CSSM_KEYATTR_PRIVATE | CSSM_KEYATTR_EXTRACTABLE | 0x00010000 | CSSM_KEYATTR_RETURN_REF)"], "\tResult is as expected");
    }
	
    result = descriptionOfKeyAttributes(0x20010023);
    
    TEST(nil != result, "descriptionOfKeyAttributes(0x20010023) returns result [Key Attribute Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Permanent, Private, Extractable, Unknown (0x00010000), Return Reference"], "\tResult is as expected");
    }
    
	
	result = nameOfKeyClassConstant(CSSM_KEYCLASS_SESSION_KEY);
    
    TEST(nil != result, "nameOfKeyClassConstant(CSSM_KEYCLASS_SESSION_KEY) returns result [Key Class Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSM_KEYCLASS_SESSION_KEY"], "\tResult is as expected");
    }
	
	result = nameOfKeyClass(CSSM_KEYCLASS_SECRET_PART);
    
    TEST(nil != result, "nameOfKeyClass(CSSM_KEYCLASS_SECRET_PART) returns result [Key Class Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Secret part"], "\tResult is as expected");
    }
	
	
	result = descriptionOfKeyUsageUsingConstants(0x100000c3);
    
    TEST(nil != result, "descriptionOfKeyUsage(0x100000c3) returns result [Key Usage Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"(CSSM_KEYUSE_ENCRYPT | CSSM_KEYUSE_DECRYPT | CSSM_KEYUSE_WRAP | CSSM_KEYUSE_UNWRAP | 0x10000000)"], "\tResult is as expected");
    }
	
	result = descriptionOfKeyUsage(0x100000c3);
    
    TEST(nil != result, "descriptionOfKeyUsage(0x100000c3) returns result [Key Usage Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Encrypt, Decrypt, Wrap, Unwrap, Unknown (0x10000000)"], "\tResult is as expected");
    }
	
	
	result = nameOfTypedFormat(CSSM_KEYBLOB_WRAPPED_FORMAT_MSCAPI, CSSM_KEYBLOB_WRAPPED);
    
    TEST(nil != result, "nameOfTypedFormat(CSSM_KEYBLOB_WRAPPED_FORMAT_MSCAPI, CSSM_KEYBLOB_WRAPPED) returns result [Keyblob Formats.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Microsoft CAPI"], "\tResult is as expected");
    }
	
	
	result = nameOfKeyblobTypeConstant(CSSM_KEYBLOB_REFERENCE);
    
    TEST(nil != result, "nameOfKeyblobTypeConstant(CSSM_KEYBLOB_REFERENCE) returns result [Keyblob Type Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSM_KEYBLOB_REFERENCE"], "\tResult is as expected");
    }
	
	result = nameOfKeyblobType(CSSM_KEYBLOB_WRAPPED);
    
    TEST(nil != result, "nameOfKeyblobType(CSSM_KEYBLOB_WRAPPED) returns result [Keyblob Type Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Wrapped"], "\tResult is as expected");
    }
	
    END_TEST();
}

void test_OIDStrings(void) {
    NSString *result;
    
    START_TEST("OIDs");
    
    result = nameOfOID(&CSSMOID_PKIX_OCSP_SERVICE_LOCATOR);
    
    TEST(nil != result, "nameOfOID(&CSSMOID_PKIX_OCSP_SERVICE_LOCATOR) returns result [OID Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"PKIX OCSP Service Locator"], "\tResult is as expected");
    }
    
    END_TEST();
}

void test_trustStrings(void) {
	NSString *result;
	
	START_TEST("Trust");
	
	result = nameOfAuthorization(CSSM_ACL_AUTHORIZATION_LOGIN);
	
	TEST(nil != result, "nameOfAuthorization(CSSM_ACL_AUTHORIZATION_LOGIN) returns result [Authorization Tag Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Login"], "\tResult is as expected");
    }
    
	result = nameOfAuthorizationConstant(CSSM_ACL_AUTHORIZATION_GENKEY);
	
	TEST(nil != result, "nameOfAuthorizationConstant(CSSM_ACL_AUTHORIZATION_GENKEY) returns result [Authorization Tag Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSM_ACL_AUTHORIZATION_GENKEY"], "\tResult is as expected");
    }
	
	result = descriptionOfAuthorizations([NSArray arrayWithObjects:[NSNumber numberWithInt:CSSM_ACL_AUTHORIZATION_SIGN], [NSNumber numberWithInt:CSSM_ACL_AUTHORIZATION_ENCRYPT], [NSNumber numberWithInt:CSSM_ACL_AUTHORIZATION_DECRYPT], nil]);
	
	TEST(nil != result, "descriptionOfAuthorizations({CSSM_ACL_AUTHORIZATION_SIGN, CSSM_ACL_AUTHORIZATION_ENCRYPT, CSSM_ACL_AUTHORIZATION_DECRYPT}) returns result [Authorization Tag Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Signing, Encryption & Decryption"], "\tResult is as expected");
    }
	
	result = descriptionOfAuthorizationsUsingConstants([NSArray arrayWithObjects:[NSNumber numberWithInt:CSSM_ACL_AUTHORIZATION_DB_READ], [NSNumber numberWithInt:CSSM_ACL_AUTHORIZATION_DB_INSERT], [NSNumber numberWithInt:CSSM_ACL_AUTHORIZATION_DB_MODIFY], [NSNumber numberWithInt:CSSM_ACL_AUTHORIZATION_DB_DELETE], nil]);
	
	TEST(nil != result, "descriptionOfAuthorizations({CSSM_ACL_AUTHORIZATION_DB_READ, CSSM_ACL_AUTHORIZATION_DB_INSERT, CSSM_ACL_AUTHORIZATION_DB_MODIFY, CSSM_ACL_AUTHORIZATION_DB_DELETE}) returns result [Authorization Tag Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"CSSM_ACL_AUTHORIZATION_DB_READ, CSSM_ACL_AUTHORIZATION_DB_INSERT, CSSM_ACL_AUTHORIZATION_DB_MODIFY & CSSM_ACL_AUTHORIZATION_DB_DELETE"], "\tResult is as expected");
    }
	
    END_TEST();
}


#pragma mark SecurityUtils.h

void test_OSStatusStrings(void) {
    NSString *result;
    
    START_TEST("OSStatus");
	
	result = OSStatusConstant(userCanceledErr);
    
    TEST(nil != result, "OSStatusConstant(userCanceledErr) returns result [OSStatus Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"userCanceledErr"], "\tResult is as expected");
    }
	
	result = OSStatusDescription(errSecItemNotFound);
    
    TEST(nil != result, "OSStatusDescription(errSecItemNotFound) returns result [OSStatus Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"The item cannot be found"], "\tResult is as expected");
    }
	
    result = OSStatusAsString(errSecInteractionRequired);
    
    TEST(nil != result, "OSStatusAsString(errSecInteractionRequired) returns result");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"errSecInteractionRequired (#-25315) - Interaction with the user is required in order to grant access or process a request; however, user interaction with the Security Server is impossible because the program is operating in a session incapable of graphics (such as a root session or ssh session)"], "\tResult is as expected");
    }
    
    END_TEST();
}

void test_AuthenticationTypeStrings(void) {
    NSString *result;
    
    START_TEST("Authenticate Types");
	
	result = nameOfAuthenticationTypeConstant(kSecAuthenticationTypeHTTPDigest);
    
    TEST(nil != result, "nameOfAuthenticationTypeConstant(kSecAuthenticationTypeHTTPDigest) returns result [Authentication Type Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"kSecAuthenticationTypeHTTPDigest"], "\tResult is as expected");
    }
	
	result = nameOfAuthenticationType(kSecAuthenticationTypeNTLM);
    
    TEST(nil != result, "nameOfAuthenticationType(kSecAuthenticationTypeNTLM) returns result [Authentication Type Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Windows NT LAN Manager"], "\tResult is as expected");
    }
	    
    END_TEST();
}

void test_ProtocolTypeStrings(void) {
    NSString *result;
    
    START_TEST("Protocol Types");
	
	result = nameOfProtocolConstant(kSecProtocolTypePOP3);
    
    TEST(nil != result, "nameOfProtocolConstant(kSecProtocolTypePOP3) returns result [Protocol Type Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"kSecProtocolTypePOP3"], "\tResult is as expected");
    }
	
	result = shortNameOfProtocol(kSecProtocolTypeIMAP);
    
    TEST(nil != result, "shortNameOfProtocol(kSecProtocolTypeIMAP) returns result [Protocol Type Short Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"IMAP"], "\tResult is as expected");
    }
	
	result = longNameOfProtocol(kSecProtocolTypeLDAPS);
    
    TEST(nil != result, "longNameOfProtocol(kSecProtocolTypeLDAPS) returns result [Protocol Type Long Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"LDAP (Lightweight Directory Access Protocol) over TLS/SSL (Transport Layer Security / Secure Socket Library)"], "\tResult is as expected");
    }
	
    END_TEST();
}

void test_KeychainItemAttributeStrings(void) {
    NSString *result;
    
    START_TEST("KeychainItem Attribute Types");
	
	result = nameOfKeychainAttributeConstant(kSecAlias);
    
    TEST(nil != result, "nameOfKeychainAttributeConstant(kSecAlias) returns result [Keychain Attribute Type Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"kSecAlias"], "\tResult is as expected");
    }
	
	result = nameOfKeychainAttribute(kSecPathItemAttr);
    
    TEST(nil != result, "nameOfKeychainAttribute(kSecPathItemAttr) returns result [Keychain Attribute Type Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Path"], "\tResult is as expected");
    }
	
    END_TEST();
}

void test_KeychainItemClassStrings(void) {
    NSString *result;
    
    START_TEST("KeychainItem Classes");
	
	result = nameOfKeychainItemClassConstant(kSecInternetPasswordItemClass);
    
    TEST(nil != result, "nameOfKeychainItemClassConstant(kSecInternetPasswordItemClass) returns result [KeychainItem Class Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"kSecInternetPasswordItemClass"], "\tResult is as expected");
    }
	
	result = nameOfKeychainItemClass(kSecCertificateItemClass);
    
    TEST(nil != result, "nameOfKeychainItemClass(kSecCertificateItemClass) returns result [KeychainItem Class Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Certificate"], "\tResult is as expected");
    }
	
    END_TEST();
}

void test_ImportExport(void) {
    NSString *result;
    
    START_TEST("Import/Export");
	
	result = nameOfExternalFormat(kSecFormatWrappedOpenSSL);
    
    TEST(nil != result, "nameOfExternalFormat(kSecFormatWrappedOpenSSL) returns result [External Format Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Wrapped OpenSSL"], "\tResult is as expected");
    }
	
	result = nameOfExternalFormatConstant(kSecFormatX509Cert);
    
    TEST(nil != result, "nameOfExternalFormatConstant(kSecFormatX509Cert) returns result [External Format Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"kSecFormatX509Cert"], "\tResult is as expected");
    }
	
	result = nameOfExternalItemType(kSecItemTypeCertificate);
    
    TEST(nil != result, "nameOfExternalItemType(kSecItemTypeCertificate) returns result [External Item Type Names.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"Certificate"], "\tResult is as expected");
    }
	
	result = nameOfExternalItemTypeConstant(kSecItemTypePrivateKey);
    
    TEST(nil != result, "nameOfExternalItemTypeConstant(kSecItemTypePrivateKey) returns result [External Item Type Constants.strings]");
    
    if (nil != result) {
        TEST_NOTE("\tResult is: %s", [result UTF8String]);
        TEST([result isEqualToString:@"kSecItemTypePrivateKey"], "\tResult is as expected");
    }
	
    END_TEST();
}


#pragma mark Driver

int main(int argc, char const *argv[]) {
#pragma unused (argc, argv) // We have no need for these right now.

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// CSSMUtils.h
    test_algorithmStrings();
	test_BERStrings();
	test_certificateStrings();
	test_CRLStrings();
	test_CSSMErrorStrings();
	test_GUIDStrings();
	test_KeyStrings();
	test_OIDStrings();
	test_trustStrings();
    
	// SecurityUtils.h
	test_OSStatusStrings();
	test_AuthenticationTypeStrings();
	test_ProtocolTypeStrings();
	test_KeychainItemAttributeStrings();
	test_KeychainItemClassStrings();
	test_ImportExport();
	
    [pool release];

    FINAL_SUMMARY();    
}
