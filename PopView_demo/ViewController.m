//
//  ViewController.m
//  PopView_demo
//
//  Created by 张昭 on 06/01/2018.
//  Copyright © 2018 heyfox. All rights reserved.
//

#import "ViewController.h"
#import "QXPopViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    CGPoint pointInView = [touch locationInView:[touch view]];
    CGPoint pointInWindow = [touch locationInView:[UIApplication sharedApplication].keyWindow];
    NSLog(@"%@ %@", NSStringFromCGPoint(pointInView), NSStringFromCGPoint(pointInWindow));
    
    UIImage *img = [UIImage imageNamed:@"共享咪币"];
    UIImage *img2 = [UIImage imageNamed:@"扫一扫"];
    
    NSArray *data = @[@{@"img": img, @"title": @"你"},
                      @{@"img": img2, @"title": @"我好"},
                      @{@"img": img, @"title": @"大家好"}
                      ];
    QXPopViewController *pop = [[QXPopViewController alloc] initWithTapedFrame:CGRectMake(pointInWindow.x, pointInWindow.y, 0, 0) withData:data];
//    QXPopViewController *pop = [[QXPopViewController alloc] initWithTapedView:nil withData:data];
    pop.visibleCellNumber = 3;
    pop.hasRightAngle = false;
    pop.selectedItemBlock = ^(NSInteger row) {
        NSLog(@"%ld", row);
    };
    [self presentViewController:pop animated:false completion:nil];
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    UIImage *img = [UIImage imageNamed:@"共享咪币"];
    UIImage *img2 = [UIImage imageNamed:@"扫一扫"];
    
    NSArray *data = @[@{@"title": @"你kk"},
                       @{@"img": img2},
                       @{@"img": img, @"title": @"大家好"},
                       @{@"img": img2, @"title": @""},
                       @{@"img": img, @"title": @"大家好号号"}];
    QXPopViewController *pop = [[QXPopViewController alloc] initWithTapedView:sender withData:data];
    pop.visibleCellNumber = 4;
    pop.hasRightAngle = true;
    pop.selectedItemBlock = ^(NSInteger row) {
        NSLog(@"%ld", row);
    };
    [self presentViewController:pop animated:false completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
