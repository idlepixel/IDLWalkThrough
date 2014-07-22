//
//  GHWalkThroughCell.m
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import "IDLWalkThroughPageCell.h"

@interface IDLWalkThroughPageCell ()

- (void)configure;
- (void)applyDefaults;

@end

@implementation IDLWalkThroughPageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self applyDefaults];
        [self configure];
    }
    return self;
}

- (void)configure
{
    // do nothing
}

- (void)applyDefaults
{
    // do nothing
}

@end

@interface IDLWalkThroughTextPageCell ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UITextView* detailLabel;

@end

@implementation IDLWalkThroughTextPageCell

#pragma mark setters

- (void) setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = self.title;
    [self setNeedsLayout];
}

- (void)setDetail:(NSString *)detail
{
    _detail = detail;
    self.detailLabel.text = self.detail;
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    [self layoutTitleLabel];
    
    CGRect detailLabelFrame = CGRectMake(20, self.frame.size.height - self.detailPositionY, self.contentView.frame.size.width - 40, 500);
    self.detailLabel.frame = detailLabelFrame;
    
}

- (void) layoutTitleLabel
{
    CGFloat titleHeight;
    
    if ([self.title respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.title attributes:@{ NSFontAttributeName: self.titleFont }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.contentView.frame.size.width - 20, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        titleHeight = ceilf(rect.size.height);
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        titleHeight = [self.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
#pragma clang diagnostic pop
    }
    
    CGRect titleLabelFrame = CGRectMake(10, self.frame.size.height - self.titlePositionY, self.contentView.frame.size.width - 20, titleHeight);

    self.titleLabel.frame = titleLabelFrame;
}

- (void) applyDefaults
{
    [super applyDefaults];
    
    self.title = @"Title";
    self.detail = @"Default Description";
    
    self.titlePositionY  = 180.0f;
    self.detailPositionY   = 160.0f;
    self.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    self.titleColor = [UIColor whiteColor];
    self.detailFont = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    self.detailColor = [UIColor whiteColor];
}

- (void)configure
{
    [super configure];
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *pageView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    if (self.titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.text = self.title;
        titleLabel.font = self.titleFont;
        titleLabel.textColor = self.titleColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [pageView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    
    if (self.detailLabel == nil) {
        UITextView *detailLabel = [[UITextView alloc] initWithFrame:CGRectZero];
        detailLabel.text = self.detail;
        detailLabel.scrollEnabled = NO;
        detailLabel.font = self.detailFont;
        detailLabel.textColor = self.detailColor;
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.userInteractionEnabled = NO;
        [pageView addSubview:detailLabel];
        self.detailLabel = detailLabel;
    }

    [self.contentView addSubview:pageView];
}

@end

@interface IDLWalkThroughPicturePageCell ()

@property (nonatomic, strong) UIImageView* imageView;

@end

@implementation IDLWalkThroughPicturePageCell

- (void) applyDefaults
{
    [super applyDefaults];
    
    self.imageOffset = CGPointMake(0.0f, 50.0f);
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGSize imageSize = image.size;
    self.imageView.frame = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGPoint center = CGPointMake(contentRect.size.width/2.0f, contentRect.size.height/2.0f);
    center.x = round(center.x + self.imageOffset.x);
    center.y = round(center.y + self.imageOffset.y);
    self.imageView.center = center;
}

- (void)configure
{
    [super configure];
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *pageView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    if (self.imageView == nil) {
        UIImageView *imageView = self.image != nil ? [[UIImageView alloc] initWithImage:self.image] : [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
        self.imageView = imageView;
    }
    [pageView addSubview:self.imageView];
    
    [self.contentView addSubview:pageView];
}

@end


