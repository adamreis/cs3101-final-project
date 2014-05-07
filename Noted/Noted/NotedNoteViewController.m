//
//  NotedNoteViewController.m
//  Noted
//
//  Created by Adam Reis on 4/20/14.
//  Copyright (c) 2014 Adam Reis. All rights reserved.
//

#import "NotedNoteViewController.h"
#import "Note.h"
#import "DAKeyboardControl.h"
#import "NotedPhotoCell.h"

@interface NotedNoteViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSMutableArray *photos;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;



@end

@implementation NotedNoteViewController

- (instancetype)initWithNoteID:(NSString *)uuid
{
    if (self = [self initWithNibName:@"NotedNoteViewController" bundle:nil])
    {
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [directories firstObject];
        self.filePath = [documents stringByAppendingPathComponent:[uuid stringByAppendingPathExtension:@"plist"]];
        NSLog(@"Saved original filepath: %@", self.filePath);
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
            NSData *data = [NSData dataWithContentsOfFile:self.filePath];
            self.note = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } else {
            self.note = [[Note alloc] init];
            self.note.index = -1; // indicate an error
            NSLog(@"Cannot find file at: %@", self.filePath);
        }
        
        NSString *testPhotoPath = [documents stringByAppendingString:[@"test" stringByAppendingPathExtension:@"jpg"]];
        UIImage *testImage = [UIImage imageWithContentsOfFile:testPhotoPath];
        [self.photos addObject:testImage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.note.index == -1) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"There was an error loading your saved note!"  message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [errorAlert show];
    }
    
//    UITextView *newTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height)];
//    [self.view addSubview:newTextView];
//    newTextView.text = self.note.text;
    
    self.title = self.note.title;
    self.noteTextView.text = self.note.text;

    [self.photoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDisappeared) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(keyboardAppeared) name:UIKeyboardWillShowNotification object:nil];
    
//    [self.photoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];
    
//    self.noteTextField.keyboardTriggerOffset = -216.0f;    // Input view frame height
//    UITextView *textField = self.noteTextView;
//    
//    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
//        // Move interface objects accordingly
//        // Animation block is handled for you
//
//        CGRect textFieldFrame = self.noteTextView.frame;
//        textFieldFrame.size.height = keyboardFrameInView.origin.y;
//        self.noteTextView.frame = textFieldFrame;
//        
////        
////        self.noteTextField.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, keyboardFrameInView.origin.y);
//////        self.noteTextField.frame.size.height = keyboardFrameInView.origin.y;
//        NSLog(@"this thingy was called: %f", keyboardFrameInView.origin.y);
//    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.photoCollectionView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, 64);
    self.noteTextView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height);

}

-(void) keyboardDisappeared
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    self.noteTextView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void) keyboardAppeared
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    self.noteTextView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height-218);
    [UIView commitAnimations];
}


- (void)viewWillDisappear:(BOOL)animated {
    if (animated) {
        self.note.text = self.noteTextView.text;
        [NSKeyedArchiver archiveRootObject:self.note toFile:self.filePath];
        NSLog(@"saved note to: %@", self.filePath);
        [self.delegate inputController:self didFinishWithNote:self.note];
    }
    [self.view removeKeyboardControl];
    [self.noteTextView removeKeyboardControl];
    [super viewDidDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count] + 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NotedPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];

//    if(!cell) {
//        if (!cell) {
//            cell = [[UICollectionViewCell alloc] init];
//        }
//    }
    cell.backgroundColor = [UIColor blueColor];
    if (indexPath.row < [self.photos count]) {
//        UIImageView  *imageView = [UIImageView initWithImage:self.photos objectAtIndex:indexPath.row];
        cell.image.image = [self.photos objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Select Item
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: Deselect Item
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20); 
}

@end
