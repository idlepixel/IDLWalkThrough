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

@protocol IDLWalkThroughViewDelegate;
@protocol IDLWalkThroughViewDataSource;

@interface IDLWalkThroughView : UIView <UIAppearanceContainer>

@property (nonatomic, assign) id<IDLWalkThroughViewDelegate> delegate;

@property (nonatomic, assign) id<IDLWalkThroughViewDataSource> dataSource;

@property (nonatomic, assign) IDLWalkThroughViewDirection walkThroughDirection;

@property (nonatomic, strong) UIView* floatingHeaderView;

@property (nonatomic, assign) BOOL isfixedBackground;

@property (nonatomic, strong) UIImage* backgroundImage;

@property (nonatomic, copy) NSString *closeTitle;

- (void)showInView:(UIView*) view animateDuration:(CGFloat) duration;

@end

@protocol IDLWalkThroughViewDelegate <NSObject>

@optional
- (void)walkthroughDidDismissView:(IDLWalkThroughView *)walkthroughView;

@end

@protocol IDLWalkThroughViewDataSource <NSObject>

@required

- (NSInteger) numberOfPages;

@optional

- (UIImage *)pictureOverlayImageforPage:(NSInteger)index;
- (UIImage *)backgroundImageforPage:(NSInteger)index;

- (void)configurePictureCell:(IDLWalkThroughPictureCell *)cell forPageAtIndex:(NSInteger)index;
- (void)configureTextCell:(IDLWalkThroughTextCell *)cell forPageAtIndex:(NSInteger)index;

@end
