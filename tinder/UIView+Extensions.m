#import <objc/runtime.h>
#import "UIView+Extensions.h"


@implementation UIView (Extensions)

+ (instancetype)horizontalLineAtY:(CGFloat)yOrigin {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, yOrigin, [UIScreen mainScreen].bounds.size.width, 1)];
    view.backgroundColor = [UIColor blackColor];
    return view;
}

+ (instancetype)verticalLineAtX:(CGFloat)xOrigin {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, xOrigin, [UIScreen mainScreen].bounds.size.width, 1)];
    view.backgroundColor = [UIColor blackColor];
    return view;
}

- (NSString *)debug {
    return self.extensions[@"debug"];
}

- (void)setDebug:(NSString *)tag {
    self.extensions[@"debug"] = tag;

    UILabel *topLabel;
    UILabel *bottomLabel;

    if (![self.extensions[@"debug"] length]) {
        topLabel = [[UILabel alloc] init];
        topLabel.font = [UIFont systemFontOfSize:7];
        topLabel.backgroundColor = [UIColor redColor];
        self.extensions[@"topLabel"] = topLabel;

        bottomLabel = [[UILabel alloc] init];
        bottomLabel.font = [UIFont systemFontOfSize:7];
        bottomLabel.backgroundColor = [UIColor blueColor];
        self.extensions[@"bottomLabel"] = bottomLabel;
    } else {
        topLabel = self.extensions[@"topLabel"];
        bottomLabel = self.extensions[@"bottomLabel"];
    }

    if (tag) {
        //self.backgroundColor = [UIColor hexColor:0xffffff alpha:0.35];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor redColor].CGColor;
        topLabel.frame = CGRectMake(3, 3, self.vBWidth - 6, 10);
        bottomLabel.frame = CGRectMake(3, self.vBHeight - 15, self.vBWidth - 6, 10);

        NSMutableString *text = [NSMutableString stringWithFormat:@"x:%.2f, y:%.2f, w:%.2f, h:%.2f ", self.vX, self.vY, self.vBWidth, self.vBHeight];
        if ([self isKindOfClass:[UIScrollView class]]) {
            UIScrollView *sv = (UIScrollView *)self;
            CGSize size = [sv contentSize];
            [text appendFormat:@"chw:%.2f, chh:%.2f", size.width, size.height];
        }

        text = [NSMutableString stringWithFormat:@"%@: %@", tag, text];

        topLabel.text = text;
        bottomLabel.text = text;
        if (![self.subviews containsObject:topLabel]) {
            [self addSubview:topLabel];
            [self addSubview:bottomLabel];
        }
    } else {
        //self.backgroundColor = [UIColor clearColor];
    }
}

- (CGPoint)vOrigin {
    return self.frame.origin;
}

- (CGSize)vSize {
    return self.frame.size;
}

- (CGFloat)vHeight {
    return self.frame.size.height;
}

- (CGFloat)vBHeight {
    return self.bounds.size.height;
}

- (CGFloat)vWidth {
    return self.frame.size.width;
}

- (CGFloat)vBWidth {
    return self.bounds.size.width;
}

- (CGFloat)vX {
    return self.frame.origin.x;
}

- (CGFloat)vY {
    return self.frame.origin.y;
}

- (CGFloat)vRightEdge {
    return self.vX + self.vWidth;
}

- (CGFloat)vBottomEdge {
    return self.vY + self.vHeight;
}

- (CGFloat)vCX {
    return self.center.x;
}

- (CGFloat)vCY {
    return self.center.y;
}


- (void)setVCX:(CGFloat)x {
    self.center = CGPointMake(x, self.center.y);
}

- (void)setVCY:(CGFloat)y {
    self.center = CGPointMake(self.center.x, y);
}


- (void)setVOrigin:(CGPoint)vOrigin {
    CGRect rect = self.frame;
    rect.origin = vOrigin;
    self.frame = rect;
}

