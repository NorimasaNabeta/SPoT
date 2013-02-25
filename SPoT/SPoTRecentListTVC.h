//
//  SPoTRecentListTVC.h
//  SPoT
//
//  Created by Norimasa Nabeta on 2013/02/23.
//  Copyright (c) 2013年 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhotoTVC.h"

//@interface SPoTRecentListTVC : UITableViewController
@interface SPoTRecentListTVC : FlickrPhotoTVC
@property (nonatomic,strong) NSArray *recentPlaces;
@end
