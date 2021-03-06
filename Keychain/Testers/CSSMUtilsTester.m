//
//  CSSMUtilsTester.m
//  Keychain
//
//  Created by Wade Tregaskis on Sun May 15 2005.
//
//  Copyright (c) 2005 - 2007, Wade Tregaskis.  All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of Wade Tregaskis nor the names of any other contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Keychain/CSSMUtils.h>

#import "TestingCommon.h"


void test_calendarDateForTime(void) {
    CSSM_X509_TIME time;
    NSCalendarDate *date;
    int i;
    
    START_TEST("calendarDateForTime");
    
    TEST(nil == calendarDateForTime(NULL), "Passing NULL for argument returns nil");
    
    time.timeType = BER_TAG_UNKNOWN;
    time.time.Data = NULL;
    time.time.Length = 0;
    
    TEST(nil == calendarDateForTime(&time), "Passing time of type BER_TAG_UNKNOWN returns nil");
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = NULL;
    time.time.Length = 0;
    
    /* UTC Form
        
        yymmddHHMM[SS]Z
        yymmddHHMM[SS]sHHMM */
    
    TEST(nil == calendarDateForTime(&time), "Passing UTC time with NULL data and zero length returns nil");
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)0x12345678;
    time.time.Length = 0;
    
    TEST(nil == calendarDateForTime(&time), "Passing UTC time with non-NULL data and zero length returns nil");
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = NULL;
    time.time.Length = 11;
    
    TEST(nil == calendarDateForTime(&time), "Passing UTC time with NULL data and non-zero length returns nil");
    
    for (i = 0; i < 11; ++i) {
        time.timeType = BER_TAG_UTC_TIME;
        time.time.Data = (uint8_t*)"0505161617Z";
        time.time.Length = i;
        
        TEST(nil == calendarDateForTime(&time), "Passing [valid] UTC time fragment (length %d) returns nil", i);
    }
    
    for (i = 12; i < 20; i += 2) {
        time.timeType = BER_TAG_UTC_TIME;
        time.time.Data = (uint8_t*)"050516161730+1030Z"; /* No, this isn't valid; it's not meant to be. */
        time.time.Length = i;
    
        TEST(nil == calendarDateForTime(&time), "Passing [invalid] UTC time fragment (length %d) returns nil", i);
    }
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"0505161617Z";
    time.time.Length = 11;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid UTC time in yymmddHHMMZ format returns valid object");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"050516161730Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid UTC time in yymmddHHMMSSZ format returns valid object");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]) && (30 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"0505161617+1030";
    time.time.Length = 15;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid UTC time in yymmddHHMM+HHMM format returns valid object");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(int)(10.5 * 60 * 60)]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"050516161730+1030";
    time.time.Length = 17;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid UTC time in yymmddHHMMSS+HHMM format returns valid object");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(int)(10.5 * 60 * 60)]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]) && (30 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"491231235959Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 2049 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

        TEST((2049 == [date yearOfCommonEra]) && (12 == [date monthOfYear]) && (31 == [date dayOfMonth]) && (23 == [date hourOfDay]) && (59 == [date minuteOfHour]) && (59 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"500101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 1950 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

        TEST((1950 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"200101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 2020 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2020 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"240101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 2024 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2024 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"250101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 2025 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2025 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"260101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 2026 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2026 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"270101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 2027 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2027 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"280101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 2028 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2028 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"290101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 2029 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2029 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"300101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 2030 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2030 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"400101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 2040 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2040 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"600101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 1960 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((1960 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"700101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 1970 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((1970 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"800101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 1980 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((1980 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    time.timeType = BER_TAG_UTC_TIME;
    time.time.Data = (uint8_t*)"900101000000Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "UTC conversion for 1990 works");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((1990 == [date yearOfCommonEra]) && (1 == [date monthOfYear]) && (1 == [date dayOfMonth]) && (0 == [date hourOfDay]) && (0 == [date minuteOfHour]) && (0 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    
    
    /* Generalized Form
        
        yyyymmddHHMM[SS][.U][Z]
        yyyymmddHHMM[SS][.U]sHHMM */
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = NULL;
    time.time.Length = 0;
    
    TEST(nil == calendarDateForTime(&time), "Passing generalized time with NULL data and zero length returns nil");
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)0x12345678;
    time.time.Length = 0;
    
    TEST(nil == calendarDateForTime(&time), "Passing generalized time with non-NULL data and zero length returns nil");
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = NULL;
    time.time.Length = 11;
    
    TEST(nil == calendarDateForTime(&time), "Passing generalized time with NULL data and non-zero length returns nil");
    
    for (i = 0; i < 12; ++i) {
        time.timeType = BER_TAG_GENERALIZED_TIME;
        time.time.Data = (uint8_t*)"200505161617";
        time.time.Length = i;
        
        TEST(nil == calendarDateForTime(&time), "Passing [valid] generalized time fragment (length %d) returns nil", i);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"200505161617";
    time.time.Length = 12;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMM format returns valid object");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"200505161617Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMMZ format returns valid object");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"200505161617Z";
    time.time.Length = 13;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMMZ format returns valid object");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"200505161617+1030";
    time.time.Length = 17;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMM+1030 format returns valid object");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(int)(10.5 * 60 * 60)]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"20050516161730";
    time.time.Length = 14;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMMSS format returns valid object");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]) && (30 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"20050516161730+1030";
    time.time.Length = 19;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMMSS+HHMM format returns valid object");
    
    if (date) {
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(int)(10.5 * 60 * 60)]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]) && (30 == [date secondOfMinute]), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"200505161617.5";
    time.time.Length = 14;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMM.U format returns valid object");
    
    if (date) {
        NSCalendarDate *reference = [NSCalendarDate dateWithYear:2005 month:5 day:16 hour:16 minute:17 second:0 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        /*NSLog(@"Actual: %f\nReference: %f\nDifference: %f\n", [date timeIntervalSinceReferenceDate], [reference timeIntervalSinceReferenceDate], fabs([date timeIntervalSinceReferenceDate] - ([reference timeIntervalSinceReferenceDate] + 0.5)));*/
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]) && (fabs([date timeIntervalSinceReferenceDate] - ([reference timeIntervalSinceReferenceDate] + 0.5)) < 0.00001), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"20050516161730.5";
    time.time.Length = 16;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMMSS.U format returns valid object");
    
    if (date) {
        NSCalendarDate *reference = [NSCalendarDate dateWithYear:2005 month:5 day:16 hour:16 minute:17 second:30 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]) && (30 == [date secondOfMinute]) && (fabs([date timeIntervalSinceReferenceDate] - ([reference timeIntervalSinceReferenceDate] + 0.5)) < 0.00001), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"200505161617.5Z";
    time.time.Length = 15;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMM.UZ format returns valid object");
    
    if (date) {
        NSCalendarDate *reference = [NSCalendarDate dateWithYear:2005 month:5 day:16 hour:16 minute:17 second:0 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        /*NSLog(@"Actual: %f\nReference: %f\nDifference: %f\n", [date timeIntervalSinceReferenceDate], [reference timeIntervalSinceReferenceDate], fabs([date timeIntervalSinceReferenceDate] - ([reference timeIntervalSinceReferenceDate] + 0.5)));*/
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]) && (fabs([date timeIntervalSinceReferenceDate] - ([reference timeIntervalSinceReferenceDate] + 0.5)) < 0.00001), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"20050516161730.5Z";
    time.time.Length = 17;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMMSS.UZ format returns valid object");
    
    if (date) {
        NSCalendarDate *reference = [NSCalendarDate dateWithYear:2005 month:5 day:16 hour:16 minute:17 second:30 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]) && (30 == [date secondOfMinute]) && (fabs([date timeIntervalSinceReferenceDate] - ([reference timeIntervalSinceReferenceDate] + 0.5)) < 0.00001), "\tResult (%s) is correct", [[date description] UTF8String]);
        
        //TEST_NOTE("\tWoot = %f", [date timeIntervalSinceReferenceDate]);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"200505161617.5+1030";
    time.time.Length = 19;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMM.U+HHMM format returns valid object");
    
    if (date) {
        NSCalendarDate *reference = [NSCalendarDate dateWithYear:2005 month:5 day:16 hour:16 minute:17 second:0 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:(int)(10.5 * 60 * 60)]];
        
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(int)(10.5 * 60 * 60)]];
        
        /*NSLog(@"Actual: %f\nReference: %f\nDifference: %f\n", [date timeIntervalSinceReferenceDate], [reference timeIntervalSinceReferenceDate], fabs([date timeIntervalSinceReferenceDate] - ([reference timeIntervalSinceReferenceDate] + 0.5)));*/
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]) && (fabs([date timeIntervalSinceReferenceDate] - ([reference timeIntervalSinceReferenceDate] + 0.5)) < 0.00001), "\tResult (%s) is correct", [[date description] UTF8String]);
    }
    
    time.timeType = BER_TAG_GENERALIZED_TIME;
    time.time.Data = (uint8_t*)"20050516161730.5+1030";
    time.time.Length = 21;
    
    TEST(nil != (date = calendarDateForTime(&time)), "Passing valid generalized time in yyyymmddHHMMSS.U+HHMM format returns valid object");
    
    if (date) {
        NSCalendarDate *reference = [NSCalendarDate dateWithYear:2005 month:5 day:16 hour:16 minute:17 second:30 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:(int)(10.5 * 60 * 60)]];
        
        [date setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(int)(10.5 * 60 * 60)]];
        
        TEST((2005 == [date yearOfCommonEra]) && (5 == [date monthOfYear]) && (16 == [date dayOfMonth]) && (16 == [date hourOfDay]) && (17 == [date minuteOfHour]) && (30 == [date secondOfMinute]) && (fabs([date timeIntervalSinceReferenceDate] - ([reference timeIntervalSinceReferenceDate] + 0.5)) < 0.00001), "\tResult (%s) is correct", [[date description] UTF8String]);
        
        //TEST_NOTE("\tWoot = %f", [date timeIntervalSinceReferenceDate]);
    }
    
    END_TEST();
}

