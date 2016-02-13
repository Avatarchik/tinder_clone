#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    ViewAlignmentTopLeft,
    ViewAlignmentTopCenter,
    ViewAlignmentTopRight,
    ViewAlignmentMiddleLeft,
    ViewAlignmentCenter,
    ViewAlignmentMiddleRight,
    ViewAlignmentBottomLeft,
    ViewAlignmentBottomCenter,
    ViewAlignmentBottomRight,
} ViewAlignment;

@interface UIView (Extensions)
@property (nonatomic) CGFloat vWidth;       // view.frame.size.width
@property (nonatomic) CGFloat vHeight;      // view.frame.size.height
@property (nonatomic, readonly) CGFloat vBWidth;      // view.bounds.size.width
@property (nonatomic, readonly) CGFloat vBHeight;     // view.bounds.size.height
@property (nonatomic) CGFloat vX;           // view.frame.origin.x
@property (nonatomic) CGFloat vY;           // view.frame.origin.y
@property (nonatomic) CGFloat vCX;          // view.center.x
@property (nonatomic) CGFloat vCY;          // view.center.y
@property (nonatomic) CGPoint vOrigin;      // view.frame.origin
@property (nonatomic) CGSize vSize;         // view.frame.size
@property (nonatomic) CGFloat vRightEdge;   // view.frame.origin.x + view.frame.size.width
@property (nonatomic) CGFloat vBottomEdge;  // view.frame.origin.y + view.frame.size.height
@property (nonatomic) NSString *debug;
@property (nonatomic) NSMutableDictionary *extensions;

+ (instancetype)horizontalLineAtY:(CGFloat)yOrigin;
+ (instancetype)verticalLineAtX:(CGFloat)xOrigin;
// Get the point at the center of the view's bounds
- (CGPoint)boundsCenter;

// Round frame coordinates to nearest integer
- (void)frameIntegral;

// Align the view relative to a point. Place the specified edge at the point
- (void)align:(ViewAlignment)alignment relativeToPoint:(CGPoint)point;

// Align the view relative to a rectangle
- (void)align:(ViewAlignment)alignment relativeToRect:(CGRect)rect;
@end
