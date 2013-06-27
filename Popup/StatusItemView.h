@interface StatusItemView : NSView {
@private
    NSImage *_image;
    NSImage *_alternateImage;
    NSStatusItem *_statusItem;
    BOOL _isHighlighted;
    SEL _action;
    __unsafe_unretained id _target;
}

- (id)initWithStatusItem:(NSStatusItem *)statusItem;

- (void)displayCount:(int)count;

typedef enum {
    NEW,
    VIEWED,
    EMPTY,
    ERROR
} alertStatus_t;

@property (nonatomic, strong, readonly) NSStatusItem *statusItem;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSImage *alternateImage;
@property (nonatomic, setter = setHighlighted:) BOOL isHighlighted;
@property (nonatomic, readonly) NSRect globalRect;
@property (nonatomic) SEL action;
@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic, strong) NSString *title;

@property (nonatomic) alertStatus_t alertStatus;

/* Keeps track of the current number of messages that have been
 * read by the user. */
@property (nonatomic) int lastClickedCount;

// The last successful count retrieved.
@property (nonatomic) int lastCount;

@end
