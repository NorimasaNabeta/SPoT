//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"


@interface FlickrPhotoTVC() <UISplitViewControllerDelegate>

@end

@implementation FlickrPhotoTVC

#pragma mark - UISplitViewControllerDelegate

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
//    return NO; // never hide it.
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void) setSplitViewBarButtonItem:(UIBarButtonItem *)barButtonItem
{
//    UIToolbar *toolbar = [self toolbar];
//    NSMutableArray *toolbarItems = [toolbar.items mutableCopy];
//    if (_splitViewBarButtonItem) {
//        [toolbarItems removeObject:_splitViewBarButtonItem];
//    }
//
//    if (barButtonItem) {
//        [toolbarItems insertObject:barButtonItem atIndex:0];
//    }
//    toolbar.items =toolbarItems;
//    _splitViewBarButtonItem = barButtonItem;
    
}
- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
//    barButtonItem.title =@"Master";
//    id detailViewController = [self.splitViewController.viewControllers lastObject];
//    [detailViewController setSplitViewBarButtonItem:barButtonItem ];
    
}
- (void) splitViewController:(UISplitViewController *)svc
      willShowViewController:(UIViewController *)aViewController
   invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
//    id detailViewController = [self.splitViewController.viewControllers lastObject];
//    [detailViewController setSplitViewBarButtonItem:nil];
    
}

// sets the Model
// reloads the UITableView (since Model is changing)

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;

    [self.tableView reloadData];
}

#pragma mark - Segue

// prepares for the "Show Image" segue by seeing if the destination view controller of the segue
//  understands the method "setImageURL:"
// if it does, it sends setImageURL: to the destination view controller with
//  the URL of the photo that was selected in the UITableView as the argument
// also sets the title of the destination view controller to the photo's title

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

#pragma mark - UITableViewDataSource

// lets the UITableView know how many rows it should display
// in this case, just the count of dictionaries in the Model's array

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

// a helper method that looks in the Model for the photo dictionary at the given row
//  and gets the title out of it

- (NSString *)titleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description]; // description because could be NSNull
}

// a helper method that looks in the Model for the photo dictionary at the given row
//  and gets the owner of the photo out of it

- (NSString *)subtitleForRow:(NSUInteger)row
{
//    return [self.photos[row][FLICKR_PHOTO_OWNER] description]; // description because could be NSNull
    // NOT objectForKey: FLICKR_PHOTO_DESCRIPTION is @"description._content"
    return [self.photos[row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
}

// loads up a table view cell with the title and owner of the photo at the given row in the Model

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

@end
