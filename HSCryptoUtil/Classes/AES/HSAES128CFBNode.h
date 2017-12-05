//
//  HSAES128CFBNode.h
//  HSCryptoUtil
//
//  Created by Hak Kim on 12/5/17.
//

#import <Foundation/Foundation.h>

@interface HSAES128CFBNode : NSObject
@property (nonatomic, retain, readonly) NSString* ivHexadecimal;
@property (nonatomic, retain, readonly) NSString* keyHexadecimal;


- (NSString*)encryptCFB8:(NSString*)hexaString error:(NSError**)error;
- (NSString*)decryptCFB8:(NSString*)plainText error:(NSError**)error;

- (NSString*)testCryptoCFB8WithKey:(NSString*)keyHex ivHex:(NSString*)ivHex text:(NSString*)text isEncrypt:(BOOL)isEncrypt;
@end
