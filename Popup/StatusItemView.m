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
        NSLog(@"total: %d \nread: %d", count, self.lastClickedCount);
        
        if (count == 0) {
            self.alertStatus = EMPTY;
            
            // also reset number of read messages
            self.lastClickedCount = 0;
        }
        else {
            if (self.lastClickedCount && self.lastClickedCount >= count) {
                self.alertStatus = VIEWED;
            } else {
                self.alertStatus = NEW;
            }
        }
    } else {
        self.alertStatus = ERROR;
    }
    
    
    switch (self.alertStatus) {
        case EMPTY:
            NSLog(@"EMPTY");
            title = @"☺";
            font = [NSFont fontWithName:@"Batang" size:18];
            break;
        case ERROR:
            NSLog(@"ERROR");
            title = @"---";
            break;
        case VIEWED:
            NSLog(@"VIEWED");
            color = [NSColor colorWithCalibratedRed:(142./255.) green:(157./255.) blue:(245./255.) alpha:1];
            backgroundColor = [NSColor colorWithCalibratedWhite:0.25 alpha:1];
            break;
        case NEW:
            NSLog(@"NEW");
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
    
    [NSApp sendAction:self.action to:self.target from:self];
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
