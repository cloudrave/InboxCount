#define STATUS_ITEM_VIEW_WIDTH 30.0

#pragma mark -

@class StatusItemView;

@interface MenubarController : NSObject {
@private
    StatusItemView *_statusItemView;
}

- (void)updateCount;

@property (nonatomic) BOOL hasActiveIcon;

// YES when system is blocked from connecting to the internet.
@property (nonatomic) BOOL connectionsAreBlocked;

@property (nonatomic, strong, readonly) NSStatusItem *statusItem;
@property (nonatomic, strong, readonly) StatusItemView *statusItemView;


@end
