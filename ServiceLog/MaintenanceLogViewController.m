//
//  MaintenanceLogViewController.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/13/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "MaintenanceLogViewController.h"
#import "Maintenance.h"
#import "Maintenance+Helpers.h"
#import "Car.h"
#import "Car+Helpers.h"
#import "IAActionSheet.h"
#import "AddMaintenanceEventViewController.h"

@interface MaintenanceLogViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *vehicleImageView;
@property (strong, nonatomic) IBOutlet UILabel *vehicleLabel;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

- (void)setupTableHeader;
- (IBAction)addMaintenanceEvent:(id)sender;
- (void)presentAddMaintenanceEventViewControllerWithMaintenanceType:(MaintenanceType)type;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark -

@implementation MaintenanceLogViewController

@synthesize managedObjectContext;
@synthesize car;

@synthesize tableView;
@synthesize vehicleImageView;
@synthesize vehicleLabel;
@synthesize fetchedResultsController;
@synthesize dateFormatter;

#pragma mark - Getters
- (NSFetchedResultsController *)fetchedResultsController
{
    if (!fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Maintenance"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"car == %@", self.car];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datePerformed" ascending:NO];
        fetchRequest.sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        fetchedResultsController.delegate = self;
        NSError *error = nil;
        
        if (![fetchedResultsController performFetch:&error])
            NSLog(@"Could not perform fetch request. %@, %@", error, error.userInfo);
    }
    
    return fetchedResultsController;
}

- (NSDateFormatter *)dateFormatter
{
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    return dateFormatter;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableHeader];
}

#pragma mark - View Helpers
- (void)setupTableHeader
{
    self.vehicleLabel.text = self.car.makeAndModel;
    
    self.vehicleImageView.layer.cornerRadius = 4.0f;
    self.vehicleImageView.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.35f].CGColor;
    self.vehicleImageView.layer.borderWidth = 1.0f;
    self.vehicleImageView.layer.masksToBounds = YES;
}

#pragma mark - Interface Actions
- (IBAction)addMaintenanceEvent:(id)sender
{
    __block IAActionSheet *actionSheet = [[IAActionSheet alloc] initWithTitle:@"Select Maintenance Type" cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[Maintenance maintenanceTypes] dismissalBlock:^(NSInteger tappedButtonIndex) {
        
        if (tappedButtonIndex == actionSheet.cancelButtonIndex)
            return;
        
        
        [self presentAddMaintenanceEventViewControllerWithMaintenanceType:tappedButtonIndex];
    }];
    
    [actionSheet showInView:self.view];
}

- (void)presentAddMaintenanceEventViewControllerWithMaintenanceType:(MaintenanceType)type
{
    AddMaintenanceEventViewController *amevc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddMaintenanceEventViewController"];
    amevc.car = self.car;
    amevc.maintenanceType = type;
    amevc.managedObjectContext = self.managedObjectContext;
    
    __weak AddMaintenanceEventViewController *weakController = amevc;
    
    amevc.completionBlock = ^(BOOL saved) {
        [weakController willMoveToParentViewController:nil];
        [weakController viewWillDisappear:YES];
        [weakController.view removeFromSuperview];
        [weakController viewDidDisappear:YES];
        [weakController removeFromParentViewController];
    };
    
    [self.navigationController addChildViewController:amevc];
    [amevc viewWillAppear:YES];
    [self.navigationController.view addSubview:amevc.view];
    [amevc viewDidAppear:YES];
    [amevc didMoveToParentViewController:self.navigationController];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MaintenanceCell"];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark UITableViewDataSource Helper Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Maintenance *maintenance = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = maintenance.typeString;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:maintenance.datePerformed];
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{        
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
