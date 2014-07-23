//
//  GHWalkThroughView.m
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import "IDLWalkThroughView.h"
#import "IDLWalkThroughFadingImageView.h"

#define kIDLWalkThroughDefaultTitlePosition             200.0f
#define kIDLWalkThroughDefaultImagePosition             180.0f
#define kIDLWalkThroughDefaultTitleDetailPadding        0.0f

#define kIDLWalkThroughDefaultPaddingHorizontalTitle    10.0f
#define kIDLWalkThroughDefaultPaddingHorizontalDetail   20.0f

#define kIDLWalkThroughDefaultHeaderPaddingTop          50.0f

#define kIDLWalkThroughDefaultFooterPaddingBottom       30.0f
#define kIDLWalkThroughDefaultFooterPaddingSide         30.0f
#define kIDLWalkThroughDefaultFooterButtonHeight        45.0f
#define kIDLWalkThroughDefaultFooterButtonWidth         60.0f

#define kIDLWalkThroughCellIdentifier               @"IDLWalkThroughCellIdentifier"

NS_INLINE void UIViewSetBorder(UIView *view, UIColor *color, CGFloat width)
{
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = width;
}

@interface IDLWalkThroughView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView* textCollectionView;
@property (nonatomic, strong) UICollectionView* pictureCollectionView;

@property (nonatomic, strong) IDLWalkThroughFadingImageView* backgroundFadingImageView;
@property (nonatomic, strong) IDLWalkThroughFadingImageView* pictureOverlayFadingImageView;

@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) UIButton* skipButton;

@end

@implementation IDLWalkThroughView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configure];
    }
    return self;
}

- (void)applyAppearanceDefaults:(BOOL)force
{
    IDLWalkThroughTextCell *textCell = [IDLWalkThroughTextCell appearance];
    
    if (textCell.titleFont == nil || force) {
        textCell.titleFont = [UIFont boldSystemFontOfSize:16.0f];
    }
    if (textCell.titleColor == nil || force) {
        textCell.titleColor = [UIColor whiteColor];
    }
    
    if (textCell.detailFont == nil || force) {
        textCell.detailFont = [UIFont systemFontOfSize:13.0f];
    }
    if (textCell.detailColor == nil || force) {
        textCell.detailColor = [UIColor whiteColor];
    }
    
    if (textCell.titlePosition == nil || force) {
        textCell.titlePosition = @(kIDLWalkThroughDefaultTitlePosition);
    }
    
    if (textCell.titleDetailPadding == nil || force) {
        textCell.titleDetailPadding = @(kIDLWalkThroughDefaultTitleDetailPadding);
    }
    
    if (textCell.titleHorizontalPadding == nil || force) {
        textCell.titleHorizontalPadding = @(kIDLWalkThroughDefaultPaddingHorizontalTitle);
    }
    
    if (textCell.detailHorizontalPadding == nil || force) {
        textCell.detailHorizontalPadding = @(kIDLWalkThroughDefaultPaddingHorizontalDetail);
    }
    
    IDLWalkThroughPictureCell *pictureCell = [IDLWalkThroughPictureCell appearance];
    
    if (pictureCell.imagePosition == nil || force) {
        pictureCell.imagePosition = @(kIDLWalkThroughDefaultImagePosition);
    }
    
    IDLWalkThroughView *view = [IDLWalkThroughView appearance];
    
    if (view.headerPaddingTop == nil || force) {
        view.headerPaddingTop = @(kIDLWalkThroughDefaultHeaderPaddingTop);
    }
    
    if (view.footerPaddingBottom == nil || force) {
        view.footerPaddingBottom = @(kIDLWalkThroughDefaultFooterPaddingBottom);
    }
    
    if (view.footerPaddingSide == nil || force) {
        view.footerPaddingSide = @(kIDLWalkThroughDefaultFooterPaddingSide);
    }
    
    if (view.footerSkipButtonHeight == nil || force) {
        view.footerSkipButtonHeight = @(kIDLWalkThroughDefaultFooterButtonHeight);
    }
    
    if (view.footerSkipButtonWidth == nil || force) {
        view.footerSkipButtonWidth = @(kIDLWalkThroughDefaultFooterButtonWidth);
    }
}

