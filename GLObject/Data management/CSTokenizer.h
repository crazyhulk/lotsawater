#import <Foundation/Foundation.h>

#ifdef __APPLE__
#import "regex.h"
#else
#import "regex.h"
#endif

#import "../NameMangler.h"
#define CSTokenizer MangleClassName(CSTokenizer)
#define CSTokenDispatcher MangleClassName(TokenDispatcher)

@interface CSTokenizer:NSObject
{
	NSMutableData *tokendata;
	NSData *currdata;
	regmatch_t *captures;
	int maxlookahead;
	int maxcaptures,currentregex,startbyte,endbyte;
	int line,prevcheck;
}

-(id)init;
-(void)dealloc;

-(void)setMaxLookAhead:(int)maxbytes;

-(void)startTokenizingData:(NSData *)data;
-(void)startTokenizingString:(NSString *)string;
-(id)valueOfNextToken;

-(NSString *)stringForCapture:(int)n;
-(NSData *)dataForCapture:(int)n;
-(int)intForCapture:(int)n;
-(float)floatForCapture:(int)n;
-(double)doubleForCapture:(int)n;
-(int)line;

-(void)addTokenWithValue:(id)value pattern:(NSString *)pattern;
-(void)addIgnoredPattern:(NSString *)pattern;
-(void)addIgnoreWhitespacePattern;

@end


@interface CSTokenDispatcher:CSTokenizer
{
	id delegate;
}

-(id)init;
-(id)initWithDelegate:(id)parserdelegate;

-(id)delegate;
-(void)setDelegate:(id)parserdelegate;

-(void)tokenizeAndDispatchForData:(NSData *)data;

-(void)addTokenWithSelector:(SEL)selector pattern:(NSString *)pattern;

@end
