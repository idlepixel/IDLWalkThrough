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

@interface IDLWalkThroughTextPageCell : IDLWalkThroughPageCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat titlePositionY;

@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) UIFont *detailFont;
@property (nonatomic, strong) UIColor *detailColor;
@property (nonatomic, assign) CGFloat detailPositionY;

@end

@interface IDLWalkThroughPicturePageCell : IDLWalkThroughPageCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGPoint imageOffset;

@end
