#import "CSBinaryReader.h"

NSString *CSBinaryReaderEOFException=@"CSBinaryReaderEOFException";
NSString *CSBinaryReaderInvalidSeekException=@"CSBinaryReaderInvalidSeekException";

@implementation CSBinaryReader

static inline void RequireBytes(CSBinaryReader *self,off_t bytes)
{
	if(self->pos+bytes>self->length) [NSException raise:CSBinaryReaderEOFException
	format:@"Attempted to read past end of data"];
}

+(CSBinaryReader *)binaryReaderForData:(NSData *)filedata
{
	return [[[self alloc] initWithData:filedata] autorelease];
}

+(CSBinaryReader *)binaryReaderForPath:(NSString *)path
{
	#ifdef __APPLE__
	NSData *filedata=[NSData dataWithContentsOfMappedFile:path];
	#else
	NSData *filedata=[NSData dataWithContentsOfFile:path];
	#endif

	if(!filedata) return nil;
	return [[[self alloc] initWithData:filedata] autorelease];
}

+(CSBinaryReader *)binaryReaderForBytes:(const void *)bytes length:(off_t)length
{
	return [[[self alloc] initWithData:[NSData dataWithBytes:bytes length:length]] autorelease];
}

-(id)initWithData:(NSData *)filedata
{
	if(self=[super init])
	{
		data=[filedata retain];
		bytes=[data bytes];
		length=[data length];
		pos=0;
	}
	return self;
}

-(void)dealloc
{
	[data release];
	[super dealloc];
}

-(off_t)length { return length; }

-(off_t)currentOffset { return pos; }

-(BOOL)atEndOfFile { return pos==length; }

-(void)seekToOffset:(off_t)offs
{
	if(offs<0) [NSException raise:CSBinaryReaderInvalidSeekException format:@"Tried to seek to before beginning of data"];
	if(offs>length) [NSException raise:CSBinaryReaderEOFException format:@"Tried to seek past end of data"];
	pos=offs;
}

-(void)skipBytes:(off_t)num
{
	if(pos+num<0) [NSException raise:CSBinaryReaderInvalidSeekException format:@"Tried to seek to before beginning of data"];
	if(pos+num>length) [NSException raise:CSBinaryReaderEOFException format:@"Tried to seek past end of data"];
	pos+=num;
}

-(void)seekToEndOfFile{ pos=length;}

-(int8_t)readInt8
{
	RequireBytes(self,1);
	int8_t val=(int8_t)bytes[pos];
	pos+=1;
	return val;
}

-(uint8_t)readUInt8
{
	RequireBytes(self,1);
	uint8_t val=(uint8_t)bytes[pos];
	pos+=1;
	return val;
}

-(int16_t)readInt16BE
{
	RequireBytes(self,2);
	int16_t val=CSInt16BE(&bytes[pos]);
	pos+=2;
	return val;
}

-(int32_t)readInt32BE
{
	RequireBytes(self,4);
	int32_t val=CSInt32BE(&bytes[pos]);
	pos+=4;
	return val;
}

-(int64_t)readInt64BE
{
	RequireBytes(self,8);
	int64_t val=CSInt64BE(&bytes[pos]);
	pos+=8;
	return val;
}

-(uint16_t)readUInt16BE
{
	RequireBytes(self,2);
	uint16_t val=CSUInt16BE(&bytes[pos]);
	pos+=2;
	return val;
}

-(uint32_t)readUInt32BE
{
	RequireBytes(self,4);
	uint32_t val=CSUInt32BE(&bytes[pos]);
	pos+=4;
	return val;
}

-(uint64_t)readUInt64BE
{
	RequireBytes(self,8);
	uint64_t val=CSUInt64BE(&bytes[pos]);
	pos+=8;
	return val;
}

-(float)readFloatBE
{
	RequireBytes(self,4);
	float val=CSFloatBE(&bytes[pos]);
	pos+=4;
	return val;
}

-(int16_t)readInt16LE
{
	RequireBytes(self,2);
	int16_t val=CSInt16LE(&bytes[pos]);
	pos+=2;
	return val;
}

-(int32_t)readInt32LE
{
	RequireBytes(self,4);
	int32_t val=CSInt32LE(&bytes[pos]);
	pos+=4;
	return val;
}

-(int64_t)readInt64LE
{
	RequireBytes(self,8);
	int64_t val=CSInt64LE(&bytes[pos]);
	pos+=8;
	return val;
}

-(uint16_t)readUInt16LE
{
	RequireBytes(self,2);
	uint16_t val=CSUInt16LE(&bytes[pos]);
	pos+=2;
	return val;
}

-(uint32_t)readUInt32LE
{
	RequireBytes(self,4);
	uint32_t val=CSUInt32LE(&bytes[pos]);
	pos+=4;
	return val;
}

-(uint64_t)readUInt64LE
{
	RequireBytes(self,8);
	uint64_t val=CSUInt64LE(&bytes[pos]);
	pos+=8;
	return val;
}

-(float)readFloatLE
{
	RequireBytes(self,4);
	float val=CSFloatLE(&bytes[pos]);
	pos+=4;
	return val;
}

-(void)readBytes:(off_t)num toBuffer:(void *)buffer
{
	RequireBytes(self,num);
	memcpy(buffer,&bytes[pos],num);
	pos+=num;
}

-(off_t)readAtMost:(off_t)num toBuffer:(void *)buffer
{
	if(num>length-pos) num=length-pos;
	memcpy(buffer,&bytes[pos],num);
	pos+=num;
	return num;
}

-(NSData *)readDataOfLength:(off_t)num
{
	RequireBytes(self,num);
	NSData *sub=[data subdataWithRange:NSMakeRange(pos,num)];
	pos+=num;
	return sub;
}

-(NSData *)readDataOfLengthAtMost:(off_t)num
{
	if(num>length-pos) num=length-pos;
	NSData *sub=[data subdataWithRange:NSMakeRange(pos,num)];
	pos+=num;
	return sub;
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"<%@ of length %lld at offset %lld>",[self class],length,pos];
}

@end
