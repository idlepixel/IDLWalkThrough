//
//  GHWalkThroughView.h
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLWalkThroughPageCell.h"

typedef NS_ENUM(NSInteger, IDLWalkThroughViewDirection) {
    IDLWalkThroughViewDirectionVertical,
    IDLWalkThroughViewDirectionHorizontal
};


typedef float(^IDLWalkThroughViewEasingBlock)(float value);

@protocol IDLWalkThroughViewDelegate;
@protocol IDLWalkThroughViewDataSource;

@interface IDLWalkThroughView : UIView <UIAppearanceContainer>

+(IDLWalkThroughViewEasingBlock)easingBlockLinear;
+(IDLWalkThroughViewEasingBlock)easingBlockInOutSine;
+(IDLWalkThroughViewEasingBlock)easingBlockInOutQuad;
+(IDLWalkThroughViewEasingBlock)easingBlockInOutCubic;
+(IDLWalkThroughViewEasingBlock)easingBlockInBounce;
+(IDLWalkThroughViewEasingBlock)easingBlockOutBounce;
+(IDLWalkThroughViewEasingBlock)easingBlockInOutBounce;

@property (nonatomic, assign) id<IDLWalkThroughViewDelegate> delegate;

@property (nonatomic, assign) id<IDLWalkThroughViewDataSource> dataSource;

@property (nonatomic, assign) IDLWalkThroughViewDirection walkThroughDirection;

@property (nonatomic, strong) UIView* floatingHeaderView;

@property (nonatomic, assign) BOOL isfixedBackground;

@property (nonatomic, assign, readonly) BOOL lastPageShown;

@property (nonatomic, strong) UIImage* backgroundImage;

@property (nonatomic, strong) NSString *skipTitle;
@property (nonatomic, strong) NSString *doneTitle;

@property (nonatomic, strong) NSNumber *headerPaddingTop        UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) NSNumber *footerPaddingSide       UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *footerPaddingBottom     UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *footerSkipButtonWidth   UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *footerSkipButtonHeight  UI_APPEARANCE_SELECTOR;

@property (nonatomic, copy) IDLWalkThroughViewEasingBlock backgroundFadeEasingBlock;
@property (nonatomic, copy) IDLWalkThroughViewEasingBlock pictureOverlayFadeEasingBlock;
@property (nonatomic, copy) IDLWalkThroughViewEasingBlock pictureMovementEasingBlock;

- (void)showInView:(UIView*) view animateDuration:(CGFloat) duration;

- (void)applyAppearanceDefaults:(BOOL)force;

- (void)resetLastPageShown;

@end

@protocol IDLWalkThroughViewDelegate <NSObject>

@optional
- (void)walkthroughDidDismissView:(IDLWalkThroughView *)walkthroughView;

@end

@protocol IDLWalkThroughViewDataSource <NSObject>

@required

- (NSInteger) numberOfPagesInWalkThroughView:(IDLWalkThroughView *)view;

@optional

- (UIImage *)walkThroughView:(IDLWalkThroughView *)view pictureOverlayImageforPage:(NSInteger)index;
- (UIImage *)walkThroughView:(IDLWalkThroughView *)view backgroundImageforPage:(NSInteger)index;

- (void)walkThroughView:(IDLWalkThroughView *)view configurePictureCell:(IDLWalkThroughPictureCell *)cell forPageAtIndex:(NSInteger)index;
- (void)walkThroughView:(IDLWalkThroughView *)view configureTextCell:(IDLWalkThroughTextCell *)cell forPageAtIndex:(NSInteger)index;

@end
