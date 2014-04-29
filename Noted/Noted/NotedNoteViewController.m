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
@property (weak, nonatomic) IBOutlet UITextView *noteTextField;

@end

@implementation NotedNoteViewController

- (instancetype)initWithNote:(Note *)note
{
    if (self = [self initWithNibName:@"NotedNoteViewController" bundle:nil])
    {
        self.note = note;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.note.title;
    self.noteTextField.text = self.note.text;
    [self.noteTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (animated) {
        self.note.text = self.noteTextField.text;
        [self.delegate inputController:self didFinishWithNote:self.note];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
