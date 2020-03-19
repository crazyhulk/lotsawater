#import "LotsaView.h"

#import <sys/time.h>



@implementation LotsaView

-(id)initWithFrame:(NSRect)frame isPreview:(BOOL)preview useGL:(BOOL)usegl
{
	if((self=[super initWithFrame:frame isPreview:preview]))
	{
		ispreview=preview;

		savername=nil;
		configname=nil;
		clockwin=nil;
		clockpopup=nil;

		screen_w=(int)frame.size.width;
		screen_h=(int)frame.size.height;

		prevtime=starttime=0;

		if(usegl)
		{
			NSOpenGLPixelFormatAttribute attrs[]={ 
				//NSOpenGLPFAAllRenderers,
				//NSOpenGLPFASingleRenderer,
				NSOpenGLPFANoRecovery,
				NSOpenGLPFADoubleBuffer,
				NSOpenGLPFAAccelerated,
				//NSOpenGLPFAScreenMask,
				//[self getScreenMask],
				//NSOpenGLPFAAlphaSize,2,
				//NSOpenGLPFAColorSize,32,
				//NSOpenGLPFADepthSize,32,
				NSOpenGLPFADepthSize,16,
			(NSOpenGLPixelFormatAttribute)0};

			NSOpenGLPixelFormat *format=[[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
			view=[[NSOpenGLView alloc] initWithFrame:NSMakeRect(0,0,frame.size.width,frame.size.height) pixelFormat:format];

			if(view)
			{
				[self setAutoresizesSubviews:YES];
				[self addSubview:view];
				[view prepareOpenGL];

				[[view openGLContext] makeCurrentContext];

				GLint val=1;
				[[view openGLContext] setValues:&val forParameter:NSOpenGLCPSwapInterval];

				[NSOpenGLContext clearCurrentContext];

				if(![[self class] performGammaFade]) [view setHidden:YES];
			}
			else NSLog(@"Error: %@ failed to initialize NSOpenGLView!",[self description]);
		}
		else
		{
			view=nil;
		}
    }

    return self;
}

-(void)dealloc
{
//	[configname release];
//	[clockwin stopTimers];
//	[clockwin release];
//
//	[super dealloc];
}

-(void)finalize
{
	[clockwin stopTimers];
	[super finalize];
}

-(void)startAnimation
{
	[super startAnimation];

	[view setHidden:NO];

	if(!clockwin&&!ispreview)
	{
		int clocksize=[[self defaults] integerForKey:@"clockSize"];
		if(clocksize)
		{
			float divider;
			switch(clocksize)
			{
				case 1: divider=40; break;
				case 2: divider=24; break;
				default: divider=16; break;
			}

			clockwin=[[LotsaClockWindow alloc] initWithFont:[NSFont fontWithName:@"Futura-CondensedExtraBold" size:(double)screen_w/divider]];
			NSSize size=[clockwin frame].size;

			[clockwin setFrameOrigin:NSMakePoint(screen_w-size.width,screen_h-size.height)];
			[[self window] addChildWindow:clockwin ordered:NSWindowAbove];
		}
	}

	[self startAnimationWithDefaults:[self defaults]];
	prevtime=starttime=0;
}

-(void)startAnimationWithDefaults:(ScreenSaverDefaults *)defaults
{
}

-(BOOL)hasConfigureSheet
{
	return configname?YES:NO;
}

-(NSWindow *)configureSheet
{
	if(!configwindow)
	{
		NSNib *nib=[[NSNib alloc] initWithNibNamed:configname bundle:[NSBundle bundleForClass:[self class]]];
		[nib instantiateNibWithOwner:self topLevelObjects:nil];
	}

	ScreenSaverDefaults *defaults=[self defaults];
	[self updateConfigWindow:configwindow usingDefaults:defaults];
	[clockpopup selectItemAtIndex:[[self defaults] integerForKey:@"clockSize"]];

	return configwindow;
}



-(void)setSaverName:(NSString *)name andDefaults:(NSDictionary *)defdic
{
//	[savername autorelease];
//	savername=[name retain];
	[self setSaverDefaults:defdic];
}

-(void)setSaverDefaults:(NSDictionary *)defdic
{
	[[self defaults] registerDefaults:defdic];
}

-(void)setConfigName:(NSString *)name
{
//	[configname autorelease];
//	configname=[name retain];
    configname = name;
}

-(ScreenSaverDefaults *)defaults
{
	if(savername) return [ScreenSaverDefaults defaultsForModuleWithName:savername];
	return [ScreenSaverDefaults defaultsForModuleWithName:[[NSBundle bundleForClass:[self class]] bundleIdentifier]];
}

-(void)updateConfigWindow:(NSWindow *)window usingDefaults:(ScreenSaverDefaults *)defaults
{
}

-(void)updateDefaults:(ScreenSaverDefaults *)defaults usingConfigWindow:(NSWindow *)window
{
}

-(IBAction)configOk:(id)sender
{
	ScreenSaverDefaults *defaults=[self defaults];

	[self updateDefaults:defaults usingConfigWindow:configwindow];
	if(clockpopup) [defaults setInteger:[clockpopup indexOfSelectedItem] forKey:@"clockSize"];

	[defaults synchronize];

	[[NSApplication sharedApplication] endSheet:configwindow];
}

-(IBAction)configCancel:(id)sender
{
	[[NSApplication sharedApplication] endSheet:configwindow];
}

-(IBAction)configDefaults:(id)sender
{
	ScreenSaverDefaults *defaults=[self defaults];

	NSEnumerator *enumerator=[[defaults dictionaryRepresentation] keyEnumerator];
	NSString *key;
	while((key=[enumerator nextObject])) [defaults removeObjectForKey:key];

	[self updateConfigWindow:configwindow usingDefaults:defaults];
	[clockpopup selectItemAtIndex:[[self defaults] integerForKey:@"clockSize"]];

	[defaults synchronize];
}



-(NSOpenGLView *)view { return view; }

-(NSOpenGLContext *)openGLContext { return [view openGLContext]; }

-(BOOL)isPreview { return ispreview; }



-(double)absoluteTime
{
	struct timeval tv;
	gettimeofday(&tv,0);
	return (double)tv.tv_sec+((double)tv.tv_usec)/1000000.0;
}

-(double)time
{
	if(!starttime)
	{
		starttime=[self absoluteTime];
		return 0;
	}
	else return [self absoluteTime]-starttime;
}

-(double)deltaTime
{
	if(!prevtime)
	{
		prevtime=[self absoluteTime];
		return 0;
	}
	else
	{
		double time=[self absoluteTime];
		double dt=time-prevtime;
		prevtime=time;
		if(dt>0.1) dt=0.1;
		return dt;
	}
}




-(NSOpenGLPixelFormatAttribute)getScreenMaskForFrame:(NSRect)frame
{
	CGDirectDisplayID dispid;
	NSScreen *screen;
	NSEnumerator *enumerator=[[NSScreen screens] objectEnumerator];

	while((screen=[enumerator nextObject]))
	{
		if(!NSIsEmptyRect(NSIntersectionRect([screen frame],frame))) break;
	}

	if(screen) dispid=(CGDirectDisplayID)[[[screen deviceDescription] objectForKey:@"NSScreenNumber"] unsignedIntValue];
	else dispid=CGMainDisplayID();

	return CGDisplayIDToOpenGLDisplayMask(dispid);
}

-(NSBitmapImageRep *)grabScreenShot
{
	NSInteger windowid=[[self window] windowNumber];
	NSRect bounds=[[[self window] screen] frame];

	// Mavericks workaround: If the second window is loginwindow, use it as the base instead,
	// because it would otherwise block the view.
    NSArray *windows=(id)CFBridgingRelease(CGWindowListCopyWindowInfo(kCGWindowListOptionAll,kCGNullWindowID));
	if([windows count]>2)
	{
		NSDictionary *second=[windows objectAtIndex:1];
		NSString *owner=[second objectForKey:(NSString *)kCGWindowOwnerName];
		if([owner isEqual:@"loginwindow"])
		{
			windowid=[[second objectForKey:(NSString *)kCGWindowNumber] integerValue];
		}
	}

	// Geez Lousie, isn't there a sane way to convert these coordinate systems?
	NSRect mainscreen=[[NSScreen mainScreen] frame];
	NSEnumerator *enumerator=[[NSScreen screens] objectEnumerator];
	NSScreen *screen;
	while((screen=[enumerator nextObject]))
	{
		NSRect frame=[screen frame];
		if(frame.origin.x==0&&frame.origin.y==0) mainscreen=frame;
	}

	bounds.origin.y=-bounds.origin.y-bounds.size.height+mainscreen.size.height;

	CGImageRef image=CGWindowListCreateImage(NSRectToCGRect(bounds),
	kCGWindowListOptionOnScreenBelowWindow,
	windowid,kCGWindowImageBoundsIgnoreFraming);
    
	NSBitmapImageRep *rep=[[NSBitmapImageRep alloc] initWithCGImage:image];
	CGImageRelease(image);
    
	return rep;
}

-(NSBitmapImageRep *)imageRepFromBundle:(NSString *)name
{
	NSBundle *bundle=[NSBundle bundleForClass:[self class]];
	NSString *path=[bundle pathForResource:name ofType:nil];
	return [NSBitmapImageRep imageRepWithData:[NSData dataWithContentsOfFile:path]];
}

@end




@implementation LotsaClockWindow

-(id)initWithFont:(NSFont *)font
{
	view=[[LotsaClockView alloc] initWithFont:font];
	NSSize size=[view bounds].size;

	if((self=[super initWithContentRect:NSMakeRect(0,0,size.width,size.height) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO]))
	{
		[[self contentView] addSubview:view];

		[self setBackgroundColor:[NSColor clearColor]];
		[self setOpaque:NO];
		[self setAlphaValue:0];
		[self display];

		prevminutes=[[NSCalendarDate calendarDate] minuteOfHour];
		clocktimer=[NSTimer scheduledTimerWithTimeInterval:1
		target:self selector:@selector(clockTick:) userInfo:nil repeats:YES];

		fadeticks=0;
		fadetimer=[NSTimer scheduledTimerWithTimeInterval:1.0/30.0
		target:self selector:@selector(fadeTick:) userInfo:nil repeats:YES];
	}
	return self;
}

-(void)dealloc
{
//	[super dealloc];
}

-(void)clockTick:(NSTimer *)timer
{
	int minutes=[[NSCalendarDate calendarDate] minuteOfHour];
	//if(minutes!=prevminutes)
	{
		[view setNeedsDisplay:YES];
		prevminutes=minutes;
	}
}

-(void)fadeTick:(NSTimer *)timer
{
	fadeticks++;

	if(fadeticks>30)
	{
		float t=(float)(fadeticks-30)/60;
		[self setAlphaValue:t*t*(3-2*t)];
		if(fadeticks==90)
		{
			[fadetimer invalidate];
			fadetimer=nil;
		}
	}
}

-(void)stopTimers
{
	[clocktimer invalidate];
	[fadetimer invalidate];
	clocktimer=nil;
	fadetimer=nil;
}

@end



@implementation LotsaClockView

-(id)initWithFont:(NSFont *)f
{
	stroke=[f pointSize]/6;

	NSSize size=[[self pathFromString:@"88:88" atPoint:NSMakePoint(stroke,stroke) font:f] bounds].size;
	NSRect rect=NSMakeRect(0,0,size.width+2*stroke,size.height+2*stroke);

	if((self=[super initWithFrame:rect]))
	{
//		font=[f retain];
        font = f;
	}
	return self;
}

-(void)dealloc
{
//	[font release];
//	[super dealloc];
}

-(void)drawRect:(NSRect)rect
{
	NSString *str=[[NSDate date] descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
	NSBezierPath *path=[self pathFromString:str atPoint:NSMakePoint(stroke,stroke) font:font];
	[path setLineWidth:stroke];
	[path setMiterLimit:stroke/4];

//	[[NSColor redColor] set]; [NSBezierPath fillRect:[[self contentView] bounds]];
	[[NSColor blackColor] set]; [path stroke];
	[[NSColor whiteColor] set]; [path fill];
}

-(NSBezierPath *)pathFromString:(NSString *)str atPoint:(NSPoint)point font:(NSFont *)f
{
	NSTextView *textview=[[NSTextView alloc] init];
	[textview setString:str];
	[textview setFont:f];

	NSLayoutManager *layoutManager=[textview layoutManager];
	NSRange range=[layoutManager glyphRangeForCharacterRange:NSMakeRange(0,[str length]) actualCharacterRange:NULL];
	NSGlyph *glyphs=(NSGlyph *)malloc(sizeof(NSGlyph)*range.length*2);
	[layoutManager getGlyphs:glyphs range:range];

	NSBezierPath *path=[NSBezierPath bezierPath];
	[path moveToPoint:point];
	[path appendBezierPathWithGlyphs:glyphs count:range.length inFont:f];

	free(glyphs);
//	[textview release];

	return path;
}

@end
