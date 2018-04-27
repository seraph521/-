//
//  RZBannerView.m
//  轮播图
//
//  Created by Seraphic on 2018/4/26.
//  Copyright © 2018年 seraphic. All rights reserved.
//

#import "RZBannerView.h"

@interface RZBannerView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIPageControl * pageControl;

///左UIImageView
@property (strong, nonatomic) UIImageView *leftImageView;
///中间UIImageView
@property (strong, nonatomic) UIImageView *centerImageView;
///右UIImageView
@property (strong, nonatomic) UIImageView *rightImageView;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic, strong) NSTimer * timer;

@end

@implementation RZBannerView


- (instancetype) initWithFrame:(CGRect)frame{
    
    if(self == [super initWithFrame:frame]){
        
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        
        //scrollView
        UIScrollView * scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.bounces = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        self.scrollView.frame = self.bounds;
        self.scrollView.contentSize = CGSizeMake(width * 3, height);
        //中间位置
        self.scrollView.contentOffset = CGPointMake(width, 0);
        
        //添加3个imagerView
        
        self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width *0, 0, width, height)];
        self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width *1, 0, width, height)];
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width *2, 0, width, height)];
        
        self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.centerImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //中间视图 用户看到的只有中间视图，所以为了简单起见，只需要添加中间视图的点击响应
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap)];
        self.centerImageView.userInteractionEnabled = YES;
        [self.centerImageView addGestureRecognizer:tap];
        
        [self.scrollView addSubview:self.leftImageView];
        [self.scrollView addSubview:self.centerImageView];
        [self.scrollView addSubview:self.rightImageView];
        
        //添加pageControl
        UIPageControl * pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        //设置pageControl的位置
        self.pageControl.frame = CGRectMake(self.frame.size.width - 100, self.frame.size.height - 100, 100, 50);
        
    }
    
    return self;
}

//设置pageControl的CurrentPageColor
- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    _currentPageColor = currentPageColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageColor;
}
//设置pageControl的pageColor
- (void)setPageColor:(UIColor *)pageColor {
    _pageColor = pageColor;
    self.pageControl.pageIndicatorTintColor = pageColor;
}

#pragma mark - 设置图片
- (void)setImagesArray:(NSArray *)imagesArray{
    
    _imagesArray = imagesArray;
    //pageControl的页数就是图片的个数
    self.pageControl.numberOfPages = imagesArray.count;
    //默认一开始显示的是第0页
    self.pageControl.currentPage = 0;
    //设置图片显示内容
    [self setContent];
    //开启定时器
    [self startTimer];
}


#pragma mark - 设置图片显示内容

- (void)setContent{
    
    self.leftImageView.image = [self getImageUrlBeforeIndex:self.currentPage];
    self.centerImageView.image = [self getImageUrlAtIndex:self.currentPage];
    self.rightImageView.image = [self getImageUrlAfterIndex:self.currentPage];

}

#pragma mark - 开启定时器
- (void)startTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

//停止计时器
- (void)stopTimer {
    //结束计时
    [self.timer invalidate];
    //计时器被系统强引用，必须手动释放
    self.timer = nil;
}

//通过改变contentOffset * 2换到下一张图片
- (void)nextImage {
    
    CGFloat width = self.bounds.size.width;

    [self.scrollView setContentOffset:CGPointMake(2 * width, 0) animated:YES];
    
}

#pragma mark - UIScrollViewDelegate


//开始拖拽的时候停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}
//结束拖拽的时候开始定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}
//结束拖拽的时候更新image内容
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    if (index == 0) {
        //向左滑动
        self.currentPage--;
        if (self.currentPage <0 ) {
            self.currentPage = self.imagesArray.count - 1;
        }
        self.rightImageView.image = self.centerImageView.image;
        self.centerImageView.image = self.leftImageView.image;
        self.leftImageView.image = [self getImageUrlBeforeIndex:self.currentPage];

    }else if(index == 2){
        self.currentPage++;
        if (self.currentPage >= self.imagesArray.count  ) {
            self.currentPage = 0;
        }
        self.leftImageView.image = self.centerImageView.image;
        self.centerImageView.image = self.rightImageView.image;
        self.self.rightImageView.image = [self getImageUrlAfterIndex:self.currentPage];

    }
    scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * 1, 0);
    self.pageControl.currentPage = self.currentPage;
    
}

//scroll滚动动画结束的时候更新image内容
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - 循环获取URL

-(UIImage *)getImageUrlBeforeIndex:(NSInteger)index{
    if (index == 0) {
        return [self.imagesArray lastObject];
    }else{
        return self.imagesArray[index-1];
    }
}

-(UIImage *)getImageUrlAfterIndex:(NSInteger)index{
    if (index == (self.imagesArray.count - 1)) {
        return [self.imagesArray firstObject];
    }else{
        return self.imagesArray[index+1];
    }
}

-(UIImage *)getImageUrlAtIndex:(NSInteger)index{
    if (index<0 || index >= self.imagesArray.count) {
        return nil;
    }else{
        return self.imagesArray[index];
    }
}



#pragma mark - 点击图片
- (void)imageViewTap{
    
    if([self.delegate respondsToSelector:@selector(indexOfClickedOnBannerView:)]){
        [self.delegate indexOfClickedOnBannerView:self.currentPage];
    }
}






@end
