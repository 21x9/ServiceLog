//
//  CarsViewController.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/10/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "CarsViewController.h"
#import "Car.h"

@interface CarsViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - 

@implementation CarsViewController

@synthesize managedObjectContext;
@synthesize tableView;

@synthesize fetchedResultsController;

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
- (void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
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

@end
