//
//  RZBannerView.h
//  轮播图
//
//  Created by Seraphic on 2018/4/26.
//  Copyright © 2018年 seraphic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RZBannerView;

@protocol RZBannerViewDelegate <NSObject>

- (void) indexOfClickedOnBannerView:(NSInteger) index;

@end

@interface RZBannerView : UIView

//传入图片数组
@property(nonatomic,strong) NSArray * imagesArray;

//pageControl颜色设置
@property (nonatomic, strong) UIColor * currentPageColor;

@property (nonatomic, strong) UIColor * pageColor;

@property(nonatomic,weak) id<RZBannerViewDelegate> delegate;

@end
