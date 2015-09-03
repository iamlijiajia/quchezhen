//
//  HomeTableViewRouteCell.m
//  quchezhen
//
//  Created by lijiajia on 15/8/24.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "HomeTableViewRouteCell.h"
#import "UIImageView+BmobDownLoad.h"
#import "UIImageView+AFNetworking.h"
#import "config.h"

@interface HomeTableViewRouteCell ()
{
    UIImageView *imgView;
    UILabel *label;
    UILabel *likeNumberLabel;
}

@end

@implementation HomeTableViewRouteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 150)];
        [self addSubview:imgView];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, width, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        [self addSubview:label];
        
        UIImageView *likeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(240, 10, 20, 20)];
        likeIcon.image = [UIImage imageNamed:@"love_heart.png"];
        [self addSubview:likeIcon];
        
        likeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 10, 50, 20)];
        likeNumberLabel.backgroundColor = [UIColor clearColor];
        likeNumberLabel.font = [UIFont systemFontOfSize:12];
        likeNumberLabel.textColor = [UIColor whiteColor];
        [self addSubview:likeNumberLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.cornerRadius = 5; //设置圆角
        self.clipsToBounds=YES;
    }
    
    return self;
}

- (void)configureCellwithRouteObject:(BmobObject *)route
{
    NSString *introThumbName = [route objectForKey:@"baseIntroThumb"];
    
    [imgView setImageWithURL:URL(introThumbName) placeholderImage:[UIImage imageNamed:@"banner-default@3x.png"]];
//    [imgView resetWithDefaultImageName:@"default_intro_png" NewImageName:introThumbName];
//    [imgView loadImageName:introThumbName withBlock:^{
//        [self setNeedsDisplay];
//    }];
    
    label.text = [route objectForKey:@"intro"];
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    [query whereKey:@"likes" equalTo:route];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error)
        {
            likeNumberLabel.text = [NSString stringWithFormat:@"%d人喜欢" , number];
        }
    }];
}

@end
