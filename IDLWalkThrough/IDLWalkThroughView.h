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
+(IDLWalkThroughViewEasingBlock)easingBlockInOutPower:(CGFloat)exponent;
+(IDLWalkThroughViewEasingBlock)easingBlockInBounce;
+(IDLWalkThroughViewEasingBlock)easingBlockOutBounce;
+(IDLWalkThroughViewEasingBlock)easingBlockInOutBounce;

@property (nonatomic, assign) id<IDLWalkThroughViewDelegate> delegate;

@property (nonatomic, assign) id<IDLWalkThroughViewDataSource> dataSource;

@property (nonatomic, assign) IDLWalkThroughViewDirection walkThroughDirection;

@property (nonatomic, strong) UIView* floatingHeaderView;

@property (nonatomic, assign) BOOL isfixedBackground;
@property (nonatomic, assign) BOOL hideSkipButton;

@property (nonatomic, assign, readonly) BOOL lastPageShown;

@property (nonatomic, strong) UIImage* backgroundImage;

@property (nonatomic, strong) NSString *skipTitle;
@property (nonatomic, strong) NSString *doneTitle;

@property (nonatomic, strong) NSNumber *headerPaddingTop        UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) NSNumber *footerPaddingSide       UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *footerPaddingBottom     UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *skipButtonWidth         UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *skipButtonHeight        UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *skipButtonTitleColor     UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *skipButtonFont            UI_APPEARANCE_SELECTOR;

@property (nonatomic, copy) IDLWalkThroughViewEasingBlock backgroundFadeEasingBlock;
@property (nonatomic, copy) IDLWalkThroughViewEasingBlock pictureOverlayFadeEasingBlock;

@property (nonatomic, copy) IDLWalkThroughViewEasingBlock pictureMovementEasingBlock;
@property (nonatomic, copy) IDLWalkThroughViewEasingBlock textMovementEasingBlock;

- (void)applyAppearanceDefaults:(BOOL)force;

- (void)resetLastPageShown;

- (void)reloadData;

@end

@protocol IDLWalkThroughViewDelegate <NSObject>

@optional
- (void)walkThroughView:(IDLWalkThroughView *)view didSkipOnPageAtIndex:(NSInteger)index;
- (void)walkThroughView:(IDLWalkThroughView *)view didScrollToPageAtIndex:(NSInteger)index;

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
