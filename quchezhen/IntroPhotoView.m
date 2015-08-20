//
//  IntroPhotoView.m
//  quchezhen
//
//  Created by lijiajia on 15/7/13.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "IntroPhotoView.h"
#import <BmobSDK/BmobProFile.h>
#import "UIImageView+BmobDownLoad.h"

@interface IntroPhotoView ()<UIScrollViewDelegate>{
    UIScrollView *_scrollview;
    UIPageControl *_pgcontrol;
    NSMutableArray *_images;
//    UIImageView*_backgroundimageview;
}

@end
@implementation IntroPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollview.pagingEnabled = YES;
        _scrollview.delegate = self;
        _scrollview.layer.borderWidth = 0.5f;
        _scrollview.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.layer.cornerRadius = 2;
        [self addSubview:_scrollview];
        
        _pgcontrol = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pgcontrol.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1];
        _pgcontrol.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.6 alpha:1];
        _pgcontrol.numberOfPages = 0;
        _pgcontrol.currentPage = 0;
        CGPoint pgconcenter_ = CGPointZero;
        pgconcenter_.x = self.center.x;
        pgconcenter_.y = frame.size.height - 10;
        _pgcontrol.center = pgconcenter_;
        [_pgcontrol sizeToFit];
        [self addSubview:_pgcontrol];
    }
    
    return self;
}

- (id)initWithImages:(NSArray*)images andFrame:(CGRect)frame
{
    self = [self initWithImages:images Discriptions:nil andFrame:frame];
    
    return self;
}

- (id)initWithImages:(NSArray*)images Discriptions:(NSArray *)discriptions andFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self)
    {
        [self setupWithImages:images Discriptions:discriptions andFrame:frame];
    }
    
    return self;
}

- (id)initWithImageNames:(NSArray*)nameStrings andFrame:(CGRect)frame
{
    self = [self initWithImageNames:nameStrings Discriptions:nil andFrame:frame];
    
    return self;
}

- (id)initWithImageNames:(NSArray*)imageNames Discriptions:(NSArray *)discriptions andFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *name in imageNames)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithDefaultImageName:@"default_intro.png" NewImageName:name andFrame:frame];
            [array addObject:imageView];
        }
        
        [self setupWithUIImageViews:array Discriptions:discriptions andFrame:frame];
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page_ = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    _pgcontrol.currentPage = page_;
}

- (void)setupWithImages:(NSArray*)images Discriptions:(NSArray *)discriptions andFrame:(CGRect)frame
{
    if (!images || !images.count)
    {
        return;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < images.count; i++)
    {
        UIImage *image_ = [images objectAtIndex:i];
        UIImageView*iv_ = [[UIImageView alloc] init];
        iv_.image = image_;
        [array addObject:iv_];
    }
    
    [self setupWithUIImageViews:array Discriptions:discriptions andFrame:frame];
}

- (void)setupWithUIImageViews:(NSArray*)imageViews Discriptions:(NSArray *)discriptions andFrame:(CGRect)frame
{
    if (!imageViews || !imageViews.count)
    {
        return;
    }
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:bgImageView];
    
    _images = [NSMutableArray arrayWithArray:imageViews];
    
    _scrollview.contentSize = CGSizeMake(frame.size.width * _images.count , frame.size.height);
    
    for (int i = 0; i < _images.count; i++)
    {
        CGRect ivrect_ = CGRectMake(_scrollview.bounds.size.width * i,
                                    0,
                                    _scrollview.bounds.size.width,
                                    _scrollview.bounds.size.height);
        UIImageView*iv_ = [_images objectAtIndex:i];
        iv_.frame = ivrect_;
        iv_.contentMode = UIViewContentModeScaleAspectFill;
        iv_.clipsToBounds = YES;
        
        if (i < discriptions.count)
        {
            NSString *text = [discriptions objectAtIndex:i];
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = text;
            textLabel.font = [UIFont systemFontOfSize:14];
            textLabel.textColor = [UIColor whiteColor];
            textLabel.numberOfLines = 2;
            textLabel.frame = CGRectMake(10, ivrect_.size.height - 60, ivrect_.size.width - 10*2, 50);
            
            [iv_ addSubview:textLabel];
        }
        
        [_scrollview addSubview:iv_];
    }
    
    _pgcontrol.numberOfPages = _images.count;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
