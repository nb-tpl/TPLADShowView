//
//  ViewController.m
//  TPLADShowView
//
//  Created by 谭鄱仑 on 15-1-28.
//  Copyright (c) 2015年 谭鄱仑. All rights reserved.
//

#import "ViewController.h"

#import "TPLADShowView.h"

@interface ViewController ()
{
    TPLADShowView * _adShowView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self addHorizontalAD];
    
    
    
    //多选
    UIButton * changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.backgroundColor = [UIColor orangeColor];
    changeButton.frame = CGRectMake(10, 300, 150, 50);
    [changeButton setTitle:@"切换滚动方向" forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];

}


-(void)changeButtonClicked:(id)sender
{
    _adShowView.animationStyle = _adShowView.animationStyle == TPLADShowViewAnimationStyleVertical ? TPLADShowViewAnimationStyleHorizontal : TPLADShowViewAnimationStyleVertical;
}


//加横的
-(void)addHorizontalAD
{
    //添加列表头部动画视图
    /* tpl 使用方法 */
    NSMutableArray * showsViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 4; i++)
    {
        UIImageView * view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f blue:arc4random()%256/255.0f alpha:1];
        [showsViewArray addObject:view];
    }
    
    
    UIImageView * headBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0,40, self.view.bounds.size.width, 155)];
        headBackView.userInteractionEnabled = YES;
    [self.view addSubview:headBackView];
    
       _adShowView = [[TPLADShowView alloc] initWithFrame:CGRectMake(0,5, self.view.bounds.size.width, 150) ShowViews:showsViewArray];
        _adShowView.animationDuration = 2;
        _adShowView.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.769 alpha:1.000];
        //        _adShowView.pageControl.backgroundColor = [UIColor redColor];
        _adShowView.pageControl.frame = CGRectMake(10, 5, 15*4, 20);
        _adShowView.pageControl.pageIndicatorSize = 26.0f;
        _adShowView.pageControl.currentPage = 0;
    _adShowView.animationStyle = TPLADShowViewAnimationStyleVertical;
        [headBackView addSubview:_adShowView];
    
    //广告栏点击
    typeof(self) __weak weak_self = self;
    _adShowView.clickADView = ^(int clickedIndex)
    {
        typeof(weak_self) __strong strong_self = weak_self;
        if (strong_self)
        {
            NSLog(@"点击了第%d广告",clickedIndex);
        }
    };
    
    /* tpl 使用方法 */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
