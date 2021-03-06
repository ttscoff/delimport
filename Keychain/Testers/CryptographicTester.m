//
//  CryptographicTester.m
//  Keychain
//  
//  Copyright (c) 2003 - 2007, Wade Tregaskis.  All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of the Wade Tregaskis nor the names of any other contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import <Foundation/Foundation.h>
#import <Keychain/MutableKey.h>
#import <Keychain/NSDataAdditions.h>
#import <Keychain/KeychainUtils.h>
#import <Keychain/MultiThreading.h>
#import <Keychain/UtilitySupport.h>

#import "TestingCommon.h"


@interface StupidUselessThreader : NSObject {}

- (StupidUselessThreader*)init;
- (void)performThreadyStuff:(id)object;

@end

@implementation StupidUselessThreader

- (StupidUselessThreader*)init {
    return (self = [super init]);
}

- (void)performThreadyStuff:(id)object {
#pragma unused (object) // Grr.
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"I'm a useless thread object, because NSThread won't let me launch a thread on an NSData instance.  Look at me go!");

    [pool release];
}

@end


int main (int argc, const char * argv[]) {
#pragma unused (argc, argv) // We have no need for these right now.

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Key *testKey, *pubKey = nil, *privKey = nil, *wrappedKey, *unwrappedKey, *rebornKey;
    NSCalendarDate *validFrom = [NSCalendarDate calendarDate], *validTo = [validFrom dateByAddingYears:0 months:3 days:0 hours:0 minutes:0 seconds:0];
    NSData *original, *encrypted, *decrypted, *MAC, *signature, *random, *serialKey;
    NSString *genericString = @"Why do birds suddenly appear, everytime, you are near?";
    const CSSM_KEY *a, *b;
    StupidUselessThreader *SUT = [[StupidUselessThreader alloc] init];

    [[KeychainThreadController defaultController] activateThreadSafety];
    [NSThread detachNewThreadSelector:@selector(performThreadyStuff:) toTarget:SUT withObject:nil];

    original = [NSDataFromNSString(genericString) retain];

    //TEST_NOTE("Start date: %s\nEnd date: %s", [[validFrom description] UTF8String], [[validTo description] UTF8String]);
    
    START_TEST("Random data generation");
    
    TEST(((random = generateGenericRandomNSData(4)) != nil) && ([random length] == 4), "\tgenerateGenericRandomData() with length of 4 bytes");
    TEST(((random = generateGenericRandomNSData(40)) != nil) && ([random length] == 40), "\tgenerateGenericRandomData() with length of 40 bytes");
    TEST(((random = generateGenericRandomNSData(400)) != nil) && ([random length] == 400), "\tgenerateGenericRandomData() with length of 400 bytes");

    TEST(((random = generateSeededRandomNSData(100, original)) != nil) && ([random length] == 100), "\tgenerateSeededRandomData() with length of 100 bytes and generic seed");
    
    END_TEST();
    
    START_TEST("Symmetric cryptography (TripleDES)");
    
    TEST((testKey = [MutableKey generateKey:CSSM_ALGID_3DES_3KEY size:192 validFrom:validFrom validTo:validTo usage:CSSM_KEYUSE_ANY mutable:YES extractable:YES sensitive:NO label:@"TripleDES Key" module:nil]) != nil, "\t+(MutableKey*)generateKey for TripleDES");

    //TEST_NOTE("\t\tKey: %s", [[testKey description] UTF8String]);

    TEST((wrappedKey = [testKey wrappedKeyUnsafeWithDescription:@"I am a RAW key.  Look at me go."]) != nil, "\t+(Key*)wrappedKeyUnsafeWithDescription");

    //TEST_NOTE("\t\tWrapped key: %s", [[wrappedKey description] UTF8String]);

    TEST((unwrappedKey = [wrappedKey unwrappedKeyUnsafe]) != nil, "\t+(Key*)unwrappedKeyUnsafe");

    //TEST_NOTE("\t\tUnwrapped key: %s", [[unwrappedKey description] UTF8String]);
    
    TEST((encrypted = [original encryptedDataUsingKey:testKey]) != nil, "\t-(NSData*)encryptedDataUsingKey:module:");
    
    //TEST_NOTE("\t\tOriginal text: %s (%s)", [NSStringFromNSData(original) UTF8String], [[original description] UTF8String]);
    //TEST_NOTE("\t\tEncrypted text: %s (%s)", [NSStringFromNSData(encrypted) UTF8String], [[encrypted description] UTF8String]);
    
    TEST((decrypted = [encrypted decryptedDataUsingKey:testKey]) != nil, "\t-(NSData*)decryptedDataUsingKey:module:");

    //TEST_NOTE("\t\tDecrypted text: %s (%s)", [NSStringFromNSData(decrypted) UTF8String], [[decrypted description] UTF8String]);

    TEST([original isEqualToData:decrypted], "\tencrypted == decrypted");
    
    END_TEST();
    
    START_TEST("Hashing");
    
    TEST((testKey = [MutableKey generateKey:CSSM_ALGID_SHA1HMAC size:320 validFrom:validFrom validTo:validTo usage:CSSM_KEYUSE_ANY mutable:YES extractable:YES sensitive:YES label:@"SHA1 HMAC Key" module:nil]) != nil, "\t+(MutableKey*)generateKey for SHA1 HMAC (320-bit)");

    //TEST_NOTE("\t\tKey: %s", [[testKey description] UTF8String]);

    TEST((MAC = [original MACUsingKey:testKey]) != nil, "\t-(NSData*)MACUsingKey:module:");

    //TEST_NOTE("\t\tMAC: %s", [[MAC description] UTF8String]);

    TEST([original verifyUsingKey:testKey MAC:MAC], "\t-(BOOL)verifyUsingKey:MAC:module:");
    
    END_TEST();

    START_TEST("Symmetric cryptography (AES)");
    
    TEST((testKey = [MutableKey generateKey:CSSM_ALGID_AES size:256 validFrom:validFrom validTo:validTo usage:CSSM_KEYUSE_ANY mutable:YES extractable:YES sensitive:YES label:@"AES Key" module:nil]) != nil, "\t+(MutableKey*)generateKey for AES (256-bit)");

    //TEST_NOTE("\t\tKey: %s", [[testKey description] UTF8String]);
    
    TEST(((encrypted = [original encryptedDataUsingKey:testKey]) != nil), "\t-(NSData*)encryptedDataUsingKey:module:");

    //TEST_NOTE("\t\tOriginal text: %s (%s)", [NSStringFromNSData(original) UTF8String], [[original description] UTF8String]);
    //TEST_NOTE("\t\tEncrypted text: %s (%s)", [NSStringFromNSData(encrypted) UTF8String], [[encrypted description] UTF8String]);

    TEST(((decrypted = [encrypted decryptedDataUsingKey:testKey]) != nil), "\t-(NSData*)decryptedDataUsingKey:module:");

    //TEST_NOTE("\t\tDecrypted text: %s (%s)", [NSStringFromNSData(decrypted) UTF8String], [[decrypted description] UTF8String]);

    TEST([original isEqualToData:decrypted], "\tencrypted == decrypted");

    END_TEST();
    
    START_TEST("Improper key generation");
    
    TEST((testKey = [MutableKey generateKey:CSSM_ALGID_AES size:320 validFrom:validFrom validTo:validTo usage:CSSM_KEYUSE_ANY mutable:YES extractable:YES sensitive:YES label:@"Invalid AES Key" module:nil]) == nil, "\t+(MutableKey*)generateKey for AES (320-bit) - should fail to generate key");

    TEST((testKey = [MutableKey generateKey:CSSM_ALGID_DSA size:2048 validFrom:validFrom validTo:validTo usage:CSSM_KEYUSE_ANY mutable:YES extractable:YES sensitive:YES label:@"DSA Key" module:nil]) == nil, "\t+(MutableKey*)generateKey for DSA (2048-bit) - should fail to generate key");

    END_TEST();
    
    START_TEST("Asymmetric cryptography");
    
    TEST(CSSM_OK == generateKeyPair(CSSM_ALGID_DSA, 512, validFrom, validTo, CSSM_KEYUSE_ANY, CSSM_KEYUSE_ANY, @"DSA Public Key", @"DSA Private Key", nil, (MutableKey**)&pubKey, (MutableKey**)&privKey), "\tgenerateKeyPair() for DSA (512-bit)");

    TEST((privKey != nil) && (pubKey != nil), "\t\treturned public and private key present");

    //TEST_NOTE("\t\tPublic Key: %s\n\t\tPrivate Key: %s", [[pubKey description] UTF8String], [[privKey description] UTF8String]);

    TEST((signature = [original signatureUsingKey:privKey]) != nil, "\tSigning");

    //TEST_NOTE("\t\tSignature: %s (%s)", [NSStringFromNSData(signature) UTF8String], [[signature description] UTF8String]);

    TEST([original verifySignature:signature usingKey:pubKey] == YES, "\tSignature verification");
    TEST([original verifySignature:original usingKey:pubKey] == NO, "\tSignature verification with invalid signature");
    
    TEST(CSSM_OK == generateKeyPair(CSSM_ALGID_RSA, 2048, validFrom, validTo, CSSM_KEYUSE_ANY, CSSM_KEYUSE_ANY, @"RSA Public Key", @"RSA Private Key", nil, (MutableKey**)&pubKey, (MutableKey**)&privKey), "\tgenerateKeyPair() for RSA (2048-bit)");
    
    TEST((privKey != nil) && (pubKey != nil), "\t\tReturned public and private key present");

    //TEST_NOTE("\t\tPublic Key: %s\t\tPrivate Key: %s", [[pubKey description] UTF8String], [[privKey description] UTF8String]);

    TEST((wrappedKey = [privKey wrappedKeyUsingKey:pubKey description:@"Private key wrapped with it's public key"]) != nil, "\t+(Key*)wrappedKeyUsingKey");

    //TEST_NOTE("\t\tWrapped key: %s", [[wrappedKey description] UTF8String]);

    TEST((serialKey = [wrappedKey data]) != nil, "\tSerialization of wrapped private key");

    //TEST_NOTE("\t\tSerialized key data: %s", [[serialKey description] UTF8String]);

    TEST((rebornKey = [serialKey keyForModule:nil]) != nil, "\tDeserialization of wrapped private key");

    //TEST_NOTE("\t\tReborn key: %s", [[rebornKey description] UTF8String]);

    a = [wrappedKey CSSMKey];
    b = [rebornKey CSSMKey];

    TEST((NULL != a) && (NULL != b) && (a->KeyData.Length == b->KeyData.Length) && (memcmp(a->KeyData.Data, b->KeyData.Data, a->KeyData.Length) == 0), "\tReborn key data == original key data");

    TEST((unwrappedKey = [rebornKey unwrappedKeyUsingKey:privKey]) != nil, "\tUnwrap reborn key");

    //TEST_NOTE("\t\tUnwrapped reborn key: %s", [[unwrappedKey description] UTF8String]);
    
    a = b = NULL;
    
    TEST(((encrypted = [original encryptedDataUsingKey:pubKey]) != nil), "\t-(NSData*)encryptedDataUsingKey");

    //TEST_NOTE("\t\tOriginal text: %s (%s)", [NSStringFromNSData(original) UTF8String], [[original description] UTF8String]);
    //TEST_NOTE("\t\tEncrypted text: %s (%s)", [NSStringFromNSData(encrypted) UTF8String], [[encrypted description] UTF8String]);

    TEST(((decrypted = [encrypted decryptedDataUsingKey:privKey]) != nil), "\t-(NSData*)decryptedDataUsingKey");

    //TEST_NOTE("\t\tDecrypted text: %s (%s)", [NSStringFromNSData(decrypted) UTF8String], [[decrypted description] UTF8String]);

    TEST([original isEqualToData:decrypted], "\tencrypted == decrypted");

    TEST((serialKey = [pubKey rawData]) == nil, "\tSerialization of unwrapped public key fails");
    
    END_TEST();

    [pool release];

    FINAL_SUMMARY();
    
    return 0;
}
