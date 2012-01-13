//
//  CarsViewController.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/10/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "CarsViewController.h"
#import "Car.h"
#import "AddCarViewController.h"
#import "MaintenanceLogViewController.h"

@interface CarsViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Interface Actions
- (IBAction)toggleEditing:(id)sender;

// NSManagedObjectContext Helper Methods
- (void)saveContextIfNecessary;

// Interface Helper Methods
- (UIBarButtonItem *)leftBarButton;

// Table View Helper Methods
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - 

@implementation CarsViewController

@synthesize managedObjectContext;

@synthesize fetchedResultsController;
@synthesize editButton;
@synthesize doneButton;
@synthesize tableView;

#pragma mark - Getters
- (NSFetchedResultsController *)fetchedResultsController
{
    if (!fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Car"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:YES];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"CarsCache"];
        fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        
        if (![fetchedResultsController performFetch:&error])
            NSLog(@"Could not perform fetch. %@, %@", error, error.userInfo);
    }
    
    return fetchedResultsController;
}

#pragma mark - View Lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)viewDidUnload
{
    self.editButton = nil;
    self.doneButton = nil;
    self.tableView = nil;
    [super viewDidUnload];
}

#pragma mark - View Helpers
- (UIBarButtonItem *)leftBarButton
{
    if (self.tableView.editing)
        return self.doneButton;
    
    return self.editButton;
}

#pragma mark - Interface Actions
- (IBAction)toggleEditing:(id)sender
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    [self.navigationItem setLeftBarButtonItem:self.leftBarButton animated:YES];
    
    if (!self.tableView.editing)
        [self saveContextIfNecessary];
}

#pragma mark - UIViewController Overrides
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddCar"])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AddCarViewController *acvc = (AddCarViewController *)navController.topViewController;
        
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        moc.parentContext = self.managedObjectContext;
        acvc.managedObjectContext = moc;
                
        acvc.cancelBlock = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        acvc.doneBlock = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
    else if ([segue.identifier isEqualToString:@"PushMaintenanceLog"])
    {
        MaintenanceLogViewController *mlvc = (MaintenanceLogViewController *)segue.destinationViewController;
        mlvc.managedObjectContext = self.managedObjectContext;
    }
}

#pragma mark - NSManagedObjectContext Helper Methods
- (void)saveContextIfNecessary
{   
    if (!self.managedObjectContext.hasChanges)
        return;
    
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error])
        NSLog(@"Could not save context. %@, %@", error, error.userInfo);
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CarCell"];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}
                           
#pragma mark UITableViewDataSource Helper Methods
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Car *car = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", car.make, car.model];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [car.year integerValue]];
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert)
        return;
    
    Car *deletedCar = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.managedObjectContext deleteObject:deletedCar];
}

#pragma mark - NSFetchedResultsControllerDelegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{        
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end