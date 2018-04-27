//
//  ViewController.m
//  轮播图
//
//  Created by Seraphic on 2018/4/26.
//  Copyright © 2018年 seraphic. All rights reserved.
//

#import "ViewController.h"
#import "RZBannerView.h"

@interface ViewController ()<RZBannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RZBannerView * bannerView = [[RZBannerView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 300)];
    
    bannerView.delegate = self;
    bannerView.imagesArray = @[
                        [UIImage imageNamed:@"0"],
                        [UIImage imageNamed:@"1"],
                        [UIImage imageNamed:@"2"],
                        [UIImage imageNamed:@"3"],
                        [UIImage imageNamed:@"4"]
                        ];
    bannerView.currentPageColor = [UIColor orangeColor];
    bannerView.pageColor = [UIColor grayColor];
    [self.view addSubview:bannerView];
}


-(void)indexOfClickedOnBannerView:(NSInteger)index{
    NSLog(@"======点击==%d",index);
}

@end
