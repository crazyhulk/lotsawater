#import "CSTokenizer.h"

typedef struct CSToken
{
	id value;
	regex_t re;
} CSToken;

@implementation CSTokenizer

-(id)init
{
	if(self=[super init])
	{
		tokendata=[NSMutableData new];
		currdata=nil;
		captures=NULL;

		maxlookahead=0;

		maxcaptures=0;
		line=1;
	}
	return self;
}

-(void)dealloc
{
	CSToken *tokens=[tokendata mutableBytes];
	int n=[tokendata length]/sizeof(CSToken);
	for(int i=0;i<n;i++)
	{
		[tokens[i].value release];
		regfree(&tokens[i].re);
	}

	[tokendata release];
	[currdata release];

	free(captures);

	[super dealloc];
}

-(void)setMaxLookAhead:(int)maxbytes
{
	maxlookahead=maxbytes;
}


-(void)startTokenizingData:(NSData *)data
{
	[currdata autorelease];
	currdata=[data retain];

	startbyte=0;
	endbyte=[currdata length];

	prevcheck=0;
}

-(void)startTokenizingString:(NSString *)string
{
	[self startTokenizingData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

-(id)valueOfNextToken
{
	CSToken *tokens=[tokendata mutableBytes];
	int n=[tokendata length]/sizeof(CSToken);

	if(!captures) captures=malloc(sizeof(regmatch_t)*(maxcaptures+1));

	retrymatch:

	if(!currdata || startbyte>=endbyte) return nil;

	const char *bytes=[currdata bytes];
	for(currentregex=0;currentregex<n;currentregex++)
	{
		captures[0].rm_so=0;
		if(maxlookahead && startbyte+maxlookahead<endbyte) captures[0].rm_eo=maxlookahead;
		else captures[0].rm_eo=endbyte-startbyte;

		if(regexec(&tokens[currentregex].re,&bytes[startbyte],maxcaptures+1,captures,REG_STARTEND)==0)
		{
			int linecheck=startbyte+captures[0].rm_so;
			for(int i=prevcheck;i<linecheck;i++) if(bytes[i]=='\n') line++;
			prevcheck=linecheck;

			startbyte+=captures[0].rm_eo;

			if(tokens[currentregex].value) return tokens[currentregex].value;
			else goto retrymatch;
		}
	}

	char tmp[65];
	strncpy(tmp,bytes+startbyte,64);
	tmp[64]=0;

	[NSException raise:@"CSTokenizerException"
	format:@"Unexpected data in input text at line %d:\n\t%s",line,tmp];

	return nil;
}

-(NSString *)stringForCapture:(int)n
{
	const CSToken *tokens=[tokendata bytes];

	if(n>tokens[currentregex].re.re_nsub||n<0) [NSException raise:NSRangeException format:@"Index %d out of range for current regex",n];
	if(captures[n].rm_so==-1&&captures[n].rm_eo==-1) return nil;

	return [[[NSString alloc] initWithBytes:[currdata bytes]+startbyte-captures[0].rm_eo+captures[n].rm_so
	length:captures[n].rm_eo-captures[n].rm_so encoding:NSUTF8StringEncoding] autorelease];
}

-(NSData *)dataForCapture:(int)n
{
	const CSToken *tokens=[tokendata bytes];

	if(n>tokens[currentregex].re.re_nsub||n<0) [NSException raise:NSRangeException format:@"Index %d out of range for current regex",n];
	if(captures[n].rm_so==-1&&captures[n].rm_eo==-1) return nil;

	return [currdata subdataWithRange:NSMakeRange(startbyte-captures[0].rm_eo+captures[n].rm_so,captures[n].rm_eo-captures[n].rm_so)];
}

-(int)intForCapture:(int)n
{
	NSString *str=[self stringForCapture:n];
	if(str&&[str length]) return [str intValue];
	else return 0;
}

-(float)floatForCapture:(int)n
{
	NSString *str=[self stringForCapture:n];
	if(str&&[str length]) return [str floatValue];
	else return 0;
}


-(double)doubleForCapture:(int)n
{
	NSString *str=[self stringForCapture:n];
	if(str&&[str length]) return [str doubleValue];
	else return 0;
}


-(int)line { return line; }




-(void)addTokenWithValue:(id)value pattern:(NSString *)pattern;
{
	int n=[tokendata length]/sizeof(CSToken);
	[tokendata increaseLengthBy:sizeof(CSToken)];
	CSToken *tokens=[tokendata mutableBytes];

	tokens[n].value=[value retain];

	const char *patternstr=[pattern UTF8String];
	char patternbuf[strlen(patternstr)+2];
	strcpy(&patternbuf[1],patternstr);
	patternbuf[0]='^';

	int err=regcomp(&tokens[n].re,patternbuf,REG_EXTENDED);
	if(err)
	{
		char errbuf[256];
		regerror(err,&tokens[n].re,errbuf,sizeof(errbuf));
		[NSException raise:@"CSTokenizerException" format:@"Could not compile regex \"%@\": %s",pattern,errbuf];
	}

	if(tokens[n].re.re_nsub>maxcaptures)
	{
		maxcaptures=tokens[n].re.re_nsub;
		free(captures);
		captures=NULL;
	}
}

-(void)addIgnoredPattern:(NSString *)pattern
{
	[self addTokenWithValue:nil pattern:pattern];
}

-(void)addIgnoreWhitespacePattern
{
	[self addIgnoredPattern:@"[ \t\n\r]+"];
}

@end



@implementation CSTokenDispatcher

-(id)init
{
	if(self=[super init])
	{
		delegate=nil;
	}
	return self;
}

-(id)initWithDelegate:(id)parserdelegate
{
	if(self=[super init])
	{
		delegate=parserdelegate;
	}
	return self;
}

-(id)delegate { return delegate; }

-(void)setDelegate:(id)parserdelegate { delegate=parserdelegate; }

-(void)tokenizeAndDispatchForData:(NSData *)data
{
	[self startTokenizingData:data];

	NSValue *val;
	while(val=[self valueOfNextToken])
	{
		[delegate performSelector:(SEL)[val pointerValue] withObject:self];
	}
}

-(void)addTokenWithSelector:(SEL)selector pattern:(NSString *)pattern
{
	[self addTokenWithValue:[NSValue valueWithPointer:selector] pattern:pattern];
}

@end
