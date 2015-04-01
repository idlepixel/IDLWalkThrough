 //
//  GHWalkThroughCell.h
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDLWalkThroughPageCell : UICollectionViewCell

@end

@interface IDLWalkThroughTextCell : IDLWalkThroughPageCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont                         UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor                       UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) UIFont *detailFont                        UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *detailColor                      UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) NSNumber *titlePosition                   UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *titleDetailPadding              UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *titleHorizontalPadding          UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *detailHorizontalPadding         UI_APPEARANCE_SELECTOR;

@end

@interface IDLWalkThroughPictureCell : IDLWalkThroughPageCell

@property (nonatomic, strong) UIImage *foregroundImage;
@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, strong) NSNumber *verticalImageOffset             UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSNumber *verticalImageAlignment          UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) NSNumber *centerForegroundOnBackground    UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) NSNumber *imageContentMode                UI_APPEARANCE_SELECTOR;

-(void)removeNonPictureContentViews;

@end
