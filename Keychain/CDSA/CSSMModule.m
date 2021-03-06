//
//  CSSMModule.m
//  Keychain
//
//  Created by Wade Tregaskis on 31/7/2005.
//
//  Copyright (c) 2006 - 2007, Wade Tregaskis.  All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of Wade Tregaskis nor the names of any other contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "CSSMModule.h"
#import "CSSMManagedModule.h"

#import "Utilities/MultiThreadingInternal.h"
#import "CSSMUtils.h"
#import "CSSMControl.h"
#import "Utilities/Logging.h"
#import "CSSMTypes.h"
#import "Utilities/CompilerIndependence.h"

#import <libkern/OSAtomic.h>



@implementation CSSMModule

static CSSMModule *defaultCSP = nil, *defaultTP = nil, *defaultCL = nil;


#pragma mark Global Configuration

+ (void)initialize {
    // TODO: verify that we can actually do this, invoking a subclass from our initialize method
    
    defaultCSP = [[CSSMManagedModule alloc] initWithGUID:gGuidAppleCSP];
    [(CSSMManagedModule*)defaultCSP setSubserviceType:CSSM_SERVICE_CSP];
    
    defaultTP = [[CSSMManagedModule alloc] initWithGUID:gGuidAppleX509TP];
    [(CSSMManagedModule*)defaultTP setSubserviceType:CSSM_SERVICE_TP];
    
    defaultCL = [[CSSMManagedModule alloc] initWithGUID:gGuidAppleX509CL];
    [(CSSMManagedModule*)defaultCL setSubserviceType:CSSM_SERVICE_CL];
}

+ (CSSMModule*)defaultCSPModule {
    CSSMModule *result;
    
    [keychainDefaultModuleLock lock];
    
    result = [defaultCSP retain];
    
    [keychainDefaultModuleLock unlock];
    
    return [result autorelease];
}

+ (void)setDefaultCSPModule:(CSSMModule*)newDefault {
    [keychainDefaultModuleLock lock];

    if (defaultCSP != newDefault) {
        [defaultCSP release];
        defaultCSP = [newDefault retain];
    }
    
    [keychainDefaultModuleLock unlock];
}

+ (CSSMModule*)defaultTPModule {
    CSSMModule *result;
    
    [keychainDefaultModuleLock lock];
    
    result = [defaultTP retain];
    
    [keychainDefaultModuleLock unlock];
    
    return [result autorelease];
}

+ (void)setDefaultTPModule:(CSSMModule*)newDefault {
    [keychainDefaultModuleLock lock];

    if (defaultTP != newDefault) {
        [defaultTP release];
        defaultTP = [newDefault retain];
    }
    
    [keychainDefaultModuleLock unlock];
}

+ (CSSMModule*)defaultCLModule {
    CSSMModule *result;
    
    [keychainDefaultModuleLock lock];
    
    result = [defaultCL retain];
    
    [keychainDefaultModuleLock unlock];
    
    return [result autorelease];
}

+ (void)setDefaultCLModule:(CSSMModule*)newDefault {
    [keychainDefaultModuleLock lock];

    if (defaultCL != newDefault) {
        [defaultCL release];
        defaultCSP = [newDefault retain];
    }

    [keychainDefaultModuleLock unlock];
}


#pragma mark Initialisers

+ (CSSMModule*)moduleWithHandle:(CSSM_MODULE_HANDLE)handle {
    return [[[[self class] alloc] initWithHandle:handle] autorelease];
}

- (CSSMModule*)initWithHandle:(CSSM_MODULE_HANDLE)handle {
    CSSMModule *existingInstance = [[self class] instanceWithKey:(id)handle from:@selector(handle) simpleKey:YES];

    if (nil != existingInstance) {
        [self release];
        return [existingInstance retain];
    } else if (self = [super init]) {
        _handle = handle;

        _error = CSSM_GetModuleGUIDFromHandle(_handle, &_GUID);
        
        if (CSSM_OK != _error) {
            PSYSLOGND(LOG_ERR, @"Unable to determine module GUID of handle %"PRImoduleHandle", error %@.\n", _handle, CSSMErrorAsString(_error));
            PDEBUG(@"CSSM_GetModuleGUIDFromHandle(%"PRImoduleHandle", %p) returned error %@.\n", _handle, &_GUID, CSSMErrorAsString(_error));
            
            [self release];
            self = nil;
        } else {
            CSSM_SUBSERVICE_UID subserviceUID;
            
            _error = CSSM_GetSubserviceUIDFromHandle(_handle, &subserviceUID);
            
            if (CSSM_OK != _error) {
                PSYSLOGND(LOG_ERR, @"Unable to determine subservice UID of handle %"PRImoduleHandle", error %@.\n", _handle, CSSMErrorAsString(_error));
                PDEBUG(@"CSSM_GetSubserviceUIDFromHandle(%"PRImoduleHandle", %p) returned error %@.\n", _handle, &subserviceUID, CSSMErrorAsString(_error));
            
                [self release];
                self = nil;
            } else {
                _version = subserviceUID.Version;
                _subserviceID = subserviceUID.SubserviceId;
                _subserviceType = subserviceUID.SubserviceType;

                _error = CSSM_GetAPIMemoryFunctions(_handle, &_memoryFunctions);
                
                if (CSSM_OK != _error) {
                    PSYSLOGND(LOG_ERR, @"Unable to determine memory functions of handle %"PRImoduleHandle", error %@.\n", _handle, CSSMErrorAsString(_error));
                    PDEBUG(@"CSSM_GetAPIMemoryFunctions(%"PRImoduleHandle", %p) returned error %@.\n", _handle, &_memoryFunctions, CSSMErrorAsString(_error));
                    
                    [self release];
                    self = nil;
                } else {
                    _loaded = _attached = YES;
                }
            }
        }
    } else {
        [self release];
        self = nil;
    }
    
    return self;
}

#pragma mark Getters & Setters

- (CSSM_GUID)GUID {
    return _GUID;
}

- (CSSM_VERSION)version {
    return _version;
}

- (const CSSM_API_MEMORY_FUNCS*)memoryFunctions {
    return &_memoryFunctions;
}

- (uint32_t)subserviceID {
    return _subserviceID;
}

- (CSSM_SERVICE_TYPE)subserviceType {
    return _subserviceType;
}

#pragma mark Managers

- (void)_markUnloaded {
    _loaded = NO;
}

- (BOOL)isLoaded {
    return _loaded;
}

- (BOOL)detach {
    if (_attached) { // Implies CSSM is initialised
        _error = CSSM_ModuleDetach(_handle);
        
        _attached = NO; // Assume it always detaches one way or another... really should figure out possible errors and treat them appropriately.

        if (CSSM_OK != _error) {
            PSYSLOGND(LOG_NOTICE, @"Unable to detach module (with GUID %@) because of error %@.\n", GUIDAsString(&_GUID), CSSMErrorAsString(_error));
            PDEBUG(@"CSSM_ModuleDetach(%"PRIclHandle") returned error %@, using module GUID %@.\n", _handle, CSSMErrorAsString(_error), GUIDAsString(&_GUID));
        }
        
        return (CSSM_OK == _error);
    } else {
        return YES;
    }
}

- (BOOL)isAttached {
    return _attached;
}

- (BOOL)isReady {
    return ([self isLoaded] && [self isAttached]);
}

- (CSSM_MODULE_HANDLE)handle {
    if ([self isReady]) {
        return _handle;
    } else {
        return 0;
    }
}

- (CSSM_RETURN)error {
    return _error;
}

@end
