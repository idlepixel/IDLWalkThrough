//
//  IDLWalkThroughFadingImageView.m
//  IDLWalkThrough
//
//  Created by Trystan Pfluger on 22/07/2014.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import "IDLWalkThroughFadingImageView.h"

@interface IDLWalkThroughFadingImageView ()

@property (nonatomic, weak) UIImageView* backImageView;
@property (nonatomic, weak) UIImageView* frontImageView;

@end

#define kNotFoundTag    NSNotFound

@implementation IDLWalkThroughFadingImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    CGRect bounds = self.bounds;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:bounds];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:imageView];
    self.backImageView = imageView;
    
    imageView = [[UIImageView alloc] initWithFrame:bounds];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:imageView];
    self.frontImageView = imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    self.backImageView.frame = bounds;
    self.frontImageView.frame = bounds;
}

- (UIImage *)backImage
{
    return self.backImageView.image;
}

- (void)setBackImage:(UIImage *)backImage
{
    if (backImage == nil) self.backImageTag = kNotFoundTag;
    self.backImageView.image = backImage;
}

- (void)setBackAlpha:(CGFloat)backAlpha
{
    _backAlpha = backAlpha;
    self.backImageView.alpha = backAlpha;
}

- (UIImage *)frontImage
{
    return self.frontImageView.image;
}

- (void)setFrontImage:(UIImage *)frontImage
{
    if (frontImage == nil) self.frontImageTag = kNotFoundTag;
    self.frontImageView.image = frontImage;
}

- (void)setFrontAlpha:(CGFloat)frontAlpha
{
    _frontAlpha = frontAlpha;
    self.frontImageView.alpha = frontAlpha;
}

-(void)resetTags
{
    self.frontImageTag = kNotFoundTag;
    self.backImageTag = kNotFoundTag;
}

-(void)setFrontImage:(UIImage *)frontImage tag:(NSInteger)tag
{
    self.frontImageTag = tag;
    self.frontImage = frontImage;
}

-(void)setBackImage:(UIImage *)backImage tag:(NSInteger)tag
{
    self.backImageTag = tag;
    self.backImage = backImage;
}

@end
