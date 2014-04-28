//
//  NotedTableViewController.m
//  Noted
//
//  Created by Adam Reis on 4/20/14.
//  Copyright (c) 2014 Adam Reis. All rights reserved.
//

#import "NotedTableViewController.h"
#import "Note.h"
#import "NotedNoteViewController.h"

@interface NotedTableViewController () <NotedNoteViewControllerDelegate>


@end

@implementation NotedTableViewController


- (instancetype)initWithNotes: (NSMutableArray *)notes
{
    if (self = [self initWithNibName:nil bundle:nil]) {
        self.notes = notes;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Notes";
    
    UIBarButtonItem *newNoteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)];
    self.navigationItem.rightBarButtonItem = newNoteButton;
}

- (void)addButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertView *newNoteAlert = [[UIAlertView alloc] initWithTitle:@"add new note"  message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"add note", nil];
    newNoteAlert.alertViewStyle = UIAlertViewStylePlainTextInput;

    [newNoteAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    Note *newNote = [[Note alloc] init];
    newNote.title = alertTextField.text;
    newNote.index = self.notes.count;
    [self.notes addObject:newNote];
    NSLog(@"%@", self.notes);
    [self.tableView reloadData];
    
    NotedNoteViewController *noteVC = [[NotedNoteViewController alloc ] initWithNote:newNote];
    noteVC.delegate = self;
    [self.navigationController pushViewController:noteVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusableNoteCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusableNoteCell"];
    }
    
    Note *noteObject = self.notes[indexPath.row];
    cell.textLabel.text = noteObject.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotedNoteViewController *noteVC = [[NotedNoteViewController alloc ] initWithNote:self.notes[indexPath.row]];
    noteVC.delegate = self;
    [self.navigationController pushViewController:noteVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)inputController:(NotedNoteViewController *)controller didFinishWithNote:(Note *)note
{
    self.notes[note.index] = note;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
