//
//  GHViewController.m
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import "DemoViewController.h"
#import "IDLWalkThroughView.h"

static NSString * const sampleDesc1 = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque tincidunt laoreet diam, id suscipit ipsum sagittis a. ";

static NSString * const sampleDesc2 = @" Suspendisse et ultricies sem. Morbi libero dolor, dictum eget aliquam quis, blandit accumsan neque. Vivamus lacus justo, viverra non dolor nec, lobortis luctus risus.";

static NSString * const sampleDesc3 = @"In interdum scelerisque sem a convallis. Quisque vehicula a mi eu egestas. Nam semper sagittis augue, in convallis metus";

static NSString * const sampleDesc4 = @"Praesent ornare consectetur elit, in fringilla ipsum blandit sed. Nam elementum, sem sit amet convallis dictum, risus metus faucibus augue, nec consectetur tortor mauris ac purus.";

static NSString * const sampleDesc5 = @"Sed rhoncus arcu nisl, in ultrices mi egestas eget. Etiam facilisis turpis eget ipsum tempus, nec ultricies dui sagittis. Quisque interdum ipsum vitae ante laoreet, id egestas ligula auctor. Quisque interdum ipsum vitae ante laoreet, id egestas ligula auctor.";

@interface DemoViewController () <IDLWalkThroughViewDataSource>

@property (nonatomic, strong) IDLWalkThroughView* walkThroughView;

@property (nonatomic, strong) NSArray* descStrings;

@property (nonatomic, strong) UILabel* welcomeLabel;

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //[[IDLWalkThroughTextCell appearance] setTitleColor:[UIColor greenColor]];
    //[[IDLWalkThroughTextCell appearance] setDetailHorizontalPadding:@(50.0f)];
    
    //[[IDLWalkThroughView appearance] setFooterPaddingBottom:@(5.0f)];
    //[[IDLWalkThroughView appearance] setFooterPaddingSide:@(5.0f)];
    
    IDLWalkThroughView *walkThroughView = [[IDLWalkThroughView alloc] initWithFrame:self.navigationController.view.bounds];
    walkThroughView.backgroundColor = [UIColor grayColor];
    walkThroughView.dataSource = self;
    [walkThroughView setWalkThroughDirection:IDLWalkThroughViewDirectionVertical];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        walkThroughView.footerPaddingBottom = walkThroughView.footerPaddingSide = @(5.0f);
        [IDLWalkThroughTextCell appearance].titleHorizontalPadding = @(10.0f);
        [IDLWalkThroughTextCell appearance].detailHorizontalPadding = @(20.0f);
    } else {
        walkThroughView.footerPaddingBottom = walkThroughView.footerPaddingSide = @(25.0f);
        [IDLWalkThroughTextCell appearance].titleHorizontalPadding = @(70.0f);
        [IDLWalkThroughTextCell appearance].detailHorizontalPadding = @(100.0f);
    }
    
    self.walkThroughView = walkThroughView;
    
    UILabel* welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    welcomeLabel.text = @"Welcome";
    welcomeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel = welcomeLabel;
    
    self.descStrings = [NSArray arrayWithObjects:sampleDesc1,sampleDesc2, sampleDesc3, sampleDesc4, sampleDesc5, nil];
}

#pragma mark - GHDataSource

- (NSInteger)numberOfPagesInWalkThroughView:(IDLWalkThroughView *)view
{
    return 5;
}

- (void)walkThroughView:(IDLWalkThroughView *)view configureTextCell:(IDLWalkThroughTextCell *)cell forPageAtIndex:(NSInteger)index
{
    cell.title = [NSString stringWithFormat:@"This is page %ld", (long)(index+1)];
    cell.detail = [self.descStrings objectAtIndex:index];
}

- (void)walkThroughView:(IDLWalkThroughView *)view configurePictureCell:(IDLWalkThroughPictureCell *)cell forPageAtIndex:(NSInteger)index
{
    cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"title%ld", (long)(index+1)]];
}

- (UIImage*)walkThroughView:(IDLWalkThroughView *)view backgroundImageforPage:(NSInteger)index
{
    NSString* imageName =[NSString stringWithFormat:@"bg_0%ld.jpg", (long)(index+1)];
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}

- (UIImage*)walkThroughView:(IDLWalkThroughView *)view pictureOverlayImageforPage:(NSInteger)index
{
    index = index % 2;
    NSString* imageName =[NSString stringWithFormat:@"overlay_0%ld", (long)(index+1)];
    UIImage* image = [UIImage imageNamed:imageName];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 250.0f, 10.0f)];
    return image;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IDLWalkThroughView *walkThroughView = self.walkThroughView;
    
    walkThroughView.isfixedBackground = NO;

    switch (indexPath.row) {
        case 0:
            walkThroughView.floatingHeaderView = nil;
            [walkThroughView setWalkThroughDirection:IDLWalkThroughViewDirectionHorizontal];
            break;
        case 1:
            walkThroughView.floatingHeaderView = nil;
            [walkThroughView setWalkThroughDirection:IDLWalkThroughViewDirectionVertical];
            break;
        case 2:
        {
            [walkThroughView setFloatingHeaderView:self.welcomeLabel];
            [walkThroughView setWalkThroughDirection:IDLWalkThroughViewDirectionHorizontal];
        }
            break;
        case 3:
            [walkThroughView setFloatingHeaderView:self.welcomeLabel];
            walkThroughView.isfixedBackground = YES;
            walkThroughView.backgroundImage = [UIImage imageNamed:@"static_bg_01"];
            [walkThroughView setWalkThroughDirection:IDLWalkThroughViewDirectionVertical];
    
            break;
            
        default:
            break;
    }
    [walkThroughView resetLastPageShown];
    [walkThroughView showInView:self.navigationController.view animateDuration:0.3];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.walkThroughView.frame = self.walkThroughView.superview.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
