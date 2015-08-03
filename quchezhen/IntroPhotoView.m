//
//  IntroPhotoView.m
//  quchezhen
//
//  Created by lijiajia on 15/7/13.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "IntroPhotoView.h"

@interface IntroPhotoView ()<UIScrollViewDelegate>{
    UIScrollView *_scrollview;
    UIPageControl *_pgcontrol;
    NSMutableArray *_images;
//    UIImageView*_backgroundimageview;
}

@end
@implementation IntroPhotoView

- (id)initWithImages:(NSArray*)images andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:bgImageView];
    
    _images = [NSMutableArray arrayWithArray:images];
    
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _scrollview.contentSize = CGSizeMake(frame.size.width * images.count , frame.size.height);
    _scrollview.pagingEnabled = YES;
    _scrollview.delegate = self;
    _scrollview.layer.borderWidth = 0.5f;
    _scrollview.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.layer.cornerRadius = 2;
    [self addSubview:_scrollview];
    
    int index_ = 0;
    for (UIImage *image_ in images) {
        NSAssert([image_ isKindOfClass:[UIImage class]],@"view isn't UIImage.");
        CGRect ivrect_ = CGRectMake(_scrollview.bounds.size.width * index_,
                                    0,
                                    _scrollview.bounds.size.width,
                                    _scrollview.bounds.size.height);
        UIImageView*iv_ = [[UIImageView alloc] initWithFrame:ivrect_];
        iv_.contentMode = UIViewContentModeScaleAspectFill;
        iv_.clipsToBounds = YES;
        iv_.image = image_;
        [_scrollview addSubview:iv_];
        index_++;
    }
    
    _pgcontrol = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pgcontrol.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1];
    _pgcontrol.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.6 alpha:1];
    _pgcontrol.numberOfPages = _images.count;
    _pgcontrol.currentPage = 0;
    CGPoint pgconcenter_ = CGPointZero;
    pgconcenter_.x = self.center.x;
    pgconcenter_.y = frame.size.height - 25;
    _pgcontrol.center = pgconcenter_;
    [_pgcontrol sizeToFit];
    [self addSubview:_pgcontrol];
    
    return self;
}

- (id)initWithImageNames:(NSArray*)nameStrings andFrame:(CGRect)frame
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:9];
    for (NSString *name in nameStrings)
    {
        [array addObject:[UIImage imageNamed:name]];
    }
    
    self = [self initWithImages:array andFrame:frame];
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page_ = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    _pgcontrol.currentPage = page_;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
