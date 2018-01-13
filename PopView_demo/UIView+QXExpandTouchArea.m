//
//  UIView+QXExpandTouchArea.m
//  Loopsone
//
//  Created by UI on 2017/2/6.
//  Copyright © 2017年 Kingsingmobi. All rights reserved.
//

#import "UIView+QXExpandTouchArea.h"
#import <objc/runtime.h>
const char *kExpandEdge = '\0';



@implementation UIView (QXExpandTouchArea)



+(void)load{

    
    Method ori = class_getInstanceMethod([self class], @selector(pointInside:withEvent:));
    
    Method qx_relpaced = class_getInstanceMethod([self class], @selector(qx_pointInside:withEvent:));
    
    method_exchangeImplementations(ori, qx_relpaced);
    

}


-(void)setExpandEdge:(UIEdgeInsets)expandEdge{
    
    
    objc_setAssociatedObject(self, &kExpandEdge, [NSValue valueWithUIEdgeInsets:expandEdge], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

-(UIEdgeInsets)expandEdge{

    
    NSValue *value =  objc_getAssociatedObject(self, &kExpandEdge);
    
    return [value UIEdgeInsetsValue];
    
}


-(BOOL)qx_pointInside:(CGPoint)point withEvent:(UIEvent *)event{

    
    UIEdgeInsets insets = self.expandEdge;
    
    
    CGRect bounds = self.bounds;
    
    bounds = CGRectMake(bounds.origin.x - insets.left, bounds.origin.y - insets.top, bounds.size.width + insets.left + insets.right, bounds.size.height + insets.top + insets.bottom);
    return CGRectContainsPoint(bounds, point);
    
 // BOOL  [self qx_pointInside:point withEvent:event];
    
    
}

@end