- (void)setVSize:(CGSize)vSize {
    CGRect rect = self.frame;
    rect.size = vSize;
    self.frame = rect;
}

- (void)setVHeight:(CGFloat)vHeight {
    CGRect rect = self.frame;
    rect.size.height = vHeight;
    self.frame = rect;
}

- (void)setVWidth:(CGFloat)vWidth {
    CGRect rect = self.frame;
    rect.size.width = vWidth;
    self.frame = rect;
}

- (void)setVX:(CGFloat)vX {
    CGRect rect = self.frame;
    rect.origin.x = vX;
    self.frame = rect;
}

- (void)setVY:(CGFloat)vY {
    CGRect rect = self.frame;
    rect.origin.y = vY;
    self.frame = rect;
}

- (void)setVRightEdge:(CGFloat)vRightEdge {
    CGRect rect = self.frame;
    rect.origin.x = vRightEdge - self.vWidth;
    self.frame = rect;
}

- (void)setVBottomEdge:(CGFloat)vBottomEdge {
    CGRect rect = self.frame;
    rect.origin.y = vBottomEdge - self.vHeight;
    self.frame = rect;
}


- (CGPoint)boundsCenter {
    return CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2);
}

- (void)frameIntegral {
    self.frame = CGRectIntegral(self.frame);
}

- (void)align:(ViewAlignment)alignment relativeToPoint:(CGPoint)point {
    switch (alignment) {
        case ViewAlignmentTopLeft:
            self.vOrigin = CGPointMake(point.x, point.y);
            break;
        case ViewAlignmentTopCenter:
            self.vOrigin = CGPointMake(point.x - self.vWidth / 2, point.y);
            break;
        case ViewAlignmentTopRight:
            self.vOrigin = CGPointMake(point.x - self.vWidth, point.y);
            break;
        case ViewAlignmentMiddleLeft:
            self.vOrigin = CGPointMake(point.x, point.y - self.vHeight / 2);
            break;
        case ViewAlignmentCenter:
            self.center = CGPointMake(point.x, point.y);
            break;
        case ViewAlignmentMiddleRight:
            self.vOrigin = CGPointMake(point.x - self.vWidth, point.y - self.vHeight / 2);
            break;
        case ViewAlignmentBottomLeft:
            self.vOrigin = CGPointMake(point.x, point.y - self.vHeight);
            break;
        case ViewAlignmentBottomCenter:
            self.vOrigin = CGPointMake(point.x - self.vWidth / 2, point.y - self.vHeight);
            break;
        case ViewAlignmentBottomRight:
            self.vOrigin = CGPointMake(point.x - self.vWidth, point.y - self.vHeight);
            break;
        default:
            break;
    }

    //just to be safe
    [self frameIntegral];
}

- (void)align:(ViewAlignment)alignment relativeToRect:(CGRect)rect {
    CGPoint point = CGPointZero;
    switch (alignment) {
        case ViewAlignmentTopLeft:
            point = rect.origin;
            break;
        case ViewAlignmentTopCenter:
            point = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y);
            break;
        case ViewAlignmentTopRight:
            point = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
            break;
        case ViewAlignmentMiddleLeft:
            point = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2);
            break;
        case ViewAlignmentCenter:
            point = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
            break;
        case ViewAlignmentMiddleRight:
            point = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2);
            break;
        case ViewAlignmentBottomLeft:
            point = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
            break;
        case ViewAlignmentBottomCenter:
            point = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height);
            break;
        case ViewAlignmentBottomRight:
            point = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
            break;
        default:
            return;
    }
    [self align:alignment relativeToPoint:point];
}

- (NSMutableDictionary *)extensions {
    id obj = objc_getAssociatedObject(self, @selector(extensions));
    if (!obj) {
        obj = [[NSMutableDictionary alloc] init];
        self.extensions = obj;
    }
    return obj;
}

- (void)setExtensions:(NSMutableDictionary *)extensions {
    objc_setAssociatedObject(self, @selector(extensions), extensions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
