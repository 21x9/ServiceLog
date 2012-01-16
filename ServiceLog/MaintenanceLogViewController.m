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

- (void)setupTableHeader;
- (IBAction)addMaintenanceEvent:(id)sender;
- (void)presentAddMaintenanceEventViewControllerWithMaintenanceType:(MaintenanceType)type;

@end

#pragma mark -

@implementation MaintenanceLogViewController

@synthesize managedObjectContext;
@synthesize car;

@synthesize tableView;
@synthesize vehicleImageView;
@synthesize vehicleLabel;
@synthesize fetchedResultsController;

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
    amevc.maintenanceType = type;
    
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
    Maintenance *maintenanceEvent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MaintenanceCell"];
    cell.textLabel.text = maintenanceEvent.typeString;
    cell.detailTextLabel.text = maintenanceEvent.datePerformed.description;
    
    return cell;
}

@end