- (void)configure
{
    [self applyAppearanceDefaults:NO];
    
    self.skipTitle = @"Skip";
    self.doneTitle = @"Done";
    
    CGRect frame = self.bounds;
    
    IDLWalkThroughFadingImageView *fadingImageView = [[IDLWalkThroughFadingImageView alloc] initWithFrame:frame];
    fadingImageView.backgroundColor = [UIColor clearColor];
    self.backgroundFadingImageView = fadingImageView;
    fadingImageView = [[IDLWalkThroughFadingImageView alloc] initWithFrame:frame];
    fadingImageView.backgroundColor = [UIColor clearColor];
    self.pictureOverlayFadingImageView = fadingImageView;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = self.backgroundFadingImageView;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.userInteractionEnabled = NO;
    [collectionView registerClass:[IDLWalkThroughPictureCell class] forCellWithReuseIdentifier:kIDLWalkThroughCellIdentifier];
    [self addSubview:collectionView];
    self.pictureCollectionView = collectionView;
    
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    
    collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = self.pictureOverlayFadingImageView;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[IDLWalkThroughTextCell class] forCellWithReuseIdentifier:kIDLWalkThroughCellIdentifier];
    [self addSubview:collectionView];
    self.textCollectionView = collectionView;
    
    [self buildFooterView];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    
    if (self.textCollectionView && self.pictureCollectionView) {
        NSArray *collectionViews = [NSArray arrayWithObjects:self.textCollectionView, self.pictureCollectionView, nil];
        NSInteger page = self.pageControl.currentPage;
        for (UICollectionView *collectionView in collectionViews) {
            UICollectionViewFlowLayout *layout = (id)collectionView.collectionViewLayout;
            layout.itemSize = frame.size;
            [layout invalidateLayout];
            collectionView.frame = frame;
            [collectionView reloadData];
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0] atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally | UICollectionViewScrollPositionCenteredVertically) animated:NO];
        }
    }
    
    if (self.floatingHeaderView) {
        CGRect floatingHeaderFrame = self.floatingHeaderView.frame;
        floatingHeaderFrame.origin.y = self.headerPaddingTop.floatValue;
        floatingHeaderFrame.origin.x = floor((frame.size.width - floatingHeaderFrame.size.width)/2.0f);
        self.floatingHeaderView.frame = floatingHeaderFrame;
        [self bringSubviewToFront:self.floatingHeaderView];
    }
    [self layoutFooterViews];
}

- (void)setFloatingHeaderView:(UIView *)floatingHeaderView
{
    if (_floatingHeaderView != nil) {
        [_floatingHeaderView removeFromSuperview];
    }
    
    _floatingHeaderView = floatingHeaderView;
    [self addSubview:floatingHeaderView];
    [self setNeedsLayout];
}

- (void)setWalkThroughDirection:(IDLWalkThroughViewDirection)walkThroughDirection
{
    _walkThroughDirection = walkThroughDirection;
    UICollectionViewScrollDirection direction = _walkThroughDirection == IDLWalkThroughViewDirectionVertical ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
    NSArray *layouts = [NSArray arrayWithObjects:self.textCollectionView.collectionViewLayout, self.pictureCollectionView.collectionViewLayout, nil];
    for (UICollectionViewFlowLayout* layout in layouts) {
        [layout setScrollDirection:direction];
        [layout invalidateLayout];
    }
    [self layoutFooterViews];
}

-(void)setSkipTitle:(NSString *)skipTitle
{
    _skipTitle = skipTitle;
    [self refreshSkipButtonTitle];
}

-(void)setDoneTitle:(NSString *)doneTitle
{
    _doneTitle = doneTitle;
    [self refreshSkipButtonTitle];
}
     
-(void)refreshSkipButtonTitle
{
    UIPageControl *control = self.pageControl;
    NSString *title = nil;
    if (control.currentPage == (control.numberOfPages - 1) && self.doneTitle != nil) {
        title = self.doneTitle;
    } else {
        title = self.skipTitle;
    }
    [self.skipButton setTitle:title forState:UIControlStateNormal];
}

