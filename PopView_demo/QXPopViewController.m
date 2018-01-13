//
//  QXPopViewController.m
//  PopView_demo
//
//  Created by 张昭 on 06/01/2018.
//  Copyright © 2018 heyfox. All rights reserved.
//

#import "QXPopViewController.h"
#import "RTIconButton.h"
#import "UIView+QXExpandTouchArea.h"
#import <Masonry.h>

#define kLineHeight 50
#define kLineWidth 150
#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define kDistanceY 10
#define kDistanceX 0
#define kRadius 10

typedef enum : NSUInteger {
    NoRightAngle,
    LeftTop,
    LeftBottom,
    RightTop,
    RightBottom
} RightAnglePosition;

@interface QXPopViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *mDataSource;
@property (nonatomic, strong) UIView *mTapedView;
@property (nonatomic, strong) UIView *mAlertBgView;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, assign) CGRect frameInWindow;
@property (nonatomic, assign) BOOL isShowInCenter;
@property (nonatomic, assign) RightAnglePosition mRightPosition;
@property (nonatomic, assign) NSInteger mVisibleNumber;
@property (nonatomic, assign) BOOL mHasRightAngle;

@end

@implementation QXPopViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithTapedView:(UIView *)tapedView withData:(NSArray *)dataSource {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        _mTapedView = tapedView;
        if (tapedView) {
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            _frameInWindow = [tapedView.superview convertRect:tapedView.frame toView:window];
            _isShowInCenter = false;
        } else {
            _isShowInCenter = true;
        }
        
        if (dataSource) {
            _mDataSource = dataSource;
        } else {
            _mDataSource = [NSArray new];
        }
        _mVisibleNumber = 3;
        _mHasRightAngle = true;
    }
    return self;
}

- (instancetype)initWithTapedFrame:(CGRect)tapedFrame withData:(NSArray *)dataSource {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        _frameInWindow = tapedFrame;
        
        if (dataSource) {
            _mDataSource = dataSource;
        } else {
            _mDataSource = [NSArray new];
        }
        _mVisibleNumber = 3;
        _mHasRightAngle = true;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    
    UIView *bgBlackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgBlackView.backgroundColor = [UIColor darkGrayColor];
    bgBlackView.alpha = 0.4;
    [self.view addSubview:bgBlackView];
    
    self.mAlertBgView = [[UIView alloc] initWithFrame:[self alertRect]];
    CGRect rect = [self alertRect];
    [self.mAlertBgView.layer addSublayer:[self drawAlertRect: rect]];
    [self.view addSubview:self.mAlertBgView];
    
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(kRadius, 0, rect.size.width - kRadius * 2, rect.size.height) style:UITableViewStylePlain];
    [self.mAlertBgView addSubview:self.mTableView];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.rowHeight = kLineHeight;
    [self.mTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"reuse"];
    if (self.mDataSource.count < 4) {
        self.mTableView.showsVerticalScrollIndicator = false;
        self.mTableView.scrollEnabled = false;
    }
}

