#import <ScreenSaver/ScreenSaver.h>

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

#import "NameMangler.h"
#define LotsaView MangleClassName(LotsaView)
#define LotsaClockWindow MangleClassName(LotsaClockWindow)
#define LotsaClockView MangleClassName(LotsaClockView)

@class LotsaClockWindow,LotsaClockView;

@interface LotsaView:ScreenSaverView
{
	BOOL ispreview;
	NSOpenGLView *view;
	double starttime,prevtime;
	int screen_w,screen_h;
	LotsaClockWindow *clockwin;

	NSString *savername,*configname;

	IBOutlet NSWindow *configwindow;
	IBOutlet NSPopUpButton *clockpopup;
}

-(id)initWithFrame:(NSRect)frame isPreview:(BOOL)preview useGL:(BOOL)usegl;
-(void)dealloc;
-(void)finalize;

-(void)startAnimation;
-(void)startAnimationWithDefaults:(ScreenSaverDefaults *)defaults;

-(BOOL)hasConfigureSheet;
-(NSWindow *)configureSheet;

-(void)setSaverName:(NSString *)name andDefaults:(NSDictionary *)defdic;
-(void)setSaverDefaults:(NSDictionary *)defdic;
-(void)setConfigName:(NSString *)name;

-(ScreenSaverDefaults *)defaults;

-(void)updateConfigWindow:(NSWindow *)window usingDefaults:(ScreenSaverDefaults *)defaults;
-(void)updateDefaults:(ScreenSaverDefaults *)defaults usingConfigWindow:(NSWindow *)window;

-(IBAction)configOk:(id)sender;
-(IBAction)configCancel:(id)sender;
-(IBAction)configDefaults:(id)sender;

-(NSOpenGLView *)view;
-(NSOpenGLContext *)openGLContext;
-(BOOL)isPreview;

-(double)absoluteTime;
-(double)time;
-(double)deltaTime;

-(NSOpenGLPixelFormatAttribute)getScreenMaskForFrame:(NSRect)frame;
-(NSBitmapImageRep *)grabScreenShot;

-(NSBitmapImageRep *)imageRepFromBundle:(NSString *)name;

@end



@interface LotsaClockWindow:NSWindow
{
	LotsaClockView *view;
	NSTimer *clocktimer,*fadetimer;
	int prevminutes;
	int fadeticks;
}

-(id)initWithFont:(NSFont *)f;
-(void)dealloc;

-(void)clockTick:(NSTimer *)timer;
-(void)fadeTick:(NSTimer *)timer;
-(void)stopTimers;


@end



@interface LotsaClockView:NSView
{
	NSFont *font;
	float stroke;
}

-(id)initWithFont:(NSFont *)f;
-(void)dealloc;

-(void)drawRect:(NSRect)rect;
-(NSBezierPath *)pathFromString:(NSString *)str atPoint:(NSPoint)point font:(NSFont *)f;

@end
