//
//  UIButton+Category.m
//  AFNetworking
//
//  Created by 王强 on 2018/6/6.
//

#import "UIButton+Category.h"
#import <objc/runtime.h>

static id key;
static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;
static CGFloat defaultInterval = 0.5; //默认点击的间隔时间

@interface UIButton ()

/**bool 类型 YES 不允许点击   NO 允许点击   设置是否执行点UI方法*/
@property (nonatomic, assign) BOOL isIgnoreEvent;

@end

@implementation UIButton (Category)

+ (UIButton *)initButton:(CGRect)rect btnImage:(UIImage *)image btnTitle:(NSString *)str {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rect];
    [button setTitle:str forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)initButton:(CGRect)rect btnNorImage:(UIImage *)image btnPressBtn:(UIImage *)press btnTitle:(NSString *)str {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rect];
    [button setTitle:str forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:press forState:UIControlStateHighlighted];
    return button;
}

+ (UIButton *)initButton:(CGRect)rect btnImage:(UIImage *)image btnTitle:(NSString *)str titleColor:(UIColor *)color titleFont:(float)font {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:str forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    return button;
}

+ (UIButton *)initButton:(CGRect)rect btnNorImage:(UIImage *)norImage btnHighlightImage:(UIImage *)highlightImage btnTitle:(NSString *)str titleColor:(UIColor *)color titleFont:(float)font {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setBackgroundImage:norImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button setTitle:str forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    return button;
}

+ (UIButton *)initButton:(CGRect)rect btnNorImage:(UIImage *)norImage btnDisableBtn:(UIImage *)disableImage btnTitle:(NSString *)str titleNorColor:(UIColor *)color1 titleSelectColor:(UIColor *)color2 titleFont:(float)font {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setImage:norImage forState:UIControlStateNormal];
    [button setImage:disableImage forState:UIControlStateHighlighted];
    [button setImage:disableImage forState:UIControlStateDisabled];
    [button setTitle:str forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitleColor:color1 forState:UIControlStateNormal];
    [button setTitleColor:color2 forState:UIControlStateHighlighted];
    [button setTitleColor:color2 forState:UIControlStateDisabled];
    button.adjustsImageWhenDisabled = NO;
    return button;
}

- (void)addBlock:(ClickActionBlock)clickBlock for:(UIControlEvents)event {
    objc_setAssociatedObject ( self , & key , clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC );
    [ self addTarget : self action : @selector (goAction:) forControlEvents :event];
}

- ( void )goAction:( UIButton *)sender{
    ClickActionBlock block = ( ClickActionBlock ) objc_getAssociatedObject ( self , & key );
    if (block) {
        block(sender);
    }
}

- (CGRect)enlargedRect {
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }else{
        return self.bounds;
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*) event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(mySendAction:to:forEvent:);
        Method methodA =   class_getInstanceMethod(self,selA);
        Method methodB = class_getInstanceMethod(self, selB);
        //将 methodB的实现 添加到系统方法中 也就是说 将 methodA方法指针添加成 方法methodB的  返回值表示是否添加成功
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        //添加成功了 说明 本类中不存在methodB 所以此时必须将方法b的实现指针换成方法A的，否则 b方法将没有实现。
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            //添加失败了 说明本类中 有methodB的实现，此时只需要将 methodA和methodB的IMP互换一下即可。
            method_exchangeImplementations(methodA, methodB);
        }
    });
}

- (NSTimeInterval)timeInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

//MARK: - 当我们按钮点击事件 sendAction 时  将会执行  mySendAction
- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        self.timeInterval =self.timeInterval ==0 ?defaultInterval:self.timeInterval;
        if (self.isIgnoreEvent){
            return;
        }else if (self.timeInterval > 0){
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
        }
    }
    //此处 methodA和methodB方法IMP互换了，实际上执行 sendAction；所以不会死循环
    self.isIgnoreEvent = YES;
    [self mySendAction:action to:target forEvent:event];
}

//MARK: - runtime 动态绑定 属性
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent{
    // 注意BOOL类型 需要用OBJC_ASSOCIATION_RETAIN_NONATOMIC 不要用错，否则set方法会赋值出错
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isIgnoreEvent{
    //_cmd == @select(isIgnore); 和set方法里一致
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)resetState{
    [self setIsIgnoreEvent:NO];
}

@end
