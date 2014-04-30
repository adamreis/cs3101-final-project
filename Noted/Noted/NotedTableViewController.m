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

@property (strong, nonatomic) NSMutableArray *notes;

@end

@implementation NotedTableViewController

- (instancetype) init
{
    self = [super init];
    
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [directories firstObject];
    NSString *filePathNotes = [documents stringByAppendingPathComponent:@"notes.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePathNotes]) {
        NSData *data = [NSData dataWithContentsOfFile:filePathNotes];
        self.notes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        self.notes = [[NSMutableArray alloc] init];
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
//    [newNoteAlert textFieldAtIndex:0].delegate = self;
    [newNoteAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        
        Note *newNote = [[Note alloc] initWithTitle:alertTextField.text text:@"" index:self.notes.count uuid:[[NSUUID UUID] UUIDString]];
        
        
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [directories firstObject];
        NSString *filePathNewNote = [documents stringByAppendingPathComponent:[newNote.uuid stringByAppendingPathExtension:@"plist"]];
        NSString *filePathNotes = [documents stringByAppendingPathComponent:@"notes.plist"];

        [self.notes addObject:@[newNote.title, newNote.uuid]];
        
        [NSKeyedArchiver archiveRootObject:newNote toFile:filePathNewNote];
        [NSKeyedArchiver archiveRootObject:self.notes toFile:filePathNotes];

        [self.tableView reloadData];
        
        NotedNoteViewController *noteVC = [[NotedNoteViewController alloc ] initWithNoteID:newNote.uuid];
        noteVC.delegate = self;
        [self.navigationController pushViewController:noteVC animated:YES];
    }
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
    
    cell.textLabel.text = [[self.notes objectAtIndex:indexPath.row] objectAtIndex:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotedNoteViewController *noteVC = [[NotedNoteViewController alloc ] initWithNoteID:[[self.notes objectAtIndex:indexPath.row] objectAtIndex:1]];
    noteVC.delegate = self;
    [self.navigationController pushViewController:noteVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)inputController:(NotedNoteViewController *)controller didFinishWithNote:(Note *)note
{
    [self.notes replaceObjectAtIndex:note.index withObject:@[note.title, note.uuid]];
    
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [directories firstObject];
    NSString *filePathNotes = [documents stringByAppendingPathComponent:@"notes.plist"];
    [NSKeyedArchiver archiveRootObject:self.notes toFile:filePathNotes];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
    return NO;
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
