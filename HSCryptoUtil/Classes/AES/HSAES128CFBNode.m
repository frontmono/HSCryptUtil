//
//  HSAES128CFBNode.m
//  HSCryptoUtil
//
//  Created by Hak Kim on 12/5/17.
//

#import "HSAES128CFBNode.h"
#import <CommonCrypto/CommonCryptor.h>


#define AES_CFB_KEY_SIZE        kCCKeySizeAES128



@interface HSAES128CFBNode()


@property (strong) NSData* ivData;
@property (strong) NSData* keyData;

@property (strong) NSString* keyHexadecimal;
@property (strong) NSString* ivHexadecimal;



- (void)createAESKey;
- (NSData*)dataFromHexidecimal:(NSString*)text;
- (NSString*)stringHexFromData:(NSData*)data;
- (void)dumpData:(NSData*)data;


@end

@implementation HSAES128CFBNode

- (id)init{
    self = [super init];
    [self createAESKey];
    return self;
}
- (void)createAESKey
{
    UInt8 buffer[AES_CFB_KEY_SIZE];
    if (self->_ivHexadecimal == nil) {
        NSString* str = @"";
        for (NSUInteger i = 0; i < AES_CFB_KEY_SIZE; i ++) {
            buffer[i] = (UInt8)(arc4random() % 256);
            str = [str stringByAppendingFormat:@"%02X", buffer[i]];
        }
        self.ivData = [[NSData alloc] initWithBytes:buffer length:AES_CFB_KEY_SIZE];
        self.ivHexadecimal = str;
    }
    
    
    if (self->_keyHexadecimal == nil) {
        NSString* str = @"";
        for (NSUInteger i = 0; i < AES_CFB_KEY_SIZE; i ++) {
            buffer[i] = (UInt8)(arc4random() % 256);
            str = [str stringByAppendingFormat:@"%02X", buffer[i]];
        }
        self.keyData = [[NSData alloc] initWithBytes:buffer length:AES_CFB_KEY_SIZE];
        self.keyHexadecimal = str;
    }
    
    
}
- (NSString*)testCryptoCFB8WithKey:(NSString*)keyHex ivHex:(NSString*)ivHex text:(NSString*)text isEncrypt:(BOOL)isEncrypt
{

    NSError *err = nil;
    NSData* dataKey = [self dataFromHexidecimal:keyHex];
    NSData* dataIV = [self dataFromHexidecimal:ivHex];
    
    NSString* res =  [self cryptOperation:isEncrypt?kCCEncrypt:kCCDecrypt key:dataKey iv:dataIV text:text error:&err];
    if (res) {
        return res;
    }
    NSLog(@"error %@", [err description]);
    return nil;
    
}


- (NSString*)cryptOperation:(CCOperation)op key:(NSData*)key iv:(NSData*)iv text:(NSString*)text error:(NSError**)error
{
    CCCryptorRef cryptor;
    CCCryptorStatus result = CCCryptorCreateWithMode(op,
                                                     kCCModeCFB8,
                                                     kCCAlgorithmAES128,
                                                     ccNoPadding,
                                                     [iv bytes],
                                                     [key bytes],
                                                     [key length],
                                                     NULL,
                                                     0,
                                                     0,
                                                     0,
                                                     &cryptor);
    
    if (result != kCCSuccess){
        if (error) {
            *error = [NSError errorWithDomain:@"Failed to create cryptor" code:0 userInfo:nil];
        }
        return nil;
    }
    NSData* originData = nil;
    if (op == kCCEncrypt) {
        originData = [NSData dataWithBytes:[text UTF8String] length:[text length]];
    }else{
        //Decryption이면 text가 Hexidecimal이다.
        originData = [self dataFromHexidecimal:text];
    }
    size_t bufferLength = CCCryptorGetOutputLength(cryptor, [originData length], true);
    NSMutableData *buffer = [NSMutableData dataWithLength:bufferLength];
    size_t outLength;
    NSMutableData *cipherData = [NSMutableData data];
    result = CCCryptorUpdate(cryptor,
                             [originData bytes],
                             [originData length],
                             [buffer mutableBytes],
                             [buffer length],
                             &outLength);
    if (result != kCCSuccess){
        if (error) {
            *error = [NSError errorWithDomain:@"Failed to encrypt" code:0 userInfo:nil];
        }
        CCCryptorRelease(cryptor);
        return nil;
    }
    [cipherData appendBytes:buffer.bytes length:outLength];
    
    result = CCCryptorFinal(cryptor,
                            [buffer mutableBytes],
                            [buffer length],
                            &outLength);
    
    // FIXME: Release cryptor and return error
    if (result != kCCSuccess){
        if (error) {
            *error = [NSError errorWithDomain:@"Failed to finalize" code:0 userInfo:nil];
        }
        CCCryptorRelease(cryptor);
        return nil;
    }
    
    NSString* strRes = nil;
    if (op == kCCEncrypt) {
        strRes = [self stringHexFromData:cipherData];
    }else{
        strRes = [NSString stringWithUTF8String:[cipherData bytes]];
        if ([strRes length] > [cipherData length]) {
            strRes = [strRes substringToIndex:[cipherData length] - 1];
        }
    }
    
    CCCryptorRelease(cryptor);
    return strRes;
    
}
- (NSString*)decryptCFB8:(NSString*)hexaString error:(NSError**)error
{
    return [self cryptOperation:kCCDecrypt key:_keyData iv:_ivData text:hexaString error:error];
}
- (NSString*)encryptCFB8:(NSString*)plainText error:(NSError**)error
{
    return [self cryptOperation:kCCEncrypt key:_keyData iv:_ivData text:plainText error:error];
}
- (NSData*)dataFromHexidecimal:(NSString*)text
{
    NSUInteger len = [text length];
    if (len == 0 || len % 2 == 1) {
        return nil;
    }
    UInt8* buffer = (UInt8*)malloc(len / 2);
    for (NSUInteger i = 0; i < len / 2; i ++) {
        NSString* subStr = [text substringWithRange:NSMakeRange(i * 2, 2)];
        UInt8 ch = strtoll([subStr UTF8String], NULL, 16);
        buffer[i] = ch;
    }
    NSData* data = [NSData dataWithBytes:buffer length:len/2];
    free(buffer);
    return data;
    return nil;
}
- (NSString*)stringHexFromData:(NSData*)data
{
    UInt8* p = (UInt8*)[data bytes];
    NSString* res = @"";
    for (NSUInteger i = 0; i < [data length]; i ++) {
        res = [res stringByAppendingFormat:@"%02X", p[i]];
    }
    return res;
}
- (void)dumpData:(NSData*)data
{
    UInt8* p = (UInt8*)[data bytes];
    printf("start dump data\n");
    for (NSUInteger i = 0; i < [data length]; i ++) {
        
        printf("index[%02tu] => %02X\n", i, p[i]);
    }
    printf("\n\n");
}


- (void)dealloc
{
   
}
@end
