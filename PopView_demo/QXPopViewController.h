//
//  QXPopViewController.h
//  PopView_demo
//
//  Created by 张昭 on 06/01/2018.
//  Copyright © 2018 heyfox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedItemBlock)(NSInteger);

@interface QXPopViewController : UIViewController

@property (nonatomic, copy) SelectedItemBlock selectedItemBlock;
@property (nonatomic, assign) NSInteger visibleCellNumber;
@property (nonatomic, assign) BOOL hasRightAngle;  // 默认true：有方向

/**
 tapedView == nil时，居中；
 dataSource: @[@{@"img": UIImage, @"title": @"标题"}]
 */
- (instancetype)initWithTapedView:(UIView *)tapedView withData:(NSArray *)dataSource;

- (instancetype)initWithTapedFrame:(CGRect)tapedFrame withData:(NSArray *)dataSource;

@end
