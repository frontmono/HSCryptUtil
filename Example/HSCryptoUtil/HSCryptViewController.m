//
//  HSCryptViewController.m
//  HSCryptoUtil
//
//  Created by HarryKim on 12/05/2017.
//  Copyright (c) 2017 HarryKim. All rights reserved.
//

#import "HSCryptViewController.h"
#import "HSAES128CFBNode.h"
@interface HSCryptViewController ()

@end

@implementation HSCryptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    HSAES128CFBNode* aes128 = [[HSAES128CFBNode alloc] init];
    NSString* decText = [aes128 testCryptoCFB8WithKey:@"186A69918F22F4479D3DEA6E45587360"
                                                ivHex:@"1816227195CEBE78D5600E30319773BD" text:@"80D97708B16486D013F3A0D8D0F201A4D1B2BBC4C4DEF21B0519A8BA406D7B3998980DA4"
                                            isEncrypt:NO];
    NSLog(@"%@", decText);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
