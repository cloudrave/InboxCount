#import "StatusItemView.h"

@implementation StatusItemView

@synthesize statusItem = _statusItem;
@synthesize image = _image;
@synthesize alternateImage = _alternateImage;
@synthesize isHighlighted = _isHighlighted;
@synthesize action = _action;
@synthesize target = _target;
@synthesize title = _title;
@synthesize alertStatus = _alertStatus;
@synthesize lastClickedCount = _lastClickedCount;
@synthesize lastCount = _lastCount;

NSTimer *alertTimer;

#pragma mark -

- (id)initWithStatusItem:(NSStatusItem *)statusItem
{
    CGFloat itemWidth = [statusItem length];
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);
    self = [super initWithFrame:itemRect];
    
    if (self != nil) {
        _statusItem = statusItem;
        _statusItem.view = self;
    }
    
    self.lastCount = 0;
    
    return self;
}

#pragma mark -

- (void)drawRect:(NSRect)dirtyRect
{        
	[self.statusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:self.isHighlighted];
    
    NSString *title;
    NSColor *color = [NSColor blackColor];
    NSColor *backgroundColor = [NSColor clearColor];
    NSFont *font = [NSFont fontWithName:@"Times-Bold" size:16.0];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    [style setAlignment:NSCenterTextAlignment];
    
    if (self.title) {
        title = self.title;
        int count = (int)[title integerValue];
        //NSLog(@"total: %d \nread: %d", count, self.lastClickedCount);
        
        if (count == 0) {
            self.alertStatus = EMPTY;
            
            // also reset number of read messages
            self.lastClickedCount = 0;
        }
        else {
            if (self.lastClickedCount >= count) {
                self.alertStatus = VIEWED;
            } else {
                self.alertStatus = NEW;
                
                if (count > self.lastCount) {
                    // Starts playing sound.
                    [self beginAlerting];
                    
                    // Sends notification to screen.
                    NSUserNotification *notification = [[NSUserNotification alloc] init];
                    notification.title = @"You have important email.";
                    notification.informativeText = @"You may want to check it.";
                    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
                }
            }
        }
        self.lastCount = count;
    } else {
        self.alertStatus = ERROR;
    }
    
    switch (self.alertStatus) {
        case EMPTY:
            title = @"☺";
            font = [NSFont fontWithName:@"Batang" size:18];
            break;
        case ERROR:
            title = @"---";
            break;
        case VIEWED:
            color = [NSColor colorWithCalibratedRed:(142./255.) green:(157./255.) blue:(245./255.) alpha:1];
            backgroundColor = [NSColor colorWithCalibratedWhite:0.25 alpha:1];
            break;
        case NEW:
            color = [NSColor colorWithCalibratedRed:1. green:(66./255.) blue:(60./255.) alpha:1];
            backgroundColor = [NSColor blackColor];
            break;
    }

    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color, NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, backgroundColor, NSBackgroundColorAttributeName, nil];
    
    NSRect viewBounds = [self bounds];
    [backgroundColor set];
    NSRectFill(viewBounds);
    NSRect backgroundRect;
    backgroundRect.origin.x = 0;
    backgroundRect.origin.y = 0;
    backgroundRect.size.height = 100;
    backgroundRect.size.width = 100;
    
    [title drawInRect:dirtyRect withAttributes:attr];
}

#pragma mark -
#pragma mark Mouse tracking

- (void)mouseDown:(NSEvent *)theEvent
{
    //self.alertStatus = VIEWED;
    //NSLog(self.title);
    self.lastClickedCount = [self.title integerValue];
    [self setNeedsDisplay:YES];
    
    [self endAlerting];
    
    [NSApp sendAction:self.action to:self.target from:self];
}

- (void)playAlertSound {
    // Plays sound.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AudioAlertsAreEnabled"]) {
        [[NSSound soundNamed:@"Submarine"] play];
    }
}


- (void)beginAlerting {
    if (alertTimer) {
        [self endAlerting];
    }
    
    [self playAlertSound];
    alertTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(playAlertSound) userInfo:nil repeats:YES];
    
    // Stop alerting after time.
    [NSTimer scheduledTimerWithTimeInterval:180. target:self selector:@selector(endAlerting) userInfo:nil repeats:NO];
}

- (void)endAlerting {
    if (alertTimer) {
        [alertTimer invalidate];
        alertTimer = nil;
    }
}


#pragma mark -
#pragma mark Accessors

- (void)setHighlighted:(BOOL)newFlag
{
    if (_isHighlighted == newFlag) return;
    _isHighlighted = newFlag;
    [self setNeedsDisplay:YES];
}

#pragma mark -

- (void)setImage:(NSImage *)newImage
{
    if (_image != newImage) {
        _image = newImage;
        [self setNeedsDisplay:YES];
    }
}

- (void)setAlternateImage:(NSImage *)newImage
{
    if (_alternateImage != newImage) {
        _alternateImage = newImage;
        if (self.isHighlighted) {
            [self setNeedsDisplay:YES];
        }
    }
}

#pragma mark -

- (NSRect)globalRect
{
    NSRect frame = [self frame];
    frame.origin = [self.window convertBaseToScreen:frame.origin];
    return frame;
}

- (void)displayCount:(int)count {
    [self setNeedsDisplay:YES];
}


@end
