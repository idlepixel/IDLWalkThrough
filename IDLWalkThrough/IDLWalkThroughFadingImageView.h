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

@property (readwrite) UIImage *backImage;
@property (readwrite) UIImage *frontImage;

@property (nonatomic, assign) CGFloat backAlpha;
@property (nonatomic, assign) CGFloat frontAlpha;

@end