void test_timeForNSCalendarDate(void) {
    CSSM_X509_TIME time;
    NSCalendarDate *reference;
    
    START_TEST("timeForNSCalendarDate");
    
    reference = [NSCalendarDate dateWithYear:2005 month:5 day:16 hour:16 minute:17 second:30 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    time = timeForNSCalendarDate(reference, BER_TAG_GENERALIZED_TIME);

    TEST(0 == strncmp("20050516161730", (const char*)time.time.Data, 14), "Returns correct date given GMT date");
    
    //TEST_NOTE("GMT version is %s", [[NSString stringWithCString:(const char*)time.time.Data length:time.time.Length] UTF8String]);
    
    
    
    reference = [NSCalendarDate dateWithYear:2005 month:5 day:16 hour:16 minute:17 second:30 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:(int)(10.5 * 60 * 60)]];
    
    time = timeForNSCalendarDate(reference, BER_TAG_GENERALIZED_TIME);
    
    TEST(0 == strncmp("20050516054730", (const char*)time.time.Data, 14), "Returns correct date given +10:30 date");
    
    //TEST_NOTE("+10:30 version is %s", [[NSString stringWithCString:(const char*)time.time.Data length:time.time.Length] UTF8String]);
    
    
    
    reference = [NSCalendarDate dateWithYear:2049 month:12 day:31 hour:23 minute:59 second:59 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    time = timeForNSCalendarDate(reference, BER_TAG_UTC_TIME);

    TEST(0 == strncmp("491231235959Z", (const char*)time.time.Data, 13), "Returns correct UTC date for 2049");

    TEST_NOTE("2049 UTC date is %s", [[NSString stringWithCString:(const char*)time.time.Data length:time.time.Length] UTF8String]);
    
    
    
    reference = [NSCalendarDate dateWithYear:1950 month:1 day:1 hour:0 minute:0 second:0 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    time = timeForNSCalendarDate(reference, BER_TAG_UTC_TIME);
    
    TEST(0 == strncmp("500101000000Z", (const char*)time.time.Data, 13), "Returns correct UTC date for 1950");
    
    TEST_NOTE("1950 UTC date is %s", [[NSString stringWithCString:(const char*)time.time.Data length:time.time.Length] UTF8String]);
    
    
    
    reference = [NSCalendarDate dateWithYear:1949 month:12 day:31 hour:23 minute:59 second:59 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    time = timeForNSCalendarDate(reference, BER_TAG_UTC_TIME);
    
    TEST(0 == time.time.Length, "Correctly fails to convert 1949 date to UTC");
    
    TEST_NOTE("1949 UTC date is %s", [[NSString stringWithCString:(const char*)time.time.Data length:time.time.Length] UTF8String]);
    
    
    
    reference = [NSCalendarDate dateWithYear:2050 month:1 day:1 hour:0 minute:0 second:0 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    time = timeForNSCalendarDate(reference, BER_TAG_UTC_TIME);
    
    TEST(0 == time.time.Length, "Correctly fails to convert 2050 date to UTC");
    
    TEST_NOTE("2050 UTC date is %s", [[NSString stringWithCString:(const char*)time.time.Data length:time.time.Length] UTF8String]);
    
    
    END_TEST();
}

int main(int argc, char const *argv[]) {
#pragma unused (argc, argv) // We have no need for these right now.
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    test_calendarDateForTime();
    test_timeForNSCalendarDate();
    
    [pool release];

    FINAL_SUMMARY();    
}
