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
#import "UIView+Utilities.h"
#import "UIImage+Blur.h"
#import "UIImageView+AFNetworking.h"
#import "config.h"

#define KTag_Base       1000

@interface IntroPhotoView ()<UIScrollViewDelegate>{
    UIScrollView *_scrollview;
    UIPageControl *_pgcontrol;
    NSMutableArray *_images;
    NSArray *textArray;
    CGRect initFrame;
    
    UIImageView *stretchImageView;
    UILabel *stretchLabel;
}

@property (nonatomic, strong) NSMutableArray *blurImages;

@end
@implementation IntroPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        initFrame = frame;
        
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
        
        self.blurImages = [[NSMutableArray alloc] init];
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
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:URL(name)] placeholderImage:[UIImage imageNamed:@"banner-default@3x.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [self.blurImages addObject:[self prepareForBlurImagesWithImage:image]];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];

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

- (NSMutableArray *)prepareForBlurImagesWithImage:(UIImage *)image
{
    if (!image)
    {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    CGFloat factor = 0.1;
    [array addObject:image];
    for (NSUInteger i = 0; i < (self.height - 64)/20; i++) {
        [array addObject:[image boxblurImageWithBlur:factor]];
        factor+=0.08;
    }
    
    return array;
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
    
    stretchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    stretchImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:stretchImageView];
    
    stretchLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, stretchImageView.frame.size.height - 60, stretchImageView.frame.size.width - 10*2, 50)];
    stretchLabel.font = [UIFont systemFontOfSize:14];
    stretchLabel.textColor = [UIColor whiteColor];
    stretchLabel.numberOfLines = 2;
    [stretchImageView addSubview:stretchLabel];
    
    _images = [NSMutableArray arrayWithArray:imageViews];
    textArray = discriptions;
    
    _scrollview.contentSize = CGSizeMake(frame.size.width * _images.count , frame.size.height);
    
    for (int i = 0; i < _images.count; i++)
    {
        CGRect ivrect_ = CGRectMake(_scrollview.bounds.size.width * i,
                                    0,
                                    _scrollview.bounds.size.width,
                                    _scrollview.bounds.size.height);
        UIImageView*iv_ = [_images objectAtIndex:i];
        iv_.frame = ivrect_;
        iv_.contentMode = UIViewContentModeScaleToFill;
        iv_.clipsToBounds = NO;
        iv_.tag = i + KTag_Base;
        
        if (i < discriptions.count)
        {
            NSString *text = [discriptions objectAtIndex:i];
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = text;
            textLabel.font = [UIFont systemFontOfSize:14];
            textLabel.textColor = [UIColor whiteColor];
            textLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            textLabel.numberOfLines = 2;
            textLabel.frame = CGRectMake(10, ivrect_.size.height - 60, ivrect_.size.width - 10*2, 50);
            
            [iv_ addSubview:textLabel];
        }
        
        [_scrollview addSubview:iv_];
    }
    
    _pgcontrol.numberOfPages = _images.count;
}

- (void)stretchOffset:(CGFloat)offset
{
    UIImageView *currentView = (UIImageView *)[_scrollview viewWithTag:(_pgcontrol.currentPage + KTag_Base)];
    if (currentView)
    {
        if (offset > 0)
        {
            NSMutableArray *blurImagesArray;
            
            for (blurImagesArray in self.blurImages)
            {
                if (blurImagesArray && blurImagesArray.count && [blurImagesArray objectAtIndex:0] == currentView.image)
                {
                    break;
                }
            }
            
            if (blurImagesArray && blurImagesArray.count)
            {
                NSInteger index = offset / 10;
                if (index < 0)
                {
                    index = 0;
                }
                else if(index >= blurImagesArray.count)
                {
                    index = blurImagesArray.count - 1;
                }
                UIImage *image = blurImagesArray[index];
                
                stretchImageView.image = image;
                stretchLabel.text = [textArray objectAtIndex:_pgcontrol.currentPage];
                stretchImageView.frame= CGRectMake( 0,0, self.frame.size.width, self.frame.size.height);
                stretchLabel.frame = CGRectZero;//CGRectMake(10, stretchImageView.frame.size.height - 60, stretchImageView.frame.size.width - 10*2, 50);
            }
        }
        else if(offset < 0)
        {
            UIImage *image = currentView.image;
            stretchImageView.image = image;
            stretchLabel.text = [textArray objectAtIndex:_pgcontrol.currentPage];
            stretchImageView.frame= CGRectMake( offset,offset, self.frame.size.width + (-offset)*2, self.frame.size.height + (-offset));
            stretchLabel.frame = CGRectMake(10 + (-offset), stretchImageView.frame.size.height - 60, 320 - 10*2, 50);
        }
        else
        {
            stretchImageView.image = nil;
            stretchLabel.text = nil;
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
