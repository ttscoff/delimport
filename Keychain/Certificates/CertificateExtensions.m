//
//  CertificateExtensions.m
//  Keychain
//
//  Created by Wade Tregaskis on Mon Jul 12 2004.
//
//  Copyright (c) 2004 - 2007, Wade Tregaskis.  All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of Wade Tregaskis nor the names of any other contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "CertificateExtensions.h"


/* Extension structure */
/*typedef struct cssm_x509_extension {
    CSSM_OID extnId;    
    CSSM_BOOL critical; 
    CSSM_X509EXT_DATA_FORMAT format;
    union cssm_x509ext_value {
        CSSM_X509EXT_TAGandVALUE *tagAndValue;
        void *parsedValue;
        CSSM_X509EXT_PAIR *valuePair;
    } value; 
    CSSM_DATA BERvalue;
} CSSM_X509_EXTENSION, *CSSM_X509_EXTENSION_PTR; */


NameList* subjectAlternateName(CSSM_DATA *fieldValue) {
    //CSSM_X509_EXTENSION *ext = (CSSM_X509_EXTENSION*)fieldValue->Data;
    
    return nil; // FLAG - to be completed
}

NameList* issuerAlternateName(CSSM_DATA *fieldValue) {
    return subjectAlternateName(fieldValue);
}
