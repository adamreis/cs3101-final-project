//
//  NotedNoteViewController.h
//  Noted
//
//  Created by Adam Reis on 4/20/14.
//  Copyright (c) 2014 Adam Reis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@class NotedNoteViewController;

@protocol NotedNoteViewControllerDelegate <NSObject>

- (void)inputController:(NotedNoteViewController *)controller didFinishWithNote:(Note *)note;

@end

@interface NotedNoteViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithNoteID:(NSString *)uuid;
@property (weak, nonatomic) id<NotedNoteViewControllerDelegate> delegate;

@end