- (void)layoutFooterViews
{
    
    UIPageControl *pageControl = self.pageControl;
    UIButton *skipButton = self.skipButton;
    
    CGRect bounds = self.bounds;
    CGPoint center = CGPointMake(bounds.size.width/2.0f, bounds.size.height/2.0f);
    
    CGSize pageControlSize = [pageControl sizeForNumberOfPages:pageControl.numberOfPages];
    pageControlSize.height = MAX(pageControlSize.height, self.footerSkipButtonHeight.floatValue);
    
    CGRect pageControlFrame = pageControl.frame;
    pageControlFrame.size = pageControlSize;
    
    CGPoint bottomLeft = CGPointMake(floor(bounds.size.width - self.footerPaddingSide.floatValue), floor(bounds.size.height - self.footerPaddingBottom.floatValue));
    
    CGRect skipButtonFrame = skipButton.frame;
    skipButtonFrame.size.width = self.footerSkipButtonWidth.floatValue;
    skipButtonFrame.size.height = pageControlSize.height;
    skipButtonFrame.origin.y = floor(bottomLeft.y - pageControlSize.height);
    
    if (self.walkThroughDirection == IDLWalkThroughViewDirectionVertical) {
        
        pageControl.frame = pageControlFrame;
        pageControl.transform = CGAffineTransformMakeRotation(M_PI / 2.0f);
        pageControlFrame = pageControl.frame;
        
        pageControlFrame.origin.x = bottomLeft.x - (pageControlSize.width + pageControlSize.height)/2.0f;
        pageControlFrame.origin.y = bottomLeft.y - (pageControlSize.width/2.0f + pageControlSize.height);
        
        skipButtonFrame.origin.x = floor(bottomLeft.x - (skipButtonFrame.size.width + pageControlSize.height));
        
    } else {
        skipButtonFrame.origin.x = floor(bottomLeft.x - skipButtonFrame.size.width);
        
        pageControlSize.width = floor(MAX((skipButtonFrame.origin.x - center.x) * 2.0f, pageControlSize.width));
        
        pageControlFrame.size.width = pageControlSize.width;
        
        pageControl.transform = CGAffineTransformMakeRotation(0.0f);
        pageControlFrame.origin.x = floor(center.x - pageControlSize.width/2.0f);
        pageControlFrame.origin.y = floor(bottomLeft.y - pageControlSize.height);
        
    }
    
    pageControl.frame = pageControlFrame;
    skipButton.frame = skipButtonFrame;
    [self refreshSkipButtonTitle];
}

- (void)buildFooterView
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 50)];
    
    //Set defersCurrentPageDisplay to YES to prevent page control jerking when switching pages with page control. This prevents page control from instant change of page indication.
    pageControl.defersCurrentPageDisplay = YES;
    
    pageControl.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [pageControl addTarget:self action:@selector(showPanelAtPageControl:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
    [self bringSubviewToFront:pageControl];
    self.pageControl = pageControl;
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    skipButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    
    skipButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:skipButton];
    [self bringSubviewToFront:skipButton];
    self.skipButton = skipButton;
    
    [self layoutFooterViews];
    [self refreshSkipButtonTitle];
}

- (void)skipIntroduction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)0);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self removeFromSuperview];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(walkthroughDidDismissView:)]) {
                [self.delegate walkthroughDidDismissView:self];
            }
        });
	}];
}

- (void)jumpToPage:(NSInteger)page
{
    NSArray *collectionViews = [NSArray arrayWithObjects:self.textCollectionView, self.pictureCollectionView, nil];
    for (UICollectionView *collectionView in collectionViews) {
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0] atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally | UICollectionViewScrollPositionCenteredVertically) animated:YES];
    }
}

