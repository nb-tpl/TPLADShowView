//
//  IFADShowView.m
//  IFADShowView
//
//  Created by NB_TPL on 14-8-18.
//  Copyright (c) 2014年 NB_TPL. All rights reserved.
//

#import "TPLADShowView.h"


#define dealocInfo NSLog(@"%@ 释放了",[self class])
#define baseColor [UIColor colorWithRed:0.389 green:0.670 blue:0.265 alpha:1.000]



@interface TPLADShowView ()<UIScrollViewDelegate>
{
//辅助变量
   __weak NSTimer * _animationTimer;
    
    
    
//view
    UIScrollView * _adScrollView;
    
    
//辅助变量
    BOOL _isScrolling;//判断是否动画结束
    
}



//创建展示的ScrollView
-(void)addADScrollView;


//刷新视图
-(void)refreshshowViews;

@end




@implementation TPLADShowView

//结束方法,释放之前得调用，因为有timer
-(void)prepareToDealloc
{
    if (_animationTimer)
    {
        [_animationTimer invalidate];
        _animationTimer = nil; 
    }
}
-(void)dealloc
{
    [self prepareToDealloc];
    [_adScrollView setContentOffset:_adScrollView.contentOffset animated:NO];
    
    dealocInfo;
}
#pragma mark
#pragma mark           property
#pragma mark
-(void)setAnimationStyle:(TPLADShowViewAnimationStyle)animationStyle
{
    _animationStyle = animationStyle;
    [self addADScrollView];
}

-(void)setShowViews:(NSMutableArray *)showViews
{
    [_animationTimer invalidate];
    _animationTimer = nil;
    _showViews = nil;
    _showViews = showViews;
    [self addADScrollView];
    [self refreshshowViews];
}

#pragma mark
#pragma mark           init
#pragma mark
- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame ShowViews:[NSMutableArray arrayWithCapacity:0]];
}
-(id)init
{
    return [self initWithFrame:CGRectZero];
}

//初始化方法
-(id)initWithFrame:(CGRect)frame ShowViews:(NSMutableArray*)showViews
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //init
        _isScrolling = NO;
        self.userInteractionEnabled = YES;
        _showViews = showViews;
        _isAnimation = YES;
        _animationDuration = 4;
        _animationStyle = TPLADShowViewAnimationStyleHorizontal;
        
        
        //init view
        [self addADScrollView];
        [self refreshshowViews];
        
    }
    return  self;
}

//调整显示
-(void)setShowViewIndex:(int)index animation:(BOOL)animation
{
    if (_showViews.count > index)
    {
        UIView * view = [_showViews objectAtIndex:index];
        [_adScrollView setContentOffset:view.frame.origin animated:animation];
    }
}
#pragma mark
#pragma mark           show view
#pragma mark
//添加图片滚动容器视图
-(void)addADScrollView
{
    //清空
    [_adScrollView removeFromSuperview];
    _adScrollView = nil;
    
    _adScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _adScrollView.pagingEnabled = YES;
    _adScrollView.delegate = self;
    _adScrollView.contentSize = TPLADShowViewAnimationStyleHorizontal == _animationStyle ? CGSizeMake(0, _adScrollView.frame.size.height) : CGSizeMake( _adScrollView.frame.size.width,0);
    [self addSubview:_adScrollView];
    
    for (int i = 0; i < _showViews.count; i++)
    {
        UIView * adView = [_showViews objectAtIndex:i];
        if ([adView isKindOfClass:[UIView class]])
        {
            
            if(TPLADShowViewAnimationStyleHorizontal == _animationStyle)
            {
                adView.frame = CGRectMake(_adScrollView.contentSize.width, 0, _adScrollView.frame.size.width, _adScrollView.frame.size.height);
                [_adScrollView addSubview:adView];
                _adScrollView.contentSize = CGSizeMake(_adScrollView.contentSize.width+_adScrollView.frame.size.width, _adScrollView.frame.size.height);
            }
            else if (TPLADShowViewAnimationStyleVertical == _animationStyle)
            {
                adView.frame = CGRectMake(0,_adScrollView.contentSize.height, _adScrollView.frame.size.width, _adScrollView.frame.size.height);
                [_adScrollView addSubview:adView];
                _adScrollView.contentSize = CGSizeMake(_adScrollView.contentSize.width,_adScrollView.contentSize.height+_adScrollView.frame.size.height);
            }
        }
    }
    
    [self bringSubviewToFront:_pageControl];
}

