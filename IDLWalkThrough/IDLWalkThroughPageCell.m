//
//  GHWalkThroughCell.m
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import "IDLWalkThroughPageCell.h"


NS_INLINE void UIViewSetBorder(UIView *view, UIColor *color, CGFloat width)
{
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = width;
}

@interface IDLWalkThroughPageCell ()

- (void)configure;

@end

@implementation IDLWalkThroughPageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configure];
    }
    return self;
}

- (void)configure
{
    // do nothing
}

@end

@interface IDLWalkThroughTextCell ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UITextView* detailLabel;

@end

@implementation IDLWalkThroughTextCell

#pragma mark setters

- (void)setTitle:(NSString *)title
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

#define kPaddingWidthTitle      10.0f
#define kPaddingWidthDetail     20.0f

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.textColor = self.titleColor;
    self.titleLabel.font = self.titleFont;
    self.detailLabel.textColor = self.detailColor;
    self.detailLabel.font = self.detailFont;

    [self layoutTitleLabel];
    
    CGRect detailLabelFrame = CGRectMake(kPaddingWidthDetail, CGRectGetMaxY(self.titleLabel.frame)+self.titleDetailPadding.floatValue, self.contentView.frame.size.width - (kPaddingWidthDetail * 2.0f), 500);
    self.detailLabel.frame = detailLabelFrame;
    
}

- (void)layoutTitleLabel
{
    CGFloat titleHeight;
    
    if ([self.title respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.title attributes:@{ NSFontAttributeName: self.titleFont }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.contentView.frame.size.width - (kPaddingWidthTitle * 2.0f), CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        titleHeight = ceilf(rect.size.height);
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        titleHeight = [self.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(self.contentView.frame.size.width - (kPaddingWidthTitle * 2.0f), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
#pragma clang diagnostic pop
    }
    titleHeight += 1.0f;
    
    CGRect titleLabelFrame = CGRectMake(kPaddingWidthTitle, self.frame.size.height - self.titlePosition.floatValue, self.contentView.frame.size.width - (kPaddingWidthTitle * 2.0f), titleHeight);

    self.titleLabel.frame = titleLabelFrame;
}

- (void)configure
{
    [super configure];
    
    self.title = @"Title";
    self.detail = @"Default Description";
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *pageView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    if (self.titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.text = self.title;
        titleLabel.font = self.titleFont;
        titleLabel.textColor = self.titleColor;
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [pageView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        //UIViewSetBorder(titleLabel, [UIColor greenColor], 2.0f);
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
        
        //UIViewSetBorder(detailLabel, [UIColor redColor], 2.0f);
    }

    [self.contentView addSubview:pageView];
}

@end

@interface IDLWalkThroughPictureCell ()

@property (nonatomic, strong) UIImageView* imageView;

@end

@implementation IDLWalkThroughPictureCell

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGSize imageSize = image.size;
    self.imageView.frame = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    //UIViewSetBorder(self.imageView, [UIColor orangeColor], 2.0f);
    
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    
    CGRect imageRect = self.imageView.frame;
    imageRect.origin.x = floor((contentRect.size.width - imageRect.size.width)/2.0f);
    imageRect.origin.y = floor(contentRect.size.height - imageRect.size.height - self.imagePosition.floatValue);
    
    self.imageView.frame = imageRect;
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
    
    // debug
    //self.imageView.layer.borderColor = [UIColor purpleColor].CGColor;
    //self.imageView.layer.borderWidth = 2.0f;
    
    [self.contentView addSubview:pageView];
}

@end


