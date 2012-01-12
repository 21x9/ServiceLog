//
//  AddCarViewController.m
//  ServiceLog
//
//  Created by Jennifer Clarke on 1/11/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "AddCarViewController.h"
#import "Car.h"
#import "YearCell.h"

@interface AddCarViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UITextField *makeTextField;
@property (strong, nonatomic) IBOutlet UITextField *modelTextField;
@property (strong, nonatomic) IBOutlet YearCell *yearCell;

@property (strong, nonatomic) NSArray *listOfYears;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

- (void)configureYearCell;
- (void)refreshDoneButton;
- (BOOL)doneButtonShouldBeEnabled;
- (IBAction)textFieldValueChanged:(id)sender;

- (IBAction)makeCellTapped:(UIGestureRecognizer *)gesture;
- (IBAction)modelCellTapped:(UIGestureRecognizer *)gesture;

- (void)saveCar;

@end

#pragma mark -

@implementation AddCarViewController

@synthesize managedObjectContext;
@synthesize cancelBlock;
@synthesize doneBlock;

@synthesize doneButton;
@synthesize makeTextField;
@synthesize modelTextField;
@synthesize yearCell;
@synthesize listOfYears;

#pragma mark - Getters
- (NSArray *)listOfYears
{
    if (!listOfYears)
    {
        NSMutableArray *years = [[NSMutableArray alloc] init];
        NSDateComponents *dateComponents = [[NSCalendar autoupdatingCurrentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        NSInteger currentYear = dateComponents.year;
        
        for (NSInteger index = currentYear; index > (currentYear - 100); index--)
            [years addObject:[NSNumber numberWithInteger:index]];
        
        listOfYears = [years copy];
    }
    
    return listOfYears;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureYearCell];
    [self refreshDoneButton];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.makeTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    self.doneButton = nil;
    self.makeTextField = nil;
    self.modelTextField = nil;
    self.yearCell.pickerView.delegate = nil;
    self.yearCell = nil;
    [super viewDidUnload];
}

#pragma mark - UIViewController Overrides
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.listOfYears = nil;
}

#pragma mark - Interface Actions
- (IBAction)cancel:(id)sender
{
    self.cancelBlock();
}

- (IBAction)done:(id)sender
{
    [self saveCar];
    self.doneBlock();
}

#pragma mark - Interface Helpers
- (void)configureYearCell
{
    self.yearCell.pickerView.dataSource = self;
    self.yearCell.pickerView.delegate = self;
}

- (void)refreshDoneButton
{
    self.doneButton.enabled = [self doneButtonShouldBeEnabled];
}

- (BOOL)doneButtonShouldBeEnabled
{
    BOOL shouldBeEnabled = NO;
    
    if (self.makeTextField.text.length && self.modelTextField.text.length && ![self.yearCell.detailTextLabel.text isEqualToString:@"Select..."])
        shouldBeEnabled = YES;
    
    return shouldBeEnabled;
}

- (IBAction)textFieldValueChanged:(id)sender
{
    [self refreshDoneButton];
}

#pragma mark UIGestureRecognizer Methods
- (void)makeCellTapped:(UIGestureRecognizer *)gesture;
{
    [self.makeTextField becomeFirstResponder];
}

- (void)modelCellTapped:(UIGestureRecognizer *)gesture
{
    [self.modelTextField becomeFirstResponder];
}

#pragma mark - Car Management
- (void)saveCar
{
    Car *car = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:self.managedObjectContext];
    car.make = self.makeTextField.text;
    car.model = self.modelTextField.text;
    car.year = [self.listOfYears objectAtIndex:[self.yearCell.pickerView selectedRowInComponent:0]];
    
    __weak AddCarViewController *weakSelf = self;
    
    [self.managedObjectContext performBlock:^{
        NSError *error = nil;
        
        if (![weakSelf.managedObjectContext save:&error])
            NSLog(@"Could not save discardable context. %@, %@", error, error.userInfo);
        
        [weakSelf.managedObjectContext.parentContext performBlock:^{
            NSError *parentError = nil;
            
            if (![weakSelf.managedObjectContext.parentContext save:&parentError])
                NSLog(@"Could not save parent context. %@, %@", error, error.userInfo);
        }];
    }];
}

#pragma mark - UIPickerViewDataSource Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.listOfYears.count;
}

#pragma mark - UIPickerViewDelegate Methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    if ([view isKindOfClass:[UILabel class]])
        label = (UILabel *)view;
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 44.0f)];
        label.font = [UIFont boldSystemFontOfSize:22.0f];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
    }
    
    label.text = [NSString stringWithFormat:@"%@", [self.listOfYears objectAtIndex:row]];
    
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 150.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.yearCell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", [self.listOfYears objectAtIndex:row]];
    [self refreshDoneButton];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        [self.yearCell becomeFirstResponder];
        self.yearCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.listOfYears objectAtIndex:0]];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.makeTextField)
        [self.modelTextField becomeFirstResponder];
    else if (textField == self.modelTextField)
    {
        [self.yearCell becomeFirstResponder];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        self.yearCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.listOfYears objectAtIndex:0]];
    }
    
    return YES;
}

@end
