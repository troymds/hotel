

#import <UIKit/UIKit.h>
#import "Dock.h"
#import "ChangeItemDelegate.h"

@interface DockController : UIViewController<ChangeItemDelegate>
{
    Dock *_dock;
}

@property (nonatomic, readonly) UIViewController *selectedController;
@property (nonatomic,assign) id<ChangeItemDelegate> delegate;

@end