//刷新视图
-(void)refreshshowViews
{
    _adScrollView.contentOffset = CGPointMake(0, 0);
    
    //添加页码
    if(_pageControl)
    {
        _pageControl.frame = CGRectMake(self.frame.size.width/3, self.frame.size.height - 20, self.frame.size.width/3, 20);
    }
    else
    {
        _pageControl = [[TPLBigPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width/3, self.frame.size.height - 20, self.frame.size.width/3, 20)];
    }
    _pageControl.numberOfPages = TPLADShowViewAnimationStyleHorizontal == _animationStyle ? _adScrollView.contentSize.width/_adScrollView.frame.size.width : _adScrollView.contentSize.height/_adScrollView.frame.size.height;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = baseColor;
//    _pageControl.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pageControl];
    //添加动画
    if (_showViews.count > 1)
    {
        if (!_animationTimer)
        {
            NSTimer * timer = [NSTimer timerWithTimeInterval:_animationDuration target:self selector:@selector(timerAnimation) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            _animationTimer = timer;
            [_animationTimer performSelector:@selector(fire) withObject:nil afterDelay:_animationDuration];
        }
    }

    int i = 0;
    for (UIView * view in _showViews)
    {
        view.tag = i + 700;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        tapOne.numberOfTapsRequired = 1;

        [view addGestureRecognizer:tapOne];
        i++;
    }
}

//timerAnimation
-(void)timerAnimation
{
    if (_isAnimation)
    {
        if (_pageControl.currentPage < _pageControl.numberOfPages - 1)
        {
            if(_animationStyle == TPLADShowViewAnimationStyleHorizontal)
            {
                [_adScrollView setContentOffset:CGPointMake(_adScrollView.frame.size.width*(_pageControl.currentPage+1),0) animated:YES];
                _isScrolling = YES;
            }
            else if(TPLADShowViewAnimationStyleVertical == _animationStyle)
            {
                [_adScrollView setContentOffset:CGPointMake(0,_adScrollView.frame.size.height*(_pageControl.currentPage+1)) animated:YES];
                _isScrolling = YES;
            }
        }
        else
        {
            UIView * view = [_showViews firstObject];
            if (TPLADShowViewAnimationStyleHorizontal == _animationStyle)
            {
                view.frame = CGRectMake(_adScrollView.contentSize.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                [_adScrollView setContentOffset:CGPointMake(_adScrollView.contentSize.width,_adScrollView.contentOffset.y) animated:YES];
                _isScrolling = YES;
            }
            else if(TPLADShowViewAnimationStyleVertical == _animationStyle)
            {
                view.frame = CGRectMake(view.frame.origin.x, _adScrollView.contentSize.height, view.frame.size.width, view.frame.size.height);
                [_adScrollView setContentOffset:CGPointMake(_adScrollView.contentOffset.x,_adScrollView.contentSize.height) animated:YES];
                _isScrolling = YES;
            }
        }
    }
}



#pragma mark
#pragma mark           UIScrollViewDelegate
#pragma mark
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(TPLADShowViewAnimationStyleHorizontal == _animationStyle)
    {
        int x = _adScrollView.contentOffset.x/_adScrollView.frame.size.width;
        if (_adScrollView.contentOffset.x - _adScrollView.frame.size.width*x > _adScrollView.frame.size.width/2.0f)
        {
            x++;
        }
        _pageControl.currentPage = x;
    }
    else if (TPLADShowViewAnimationStyleVertical == _animationStyle)
    {
        int y = _adScrollView.contentOffset.y/_adScrollView.frame.size.height;
        if (_adScrollView.contentOffset.y - _adScrollView.frame.size.height*y > _adScrollView.frame.size.height/2.0f)
        {
            y++;
        }
        _pageControl.currentPage = y;
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (TPLADShowViewAnimationStyleHorizontal == _animationStyle)
    {
        if(scrollView.contentOffset.x == scrollView.contentSize.width)
        {
            UIView * view = _showViews.firstObject;
            [_adScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        }
    }
    else if(TPLADShowViewAnimationStyleVertical == _animationStyle)
    {
        if(scrollView.contentOffset.y == scrollView.contentSize.height)
        {
            UIView * view = _showViews.firstObject;
            [_adScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        }
    }
    _isScrolling = NO;
}








-(void)tapOne:(UITapGestureRecognizer * )tapOne
{
    if (NULL != self.clickADView)
    {
        self.clickADView((int)(tapOne.view.tag - 700)); 
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
