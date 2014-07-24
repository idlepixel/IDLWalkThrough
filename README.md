#IDLWalkThrough (based on GHWalkThrough)

This fork includes the following additional functionality to the original project (at the time of forking):
* Each page has the following layers:
** Background
** Picture
** Picture overlay (behaves similarly to the Background layer)
** Text
* UIAppearance support
* Customisable independent easing for each layer using blocks
* Data source & delegate syntax changes to better match UITableView/UICollectionView
* Optimised data source use to improve performance
* Support for any resolution (iPhone & iPad)
* Rotation support
* Cleaned up and modernised code (debatable)
* Project folder reorganisation to differentiate core classes and Example assets

#GHWalkThrough - iOS App Walk through control

![BackgroundImage](https://raw2.github.com/GnosisHub/GHWalkThrough/master/wtwithheader.gif)
![BackgroundImage](https://raw2.github.com/GnosisHub/GHWalkThrough/master/wtbgfixed.gif)
![BackgroundImage](https://raw2.github.com/GnosisHub/GHWalkThrough/master/wtvertical.gif)
![BackgroundImage](https://raw2.github.com/GnosisHub/GHWalkThrough/master/wthorizontal.gif)

This is simple and customizable drop-in solution for showing app walkthroughs or intros.

* Configurable to walk through in horizontal and vertical directions
* Support for having custom floating header on all pages
* Supports fixed background image

##How To Use

Sample app contains examples of how to configure the component

* Add `GHWalkThroughView` and `GHWalkThroughPageCell` headers and implementations to your project (4 files total).
* Include with `#import "GHWalkThroughView.h"` to use it wherever you need.
* Set and implement the `GHWalkThroughViewDataSource` to provide data about the pages.

### Sample Code
```objc
// Creating
    GHWalkThroughView* ghView = [[GHWalkThroughView alloc] initWithFrame:self.view.bounds];
	[ghView setDataSource:self];

// Implementing data source methods
(NSInteger) numberOfPages
{
    return 5;
}

- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
    cell.title = @"Some title for page";
    cell.titleImage = [UIImage imageNamed:@"Title Image name"];
    cell.desc = @"Some Description String";
}

- (UIImage*) bgImageforPage:(NSInteger)index
{
    UIImage* image = [UIImage imageNamed:@"bgimage"];
    return image;
}
```

##Credits

For inspiration
- [EAIntroView](https://github.com/ealeksandrov/EAIntroView)
- [ICETutorial](https://github.com/icepat/ICETutorial)



###License :

The MIT License

