#import <Foundation/Foundation.h>

extern NSString *CSBinaryReaderEOFException;
extern NSString *CSBinaryReaderInvalidSeekException;

#import "../NameMangler.h"
#define CSBinaryReader MangleClassName(CSBinaryReader)

@interface CSBinaryReader:NSObject
{
	NSData *data;
	const uint8_t *bytes;
	off_t length,pos;
}

+(CSBinaryReader *)binaryReaderForData:(NSData *)filedata;
+(CSBinaryReader *)binaryReaderForPath:(NSString *)path;
+(CSBinaryReader *)binaryReaderForBytes:(const void *)bytes length:(off_t)length;

-(id)initWithData:(NSData *)filedata;
-(void)dealloc;

-(off_t)length;
-(off_t)currentOffset;
-(BOOL)atEndOfFile;
-(void)seekToOffset:(off_t)offs;
-(void)skipBytes:(off_t)num;
-(void)seekToEndOfFile;

-(int8_t)readInt8;
-(uint8_t)readUInt8;

-(int16_t)readInt16BE;
-(int32_t)readInt32BE;
-(int64_t)readInt64BE;
-(uint16_t)readUInt16BE;
-(uint32_t)readUInt32BE;
-(uint64_t)readUInt64BE;
-(float)readFloatBE;

-(int16_t)readInt16LE;
-(int32_t)readInt32LE;
-(int64_t)readInt64LE;
-(uint16_t)readUInt16LE;
-(uint32_t)readUInt32LE;
-(uint64_t)readUInt64LE;
-(float)readFloatLE;

-(void)readBytes:(off_t)num toBuffer:(void *)buffer;
-(off_t)readAtMost:(off_t)num toBuffer:(void *)buffer;
-(NSData *)readDataOfLength:(off_t)num;
-(NSData *)readDataOfLengthAtMost:(off_t)num;

-(NSString *)description;

@end

static inline int16_t CSInt16BE(const uint8_t *b) { return ((int16_t)b[0]<<8)|(int16_t)b[1]; }
static inline int32_t CSInt32BE(const uint8_t *b) { return ((int32_t)b[0]<<24)|((int32_t)b[1]<<16)|((int32_t)b[2]<<8)|(int32_t)b[3]; }
static inline int64_t CSInt64BE(const uint8_t *b) { return ((int64_t)b[0]<<56)|((int64_t)b[1]<<48)|((int64_t)b[2]<<40)|((int64_t)b[3]<<32)|((int64_t)b[4]<<24)|((int64_t)b[5]<<16)|((int64_t)b[6]<<8)|(int64_t)b[7]; }
static inline uint16_t CSUInt16BE(const uint8_t *b) { return ((uint16_t)b[0]<<8)|(uint16_t)b[1]; }
static inline uint32_t CSUInt32BE(const uint8_t *b) { return ((uint32_t)b[0]<<24)|((uint32_t)b[1]<<16)|((uint32_t)b[2]<<8)|(uint32_t)b[3]; }
static inline uint64_t CSUInt64BE(const uint8_t *b) { return ((uint64_t)b[0]<<56)|((uint64_t)b[1]<<48)|((uint64_t)b[2]<<40)|((uint64_t)b[3]<<32)|((uint64_t)b[4]<<24)|((uint64_t)b[5]<<16)|((uint64_t)b[6]<<8)|(uint64_t)b[7]; }
static inline float CSFloatBE(const uint8_t *b) { union { float f; uint32_t i; } u; u.i=CSUInt32BE(b); return u.f; }

static inline int16_t CSInt16LE(const uint8_t *b) { return ((int16_t)b[1]<<8)|(int16_t)b[0]; }
static inline int32_t CSInt32LE(const uint8_t *b) { return ((int32_t)b[3]<<24)|((int32_t)b[2]<<16)|((int32_t)b[1]<<8)|(int32_t)b[0]; }
static inline int64_t CSInt64LE(const uint8_t *b) { return ((int64_t)b[7]<<56)|((int64_t)b[6]<<48)|((int64_t)b[5]<<40)|((int64_t)b[4]<<32)|((int64_t)b[3]<<24)|((int64_t)b[2]<<16)|((int64_t)b[1]<<8)|(int64_t)b[0]; }
static inline uint16_t CSUInt16LE(const uint8_t *b) { return ((uint16_t)b[1]<<8)|(uint16_t)b[0]; }
static inline uint32_t CSUInt32LE(const uint8_t *b) { return ((uint32_t)b[3]<<24)|((uint32_t)b[2]<<16)|((uint32_t)b[1]<<8)|(uint32_t)b[0]; }
static inline uint64_t CSUInt64LE(const uint8_t *b) { return ((uint64_t)b[7]<<56)|((uint64_t)b[6]<<48)|((uint64_t)b[5]<<40)|((uint64_t)b[4]<<32)|((uint64_t)b[3]<<24)|((uint64_t)b[2]<<16)|((uint64_t)b[1]<<8)|(uint64_t)b[0]; }
static inline float CSFloatLE(const uint8_t *b) { union { float f; uint32_t i; } u; u.i=CSUInt32LE(b); return u.f; }