- (CAShapeLayer *)drawAlertRect:(CGRect)rect {
    
    CAShapeLayer *alertLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    switch (self.mRightPosition) {
        case RightTop:
            [path moveToPoint:CGPointMake(rect.size.width, 0)];
            [path addLineToPoint:CGPointMake(kRadius, 0)];
            [path addArcWithCenter:CGPointMake(kRadius, kRadius) radius:kRadius startAngle:M_PI_2 endAngle:M_PI clockwise:false];
            [path addLineToPoint:CGPointMake(0, rect.size.height - kRadius)];
            [path addArcWithCenter:CGPointMake(kRadius, rect.size.height - kRadius) radius:kRadius startAngle:M_PI endAngle:M_PI_2 clockwise:false];
            [path addLineToPoint:CGPointMake(rect.size.width - kRadius, rect.size.height)];
            [path addArcWithCenter:CGPointMake(rect.size.width - kRadius, rect.size.height - kRadius) radius:kRadius startAngle:M_PI_2 * 3 endAngle:0 clockwise:false];
            break;
        case RightBottom:
            [path moveToPoint:CGPointMake(rect.size.width, rect.size.height)];
            [path addLineToPoint:CGPointMake(rect.size.width, kRadius)];
            [path addArcWithCenter:CGPointMake(rect.size.width - kRadius, kRadius) radius:kRadius startAngle:0 endAngle:-M_PI_2 clockwise:false];
            [path addLineToPoint:CGPointMake(kRadius, 0)];
            [path addArcWithCenter:CGPointMake(kRadius, kRadius) radius:kRadius startAngle:M_PI_2 endAngle:M_PI clockwise:false];
            [path addLineToPoint:CGPointMake(0, rect.size.height - kRadius)];
            [path addArcWithCenter:CGPointMake(kRadius, rect.size.height - kRadius) radius:kRadius startAngle:M_PI endAngle:M_PI_2 clockwise:false];
            break;
        case LeftTop:
            [path moveToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(0, rect.size.height - kRadius)];
            [path addArcWithCenter:CGPointMake(kRadius, rect.size.height - kRadius) radius:kRadius startAngle:M_PI endAngle:M_PI_2 clockwise:false];
            [path addLineToPoint:CGPointMake(rect.size.width - kRadius, rect.size.height)];
            [path addArcWithCenter:CGPointMake(rect.size.width - kRadius, rect.size.height - kRadius) radius:kRadius startAngle:M_PI_2 endAngle:0 clockwise:false];
            [path addLineToPoint:CGPointMake(rect.size.width, kRadius)];
            [path addArcWithCenter:CGPointMake(rect.size.width - kRadius, kRadius) radius:kRadius startAngle:0 endAngle:-M_PI_2 clockwise:false];
            break;
        case LeftBottom:
            [path moveToPoint:CGPointMake(0, rect.size.height)];
            [path addLineToPoint:CGPointMake(rect.size.width - kRadius, rect.size.height)];
            [path addArcWithCenter:CGPointMake(rect.size.width - kRadius, rect.size.height - kRadius) radius:kRadius startAngle:M_PI_2 endAngle:0 clockwise:false];
            [path addLineToPoint:CGPointMake(rect.size.width, kRadius)];
            [path addArcWithCenter:CGPointMake(rect.size.width - kRadius, kRadius) radius:kRadius startAngle:0 endAngle:-M_PI_2 clockwise:false];
            [path addLineToPoint:CGPointMake(kRadius, 0)];
            [path addArcWithCenter:CGPointMake(kRadius, kRadius) radius:kRadius startAngle:M_PI_2 endAngle:M_PI clockwise:false];
            break;
        default:
            [path moveToPoint:CGPointMake(rect.size.width - kRadius, 0)];
            [path addLineToPoint:CGPointMake(kRadius, 0)];
            [path addArcWithCenter:CGPointMake(kRadius, kRadius) radius:kRadius startAngle:M_PI_2 endAngle:M_PI clockwise:false];
            [path addLineToPoint:CGPointMake(0, rect.size.height - kRadius)];
            [path addArcWithCenter:CGPointMake(kRadius, rect.size.height - kRadius) radius:kRadius startAngle:M_PI endAngle:M_PI_2 clockwise:false];
            [path addLineToPoint:CGPointMake(rect.size.width - kRadius, rect.size.height)];
            [path addArcWithCenter:CGPointMake(rect.size.width - kRadius, rect.size.height - kRadius) radius:kRadius startAngle:M_PI_2 * 3 endAngle:0 clockwise:false];
            [path addLineToPoint:CGPointMake(rect.size.width, kRadius)];
            [path addArcWithCenter:CGPointMake(rect.size.width - kRadius, kRadius) radius:kRadius startAngle:0 endAngle:-M_PI_2 clockwise:false];
            break;
    }
    
    [path closePath];
    alertLayer.fillColor = [UIColor whiteColor].CGColor;
    alertLayer.path = path.CGPath;
    
    return alertLayer;
}


