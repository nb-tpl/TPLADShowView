//
//  MMSBigPageControl.h
//  MaMaShoppingPro
//
//  Created by 谭鄱仑 on 14-9-2.
//  Copyright (c) 2014年 谭鄱仑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPLBigPageControl : UIView

@property(nonatomic,assign)CGFloat pageIndicatorSize;
@property(nonatomic,assign)CGFloat pageIndicatorSpace;



@property(nonatomic) NSInteger numberOfPages;          // default is 0
@property(nonatomic) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1


@property(nonatomic,retain) UIColor *pageIndicatorTintColor;
@property(nonatomic,retain) UIColor *currentPageIndicatorTintColor;
@end