- (void)showPanelAtPageControl:(UIPageControl*) sender
{
    [self jumpToPage:sender.currentPage];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger nPages = [self.dataSource numberOfPagesInWalkThroughView:self];
    return nPages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IDLWalkThroughPageCell *cell = (IDLWalkThroughPageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kIDLWalkThroughCellIdentifier forIndexPath:indexPath];
    
    if (collectionView == self.textCollectionView) {
        if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(walkThroughView:configureTextCell:forPageAtIndex:)]) {
            [self.dataSource walkThroughView:self configureTextCell:(IDLWalkThroughTextCell *)cell forPageAtIndex:indexPath.row];
        }
    } else if (collectionView == self.pictureCollectionView) {
        if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(walkThroughView:configurePictureCell:forPageAtIndex:)]) {
            [self.dataSource walkThroughView:self configurePictureCell:(IDLWalkThroughPictureCell *)cell forPageAtIndex:indexPath.row];
        }
    }
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.textCollectionView) return;
    
    UIPageControl *pageControl = self.pageControl;
    NSInteger lastPage = pageControl.currentPage;
    
    // Get scrolling position, and send the alpha values.
    if (!self.isfixedBackground) {
        float offset = self.walkThroughDirection == IDLWalkThroughViewDirectionHorizontal ? self.textCollectionView.contentOffset.x / self.textCollectionView.frame.size.width : self.textCollectionView.contentOffset.y / self.textCollectionView.frame.size.height ;
        [self crossDissolveForOffset:offset];
    }
    
    CGFloat pageMetric = 0.0f;
    CGFloat pageOffset = 0.0f;
    
    CGPoint contentOffset = scrollView.contentOffset;
    
    switch (self.walkThroughDirection) {
        case IDLWalkThroughViewDirectionHorizontal:
            pageMetric = scrollView.frame.size.width;
            pageOffset = contentOffset.x;
            break;
        case IDLWalkThroughViewDirectionVertical:
            pageMetric = scrollView.frame.size.height;
            pageOffset = contentOffset.y;
            break;
    }
    
    CGFloat pagePosition = pageOffset / pageMetric;
    
    NSInteger previousPage = floor(pagePosition);
    
    CGFloat normalisedPosition = pagePosition - previousPage;
    
    NSInteger closestPage = floor(pagePosition - 0.5f) + 1;
    pageControl.currentPage = closestPage;
    
    if (lastPage != pageControl.currentPage) {
        [self refreshSkipButtonTitle];
    }
    
    CGFloat picturePosition = easeInOutQuad(normalisedPosition);
    
    switch (self.walkThroughDirection) {
        case IDLWalkThroughViewDirectionHorizontal:
            contentOffset.x = (previousPage + picturePosition) * pageMetric;
            break;
        case IDLWalkThroughViewDirectionVertical:
            contentOffset.y = (previousPage + picturePosition) * pageMetric;
            break;
    }
    
    self.pictureCollectionView.contentOffset = contentOffset;
}

float easeInOutQuad(float value)
{
    value *= 2.0f;
    
    if (value < 1.0f) {
        return 0.5f * pow(value, 2.0f);
    } else {
        value = 2.0f - value;
        value = 0.5f * pow(value, 2.0f);
        return 1.0f - value;
    }
}

float easeOutValue(float value)
{
    float inverse = value - 1.0;
    return 1.0 + inverse * inverse * inverse;
}

- (void)crossDissolveForOffset:(float)offset
{
    NSInteger page = (int)(offset);
    float alphaValue = offset - (int)offset;
    
    IDLWalkThroughFadingImageView *fadingImageView = self.backgroundFadingImageView;
    
    if (alphaValue < 0 && self.pageControl.currentPage == 0){
        fadingImageView.backImage = nil;
        fadingImageView.frontAlpha = (1 + alphaValue);
        return;
    }
    
    fadingImageView.frontImage = [self.dataSource walkThroughView:self backgroundImageforPage:page];
    fadingImageView.frontAlpha = 1.0f;
    fadingImageView.backImage = [self.dataSource walkThroughView:self backgroundImageforPage:page+1];
    fadingImageView.backAlpha = 1.0f;
    
    float backLayerAlpha = alphaValue;
    float frontLayerAlpha = (1 - alphaValue);
    
    backLayerAlpha = easeInOutQuad(backLayerAlpha);
    frontLayerAlpha = easeInOutQuad(frontLayerAlpha);
    
    fadingImageView.backAlpha = backLayerAlpha;
    fadingImageView.frontAlpha = frontLayerAlpha;
}

- (void)showInView:(UIView *)view animateDuration:(CGFloat) duration
{
    self.frame = view.bounds;
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.dataSource numberOfPagesInWalkThroughView:self];

    if (self.isfixedBackground) {
        self.backgroundFadingImageView.frontImage = self.backgroundImage;
        
    } else{
        self.backgroundFadingImageView.frontImage = [self.dataSource walkThroughView:self backgroundImageforPage:0];
    }

    self.alpha = 0;
    self.textCollectionView.contentOffset = CGPointZero;
    [view addSubview:self];
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    }];
}

@end
