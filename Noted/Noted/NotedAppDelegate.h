//
//  NotedAppDelegate.h
//  Noted
//
//  Created by Adam Reis on 4/20/14.
//  Copyright (c) 2014 Adam Reis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotedTableViewController.h"

@interface NotedAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NotedTableViewController *tableVC;

@end
