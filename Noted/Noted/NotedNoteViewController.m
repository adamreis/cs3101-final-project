//
//  NotedNoteViewController.m
//  Noted
//
//  Created by Adam Reis on 4/20/14.
//  Copyright (c) 2014 Adam Reis. All rights reserved.
//

#import "NotedNoteViewController.h"
#import "Note.h"

@interface NotedNoteViewController ()

@property (strong, nonatomic) Note *note;
@property (weak, nonatomic) NSString *filePath;
@property (weak, nonatomic) IBOutlet UITextView *noteTextField;


@end

@implementation NotedNoteViewController

- (instancetype)initWithNotePath:(NSString *)path
{
    if (self = [self initWithNibName:@"NotedNoteViewController" bundle:nil])
    {
//        sleep(5);
        self.filePath = path;
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
    self.noteTextField.text = self.note.text;
    [self.noteTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (animated) {
        self.note.text = self.noteTextField.text;
        [NSKeyedArchiver archiveRootObject:self.note toFile:self.filePath];
        
//        [self.delegate inputController:self didFinishWithNote:self.note];
    }
    
    
    [super viewDidDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
