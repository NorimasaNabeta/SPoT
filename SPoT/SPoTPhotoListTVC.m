//
//  SPoTPhotoListTVC.m
//  SPoT
//
//  Created by Norimasa Nabeta on 2013/02/23.
//  Copyright (c) 2013年 CS193p. All rights reserved.
//

#import "SPoTPhotoListTVC.h"
#import "FlickrFetcher.h"

@interface SPoTPhotoListTVC ()
@property (nonatomic,strong) NSDictionary *photoList;
@end

@implementation SPoTPhotoListTVC

//
//
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *photos = [FlickrFetcher stanfordPhotos];

    NSMutableDictionary *work = [[NSMutableDictionary alloc] init];
    for (NSDictionary *photo in photos) {
        // NSLog(@"%@", photo[FLICKR_TAGS]);
        NSArray *tags = [photo[FLICKR_TAGS] componentsSeparatedByString:@" "];
        for (NSString *tag in tags) {
            if ((! [tag isEqualToString:@"cs193pspot"]) &&
                (! [tag isEqualToString:@"portrait"]) && (! [tag isEqualToString:@"landscape"])){
                // NSLog(@">> %@", tag);
                if (! work[tag]) {
                    work[tag] = [[NSMutableArray alloc] init];
                }
                [work[tag] addObject:photo];
            }
        }
    }
    self.photoList = work;
//    for (NSString *key in work) {
//        NSLog(@"Key: %@ %d", key, [work[key] count]);
//    }

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
            if ([segue.identifier isEqualToString:@"Show Detail"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                    NSString *tag = [[self.photoList allKeys] objectAtIndex:indexPath.item];
                    NSArray *list = self.photoList[tag];
                    [segue.destinationViewController performSelector:@selector(setPhotos:)
                                                          withObject:list];
                    [segue.destinationViewController setTitle:tag];
                }
            }
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.photoList allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Tag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    NSString *tag = [[self.photoList allKeys] objectAtIndex:indexPath.item];
    cell.textLabel.text = tag;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Count: %d", [self.photoList[tag] count]];

    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
