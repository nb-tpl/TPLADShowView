//
//  MMSBigPageControl.m
//  MaMaShoppingPro
//
//  Created by 谭鄱仑 on 14-9-2.
//  Copyright (c) 2014年 谭鄱仑. All rights reserved.
//

#import "TPLBigPageControl.h"
#define dealocInfo NSLog(@"%@ 释放了",[self class])



@implementation TPLBigPageControl
-(void)dealloc
{
    dealocInfo;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _pageIndicatorSize = 15.0f;
        _pageIndicatorSpace = 5;
        
        _currentPage = 0;
    }
    return self;
}


-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    while (self.subviews.count>0)
    {
        [self.subviews.lastObject removeFromSuperview];
    }
   
    for (int i = 0; i < numberOfPages; i ++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:imageView];
    }
    
}

-(void)setPageIndicatorSize:(CGFloat)pageIndicatorSize
{
    _pageIndicatorSize = pageIndicatorSize;
    [self refreshSubviews];
}
-(void)setPageIndicatorSpace:(CGFloat)pageIndicatorSpace
{
    _pageIndicatorSpace = pageIndicatorSpace;
    [self refreshSubviews];
}

- (void)setCurrentPage:(NSInteger)page {
    CGFloat y = (self.frame.size.height - _pageIndicatorSize)/2;
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++)
    {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        [subview setFrame:CGRectMake(subviewIndex*(_pageIndicatorSize+_pageIndicatorSpace) , y,
                                     _pageIndicatorSize,_pageIndicatorSize)];
        subview.layer.cornerRadius = _pageIndicatorSize/2;
        if (subviewIndex == page)
            subview.backgroundColor = self.currentPageIndicatorTintColor;
            else
            subview.backgroundColor = self.pageIndicatorTintColor;
    }
    _currentPage = page;
}

-(void)refreshSubviews
{
    CGFloat y = (self.frame.size.height - _pageIndicatorSize)/2;
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++)
    {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        [subview setFrame:CGRectMake(subviewIndex*(_pageIndicatorSize+_pageIndicatorSpace) , y,
                                     _pageIndicatorSize,_pageIndicatorSize)];
        subview.layer.cornerRadius = _pageIndicatorSize/2;
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
