//
//  IDLWalkThroughFadingImageView.h
//  IDLWalkThrough
//
//  Created by Trystan Pfluger on 22/07/2014.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDLWalkThroughFadingImageView : UIView

@property (nonatomic, weak, readonly) UIImageView* backImageView;
@property (nonatomic, weak, readonly) UIImageView* frontImageView;

@property (nonatomic, assign) CGFloat backAlpha;
@property (nonatomic, assign) CGFloat frontAlpha;

@property (readwrite) UIImage *backImage;
@property (readwrite) UIImage *frontImage;

@property (nonatomic, assign) NSInteger backImageTag;
@property (nonatomic, assign) NSInteger frontImageTag;

-(void)resetTags;
-(void)setFrontImage:(UIImage *)frontImage tag:(NSInteger)tag;
-(void)setBackImage:(UIImage *)backImage tag:(NSInteger)tag;

@end