- (CGRect)alertRect {
    CGRect rect;
    NSInteger k = 0;
    if (self.mDataSource.count == 0 || self.mDataSource.count == 1) {
        k = 1;
    } else if (self.mDataSource.count > self.mVisibleNumber) {
        k = self.mVisibleNumber;
    } else {
        k = self.mDataSource.count;
    }
    
    if (self.isShowInCenter) {
        rect = CGRectMake((kWidth - kLineWidth) / 2, (kHeight - k * kLineHeight) / 2, kLineWidth, k * kLineHeight);
        return rect;
    } else {
        CGFloat topHeight = self.frameInWindow.origin.y;
        CGFloat bottomHeight = kHeight - self.frameInWindow.origin.y - self.frameInWindow.size.height;
        CGFloat alertY;
        CGFloat alertX;
        if (topHeight > bottomHeight) {
            alertY = topHeight - kDistanceY - k * kLineHeight;
        } else {
            alertY = topHeight + self.frameInWindow.size.height + kDistanceY;
        }
        CGFloat leftDistance = self.frameInWindow.origin.x;
        CGFloat rightDistance = kWidth - self.frameInWindow.size.width - self.frameInWindow.origin.x;
        if (leftDistance >= rightDistance) {
            alertX = self.frameInWindow.origin.x + self.frameInWindow.size.width - kDistanceX - kLineWidth;
        } else {
            alertX = self.frameInWindow.origin.x + kDistanceX;
        }
        if (self.mHasRightAngle) {
            if (topHeight > bottomHeight) {
                if (leftDistance >= rightDistance) {
                    self.mRightPosition = RightBottom;
                } else {
                    self.mRightPosition = LeftBottom;
                }
            } else {
                if (leftDistance >= rightDistance) {
                    self.mRightPosition = RightTop;
                } else {
                    self.mRightPosition = LeftTop;
                }
            }
        }
        return CGRectMake(alertX, alertY, kLineWidth, k * kLineHeight);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:false completion:nil];
}

- (void)itemDidClicked:(RTIconButton *)sender {
    if (self.selectedItemBlock) {
        [self dismissViewControllerAnimated:false completion:^{
            self.selectedItemBlock(sender.tag);
        }];
    }
}

- (void)setVisibleCellNumber:(NSInteger)visibleCellNumber {
    if (visibleCellNumber <= 0) {
        _mVisibleNumber = 1;
    } else {
        _mVisibleNumber = visibleCellNumber;
    }
}

- (void)setHasRightAngle:(BOOL)hasRightAngle {
    _mHasRightAngle = hasRightAngle;
}

#pragma mark - tableView Delete DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    RTIconButton* btn = [RTIconButton buttonWithType:UIButtonTypeCustom];
    
    [btn setExpandEdge:UIEdgeInsetsMake(15, 20, 15, 30)];
    [btn sizeToFit];
    [cell.contentView addSubview:btn];
    btn.tag = indexPath.row;
    [btn addTarget:self action:@selector(itemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *text = [[self.mDataSource objectAtIndex:indexPath.row] objectForKey:@"title"];
    UIImage *image = [[self.mDataSource objectAtIndex:indexPath.row] objectForKey:@"img"];
    
    
    if (text && text.length > 0) {
        if (!image) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.leading.mas_equalTo(27.5 - kRadius);
                make.trailing.mas_equalTo(-27.5 + kRadius);
            }];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setTitle:text forState:UIControlStateNormal];
    }
    
    
    if (image) {
        if (text && text.length > 0) {
            btn.iconPosition = RTIconPositionLeft;
        } else {
            btn.iconPosition = RTIconPositionCenter;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.leading.mas_equalTo(27.5 - kRadius);
                make.trailing.mas_equalTo(-27.5 + kRadius);
            }];
        }
        
        btn.iconMargin = 16;
        [btn setImage:image forState:UIControlStateNormal];
        btn.imageView.tintColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    }
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.leading.mas_equalTo(27.5 - kRadius);
    }];
    
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    [cell.contentView addSubview:separatorView];
    if (indexPath.row == self.mDataSource.count - 1) {
        separatorView.hidden = YES;
    }else {
        separatorView.hidden = NO;
    }
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 - kRadius);
        make.right.mas_offset(-15 + kRadius);
        make.bottom.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
