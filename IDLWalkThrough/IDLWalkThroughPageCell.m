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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.textColor = self.titleColor;
    self.titleLabel.font = self.titleFont;
    self.detailLabel.textColor = self.detailColor;
    self.detailLabel.font = self.detailFont;

    [self layoutTitleLabel];
    
    CGFloat padding = self.detailHorizontalPadding.floatValue;
    
    CGRect detailLabelFrame = CGRectMake(padding, CGRectGetMaxY(self.titleLabel.frame)+self.titleDetailPadding.floatValue, self.contentView.frame.size.width - (padding * 2.0f), 500);
    self.detailLabel.frame = detailLabelFrame;
    
}

- (void)layoutTitleLabel
{
    CGFloat titleHeight;
    
    CGFloat padding = self.titleHorizontalPadding.floatValue;
    
    if ([self.title respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.title attributes:@{ NSFontAttributeName: self.titleFont }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.contentView.frame.size.width - (padding * 2.0f), CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        titleHeight = ceilf(rect.size.height);
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        titleHeight = [self.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(self.contentView.frame.size.width - (padding * 2.0f), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
#pragma clang diagnostic pop
    }
    titleHeight += 1.0f;
    
    CGRect titleLabelFrame = CGRectMake(padding, self.frame.size.height - self.titlePosition.floatValue, self.contentView.frame.size.width - (padding * 2.0f), titleHeight);

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

@interface IDLWalkThroughPictureCell ()

@property (nonatomic, strong) UIImageView* foregroundImageView;
@property (nonatomic, strong) UIImageView* backgroundImageView;

@end

@implementation IDLWalkThroughPictureCell

- (void)setForegroundImage:(UIImage *)foregroundImage
{
    _foregroundImage = foregroundImage;
    self.foregroundImageView.image = foregroundImage;
	self.foregroundImageView.contentMode = self.imageContentMode.integerValue;
    CGSize imageSize = foregroundImage.size;
    self.foregroundImageView.frame = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    [self setNeedsLayout];
    
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
    self.backgroundImageView.contentMode = self.imageContentMode.integerValue;
    CGSize imageSize = backgroundImage.size;
    self.backgroundImageView.frame = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    [self setNeedsLayout];
    
}

- (CGRect)layoutView:(UIView *)view bounds:(CGRect)bounds offset:(CGFloat)offset alignment:(UIControlContentVerticalAlignment)alignment
{
    CGRect viewRect = view.frame;
    
    viewRect.origin.x = floor(CGRectGetMidX(bounds) - viewRect.size.width/2.0f);
    
    if (alignment == UIControlContentVerticalAlignmentBottom) {
        viewRect.origin.y = floor(bounds.size.height - viewRect.size.height - offset);
        
    } else if (alignment == UIControlContentVerticalAlignmentTop) {
        viewRect.origin.y = floor(offset);
        
    } else {
        viewRect.origin.y = floor(CGRectGetMidY(bounds) - viewRect.size.height/2.0f);
    }
    
    //NSLog(@"bounds: %@",NSStringFromCGRect(bounds));
    //NSLog(@"viewRect: %@",NSStringFromCGRect(viewRect));
    
    view.frame = viewRect;
    
    return viewRect;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /*/
    self.foregroundImageView.layer.borderColor = [UIColor redColor].CGColor;
    self.foregroundImageView.layer.borderWidth = 2.0f;
    self.backgroundImageView.layer.borderColor = [UIColor greenColor].CGColor;
    self.backgroundImageView.layer.borderWidth = 2.0f;
    //*/
    
    CGRect contentRect = self.contentView.bounds;
    
    CGRect backgroundRect = contentRect;
    
    BOOL hasBackground = (self.backgroundImage != nil);
    
    CGFloat verticalImageOffset = self.verticalImageOffset.floatValue;
    UIControlContentVerticalAlignment verticalAlignment = self.verticalImageAlignment.integerValue;
    
    if (hasBackground) {
        backgroundRect = [self layoutView:self.backgroundImageView bounds:contentRect offset:verticalImageOffset alignment:verticalAlignment];
    }
    
    if (self.foregroundImage != nil) {
        if (hasBackground && self.centerForegroundOnBackground) {
            [self layoutView:self.foregroundImageView bounds:backgroundRect offset:0.0f alignment:UIControlContentVerticalAlignmentCenter];
        } else {
            [self layoutView:self.foregroundImageView bounds:contentRect offset:verticalImageOffset alignment:verticalAlignment];
        }
    }
}

- (void)configure
{
    [super configure];
    
    /*
    self.imageContentMode = UIViewContentModeScaleAspectFit;
    self.centerForegroundOnBackground = YES;
    self.verticalImageAlignment = UIControlContentVerticalAlignmentBottom;
    */
     
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *pageView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    if (self.backgroundImageView == nil) {
        UIImageView *imageView = self.backgroundImage != nil ? [[UIImageView alloc] initWithImage:self.backgroundImage] : [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
        self.backgroundImageView = imageView;
    }
    [pageView addSubview:self.backgroundImageView];
    
    if (self.foregroundImageView == nil) {
        UIImageView *imageView = self.foregroundImage != nil ? [[UIImageView alloc] initWithImage:self.foregroundImage] : [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
        self.foregroundImageView = imageView;
    }
    [pageView addSubview:self.foregroundImageView];
    
    // debug
    //self.imageView.layer.borderColor = [UIColor purpleColor].CGColor;
    //self.imageView.layer.borderWidth = 2.0f;
    
    [self.contentView insertSubview:pageView atIndex:0];
}

-(void)removeNonPictureContentViews
{
    UIView *imageSuperView = self.foregroundImageView.superview;
    NSArray *contentViews = self.contentView.subviews;
    for (UIView *cv in contentViews) {
        if (cv != imageSuperView) {
            [cv removeFromSuperview];
        }
    }
}

@end


