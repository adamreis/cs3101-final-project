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

@interface NotedTableViewController ()

//@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *notes;


@end

@implementation NotedTableViewController


- (instancetype)init
{
    if (self = [self initWithNibName:nil bundle:nil]) {
        self.notes = [NSMutableArray array];
//        CGRect textFieldRect = CGRectMake(0,0,100,100);
//        self.textField = [[UITextField alloc] initWithFrame:textFieldRect];
    }
    return self;
}

//- (void)loadView
//{
//    [super loadView];
//    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
//}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Notes";
    
    UIBarButtonItem *newNoteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)];
    self.navigationItem.rightBarButtonItem = newNoteButton;
    
//    [window addSubview:]
}

- (void)addButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertView *newNoteAlert = [[UIAlertView alloc] initWithTitle:@"add new note"  message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"add note", nil];
    newNoteAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
//    UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
//    titleTextField.placeholder = @"NEW TITLE, YO";
//    [titleTextField becomeFirstResponder];
//    [titleTextField setBackgroundColor:[UIColor blueColor]];
//    
//    [newNoteAlert addSubview:titleTextField];
    [newNoteAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    Note *newNote = [[Note alloc] init];
    newNote.title = alertTextField.text;
    newNote.index = self.notes.count;
//    [self.notes addObject:alertTextField.text];
    [self.notes addObject:newNote];
    NSLog(@"%@", self.notes);
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotedNoteViewController *noteVC = [[NotedNoteViewController alloc ] initWithNote:self.notes[indexPath.row]];
    noteVC.delegate = self;
    [self.navigationController pushViewController:noteVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)inputController:(NotedNoteViewController *)controller didFinishWithNote:(Note *)note
{
    self.notes[note.index] = note;

//    [self.tableView reloadData];
//    [self dismissViewControllerAnimated:YES completion:nil];
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
