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

@interface NotedNoteViewController ()

@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) NSString *filePath;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

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
    
    self.title = self.note.title;
    self.noteTextView.text = self.note.text;


    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDisappeared) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(keyboardAppeared) name:UIKeyboardWillShowNotification object:nil];
    
//    self.noteTextField.keyboardTriggerOffset = -216.0f;    // Input view frame height
//    UITextView *textField = self.noteTextView;
    
//    [self.noteTextView addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
//        // Move interface objects accordingly
//        // Animation block is handled for you
//
//        CGRect textFieldFrame = textField.frame;
//        textFieldFrame.size.height = keyboardFrameInView.origin.y;
//        textField.frame = textFieldFrame;
//        
////        
////        self.noteTextField.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, keyboardFrameInView.origin.y);
//////        self.noteTextField.frame.size.height = keyboardFrameInView.origin.y;
//        NSLog(@"this thingy was called: %f", keyboardFrameInView.origin.y);
//    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.noteTextView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
}

-(void) keyboardDisappeared
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.2f];
//    [UIView setAnimationBeginsFromCurrentState: NO];
//    self.view.frame
    self.noteTextView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void) keyboardAppeared
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.2f];
//    [UIView setAnimationBeginsFromCurrentState: NO];
//    self.view.frame
    self.noteTextView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-218);
    [UIView commitAnimations];
}


- (void)viewWillDisappear:(BOOL)animated {
    if (animated) {
        self.note.text = self.noteTextView.text;
        [NSKeyedArchiver archiveRootObject:self.note toFile:self.filePath];
        NSLog(@"saved note to: %@", self.filePath);
        [self.delegate inputController:self didFinishWithNote:self.note];
    }
    [self.noteTextView removeKeyboardControl];
    [super viewDidDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
