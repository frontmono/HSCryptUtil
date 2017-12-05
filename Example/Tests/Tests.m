//
//  HSCryptoUtilTests.m
//  HSCryptoUtilTests
//
//  Created by HarryKim on 12/05/2017.
//  Copyright (c) 2017 HarryKim. All rights reserved.
//

@import XCTest;


#import <HSCryptoUtil/HSAES128CFBNode.h>


@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    HSAES128CFBNode* node = [[HSAES128CFBNode alloc] init];
    NSString* origin = @"adajnawkrernr#42323ajnsjadad";
    NSString* hexa = [node encryptCFB8:origin error:nil];
    XCTAssertTrue(hexa, @"encryption failed");
    
    hexa = [node decryptCFB8:hexa error:nil];
    BOOL isEqual = [origin isEqualToString:hexa];
    XCTAssertTrue(isEqual, @"No same");
    
    
}
- (void)testWithServer
{
    HSAES128CFBNode* node = [[HSAES128CFBNode alloc] init];
    NSString* origin = @"adajnawkrernr#42323ajnsjadad";
    NSString* plainText = [node testCryptoCFB8WithKey:@"044AA3C6364A2F520F849FF6CE2B3BD3"
                          ivHex:@"B7A9E7BCC740F9B994F94E21609E231F"
                           text:@"fb7d68f45e1c2d2e2bf6097bd3a7dc866c5e29f001dac6b084e7bf82"
                      isEncrypt:NO];
    
    BOOL isEqual = [origin isEqualToString:plainText];
    XCTAssertTrue(isEqual, @"No same");
}

@end

