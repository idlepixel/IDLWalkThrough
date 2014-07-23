//
//  GHWalkThroughView.m
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import "IDLWalkThroughView.h"
#import "IDLWalkThroughFadingImageView.h"

#define kIDLWalkThroughDefaultTitlePosition         200.0f
#define kIDLWalkThroughDefaultImagePosition         180.0f
#define kIDLWalkThroughDefaultTitleDetailPadding    5.0f

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

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger lastPage;

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
    
    IDLWalkThroughPictureCell *pictureCell = [IDLWalkThroughPictureCell appearance];
    
    if (pictureCell.imagePosition == nil || force) {
        pictureCell.imagePosition = @(kIDLWalkThroughDefaultImagePosition);
    }
}

- (void)configure
{
    [self applyAppearanceDefaults:NO];
    
    self.backgroundColor = [UIColor grayColor];
    
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
    
    UIViewSetBorder(self.textCollectionView, [UIColor greenColor], 2.0f);
    UIViewSetBorder(self, [UIColor redColor], 2.0f);
    
    self.currentPage = 0;
    self.lastPage = 0;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    self.textCollectionView.frame = frame;
    [self.textCollectionView reloadData];
    self.pictureCollectionView.frame = frame;
    [self.pictureCollectionView reloadData];
    
    if (self.floatingHeaderView) {
        CGRect floatingHeaderFrame = self.floatingHeaderView.frame;
        floatingHeaderFrame.origin.y = 50.0f;
        floatingHeaderFrame.origin.x = floor((frame.size.width - floatingHeaderFrame.size.width)/2.0f);
        self.floatingHeaderView.frame = floatingHeaderFrame;
        [self bringSubviewToFront:self.floatingHeaderView];
    }
    [self orientFooter];
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
    [self orientFooter];
}

- (void)setCloseTitle:(NSString *)closeTitle
{
    _closeTitle = closeTitle;
    [self.skipButton setTitle:_closeTitle forState:UIControlStateNormal];
}

- (void)orientFooter
{
    UIViewSetBorder(self.pageControl, [UIColor yellowColor], 2.0f);
    if (self.walkThroughDirection == IDLWalkThroughViewDirectionVertical) {
        
        BOOL isRotated = !CGAffineTransformEqualToTransform(self.pageControl.transform, CGAffineTransformIdentity);
        
        if (!isRotated) {
            CGRect butonFrame = self.skipButton.frame;
            butonFrame.origin.x -= 30;
            self.skipButton.frame = butonFrame;
            
            self.pageControl.transform = CGAffineTransformRotate(self.pageControl.transform, M_PI_2);
            CGRect frame = self.pageControl.frame;
            frame.size.height = ([self.dataSource numberOfPages] + 1 ) * 16;
            frame.origin.x = self.frame.size.width - frame.size.width - 10;
            frame.origin.y = butonFrame.origin.y+butonFrame.size.height - frame.size.height;
            self.pageControl.frame = frame;
        
        }
    } else{
        BOOL isRotated = !CGAffineTransformEqualToTransform(self.pageControl.transform, CGAffineTransformIdentity);
        
        if (isRotated) {
            // Rotate back the page control
            self.pageControl.transform = CGAffineTransformRotate(self.pageControl.transform, -M_PI_2);
            self.pageControl.frame = CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 20);
            
            self.skipButton.frame = CGRectMake(self.frame.size.width - 80, self.pageControl.frame.origin.y - ((30 - self.pageControl.frame.size.height)/2), 80, 30);

        }
    }
}

- (void)buildFooterView
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 20)];
    
    //Set defersCurrentPageDisplay to YES to prevent page control jerking when switching pages with page control. This prevents page control from instant change of page indication.
    pageControl.defersCurrentPageDisplay = YES;
    
    pageControl.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [pageControl addTarget:self action:@selector(showPanelAtPageControl:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
    [self bringSubviewToFront:pageControl];
    self.pageControl = pageControl;
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    skipButton.frame = CGRectMake(self.frame.size.width - 80, pageControl.frame.origin.y - ((30 - pageControl.frame.size.height)/2), 80, 30);
    
    skipButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:skipButton];
    [self bringSubviewToFront:skipButton];
    self.skipButton = skipButton;
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

- (void)showPanelAtPageControl:(UIPageControl*) sender
{
    [self.pageControl setCurrentPage:sender.currentPage];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger nPages = [self.dataSource numberOfPages];
    return nPages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IDLWalkThroughPageCell *cell = (IDLWalkThroughPageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kIDLWalkThroughCellIdentifier forIndexPath:indexPath];
    
    if (collectionView == self.textCollectionView) {
        if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(configureTextCell:forPageAtIndex:)]) {
            [self.dataSource configureTextCell:(IDLWalkThroughTextCell *)cell forPageAtIndex:indexPath.row];
        }
    } else if (collectionView == self.pictureCollectionView) {
        if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(configurePictureCell:forPageAtIndex:)]) {
            [self.dataSource configurePictureCell:(IDLWalkThroughPictureCell *)cell forPageAtIndex:indexPath.row];
        }
    }
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if ([self.dataSource respondsToSelector:@selector(bgImageforPage:)]) {
//        self.bgFrontLayer.image = [self.dataSource bgImageforPage:self.pageControl.currentPage];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.textCollectionView) return;
    
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
    //NSInteger nextPage = ceil(pagePosition);
    
    CGFloat normalisedPosition = pagePosition - previousPage;
    
    NSInteger closestPage = floor(pagePosition - 0.5f) + 1;
    self.pageControl.currentPage = closestPage;
    
    //NSLog(@"position: %f (p:%i,n:%i), offset:%f",pagePosition,previousPage,nextPage,normalisedPosition);
    
    CGFloat picturePosition = easeInOutQuad(normalisedPosition);
    
    //NSLog(@"picturePosition: %f",picturePosition);
    
    switch (self.walkThroughDirection) {
        case IDLWalkThroughViewDirectionHorizontal:
            contentOffset.x = (previousPage + picturePosition) * pageMetric;
            break;
        case IDLWalkThroughViewDirectionVertical:
            contentOffset.y = (previousPage + picturePosition) * pageMetric;
            break;
    }
    //NSLog(@"contentOffset: %@",NSStringFromCGPoint(contentOffset));
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
    
    fadingImageView.frontImage = [self.dataSource backgroundImageforPage:page];
    fadingImageView.frontAlpha = 1.0f;
    fadingImageView.backImage = [self.dataSource backgroundImageforPage:page+1];
    fadingImageView.backAlpha = 1.0f;
    
    float backLayerAlpha = alphaValue;
    float frontLayerAlpha = (1 - alphaValue);
    
    backLayerAlpha = easeInOutQuad(backLayerAlpha);
    frontLayerAlpha = easeInOutQuad(frontLayerAlpha);
    
    fadingImageView.backAlpha = backLayerAlpha;
    fadingImageView.frontAlpha = frontLayerAlpha;
}



float easeOutValue(float value)
{
    float inverse = value - 1.0;
    return 1.0 + inverse * inverse * inverse;
}

- (void)showInView:(UIView *)view animateDuration:(CGFloat) duration
{
    self.frame = view.bounds;
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.dataSource numberOfPages];;

    if (self.isfixedBackground) {
        self.backgroundFadingImageView.frontImage = self.backgroundImage;
        
    } else{
        self.backgroundFadingImageView.frontImage = [self.dataSource backgroundImageforPage:0];
    }

    self.alpha = 0;
    self.textCollectionView.contentOffset = CGPointZero;
    [view addSubview:self];
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
