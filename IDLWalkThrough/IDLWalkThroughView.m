//
//  GHWalkThroughView.m
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import "IDLWalkThroughView.h"
#import "IDLWalkThroughFadingImageView.h"

@interface IDLWalkThroughView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView* textCollectionView;
@property (nonatomic, strong) UICollectionView* pictureCollectionView;

@property (nonatomic, strong) IDLWalkThroughFadingImageView* backgroundFadingImageView;
@property (nonatomic, strong) IDLWalkThroughFadingImageView* pictureOverlayFadingImageView;

@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) UIButton* skipButton;

@property (nonatomic, weak) UICollectionViewFlowLayout* layout;

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

- (void)configure
{
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
    self.layout = flowLayout;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = self.backgroundFadingImageView;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.userInteractionEnabled = NO;
    [collectionView registerClass:[IDLWalkThroughPicturePageCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:collectionView];
    self.pictureCollectionView = collectionView;
    
    collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = self.pictureOverlayFadingImageView;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[IDLWalkThroughTextPageCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:collectionView];
    self.textCollectionView = collectionView;
    
    [self buildFooterView];

}

- (void) setFloatingHeaderView:(UIView *)floatingHeaderView
{
    if (_floatingHeaderView != nil) {
        [_floatingHeaderView removeFromSuperview];
    }
    
    _floatingHeaderView = floatingHeaderView;
    CGRect frame = floatingHeaderView.frame;
    frame.origin.y = 50.0f;
    frame.origin.x = self.frame.size.width/2 - frame.size.width/2;
    floatingHeaderView.frame = frame;
    
    [self addSubview:floatingHeaderView];
    [self bringSubviewToFront:floatingHeaderView];
}

- (void) setWalkThroughDirection:(IDLWalkThroughViewDirection)walkThroughDirection
{
    _walkThroughDirection = walkThroughDirection;
    UICollectionViewScrollDirection dir = _walkThroughDirection == IDLWalkThroughViewDirectionVertical ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
    UICollectionViewFlowLayout* layout =  (UICollectionViewFlowLayout*) self.textCollectionView.collectionViewLayout;
    [layout setScrollDirection:dir];
    [layout invalidateLayout];
    [self orientFooter];
}

- (void)setCloseTitle:(NSString *)closeTitle
{
    _closeTitle = closeTitle;
    [self.skipButton setTitle:_closeTitle forState:UIControlStateNormal];
}

- (void) orientFooter
{
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
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 20)];
    
    //Set defersCurrentPageDisplay to YES to prevent page control jerking when switching pages with page control. This prevents page control from instant change of page indication.
    self.pageControl.defersCurrentPageDisplay = YES;
    
    self.pageControl.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [self.pageControl addTarget:self action:@selector(showPanelAtPageControl:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    [self bringSubviewToFront:self.pageControl];
    
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.skipButton.frame = CGRectMake(self.frame.size.width - 80, self.pageControl.frame.origin.y - ((30 - self.pageControl.frame.size.height)/2), 80, 30);
    
    self.skipButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [self.skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.skipButton];
    [self bringSubviewToFront:self.skipButton]; 
}

- (void) skipIntroduction
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

- (void) showPanelAtPageControl:(UIPageControl*) sender
{
    [self.pageControl setCurrentPage:sender.currentPage];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger nPages = [self.dataSource numberOfPages];
    return nPages;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IDLWalkThroughPageCell *cell = (IDLWalkThroughPageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if (collectionView == self.textCollectionView) {
        if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(configureTextPage:atIndex:)]) {
            [self.dataSource configureTextPage:(IDLWalkThroughTextPageCell *)cell atIndex:indexPath.row];
        }
    } else if (collectionView == self.pictureCollectionView) {
        if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(configurePicturePage:atIndex:)]) {
            [self.dataSource configurePicturePage:(IDLWalkThroughPicturePageCell *)cell atIndex:indexPath.row];
        }
    }
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if ([self.dataSource respondsToSelector:@selector(bgImageforPage:)]) {
//        self.bgFrontLayer.image = [self.dataSource bgImageforPage:self.pageControl.currentPage];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get scrolling position, and send the alpha values.
    if (!self.isfixedBackground) {
        float offset = self.walkThroughDirection == IDLWalkThroughViewDirectionHorizontal ? self.textCollectionView.contentOffset.x / self.textCollectionView.frame.size.width : self.textCollectionView.contentOffset.y / self.textCollectionView.frame.size.height ;
        [self crossDissolveForOffset:offset];
    }
    
    CGFloat pageMetric = 0.0f;
    CGFloat contentOffset = 0.0f;
    
    switch (self.walkThroughDirection) {
        case IDLWalkThroughViewDirectionHorizontal:
            pageMetric = scrollView.frame.size.width;
            contentOffset = scrollView.contentOffset.x;
            break;
        case IDLWalkThroughViewDirectionVertical:
            pageMetric = scrollView.frame.size.height;
            contentOffset = scrollView.contentOffset.y;
            break;
    }
    
    int page = floor((contentOffset - pageMetric / 2) / pageMetric) + 1;
    self.pageControl.currentPage = page;
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
    
    backLayerAlpha = easeOutValue(backLayerAlpha);
    frontLayerAlpha = easeOutValue(frontLayerAlpha);
    
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
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.dataSource numberOfPages];;

    if (self.isfixedBackground) {
        self.backgroundFadingImageView.frontImage = self.bgImage;
        
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
