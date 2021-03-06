//
//  CSSMACLEntry.m
//  Keychain
//
//  Created by Wade Tregaskis on 30/7/2005.
//
//  Copyright (c) 2006 - 2007, Wade Tregaskis.  All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of Wade Tregaskis nor the names of any other contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "CSSMACLEntry.h"
#import "Utilities/Logging.h"


@implementation CSSMACLEntry

+ (CSSMACLEntry*)entryWithEntry:(CSSM_ACL_ENTRY_INFO*)entry {
    return [[[[self class] alloc] initWithEntry:entry] autorelease];
}

- (CSSMACLEntry*)initWithEntry:(CSSM_ACL_ENTRY_INFO*)entry {
    if (self = [super init]) {
        if (NULL != entry) {
            myEntry = entry;
        } else {
            PDEBUG(@"Entry parameter is NULL.\n");
            [self release];
            self = nil;
        }
    }
    
    return self;
}

- (CSSM_ACL_ENTRY_INFO*)entry {
    return myEntry;
}

@end
