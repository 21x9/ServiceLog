//
//  AppDelegate.m
//  ServiceLog
//
//  Created by Mark Adams on 1/9/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    if (!self.managedObjectContext || !self.managedObjectContext.hasChanges)
        return;
    
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error])
        NSLog(@"Couldn't save managed object context. %@, %@", error, error.userInfo);
}

#pragma mark - Core Data Stack
- (NSManagedObjectContext *)managedObjectContext
{
    if (!managedObjectContext)
    {
        if (!self.persistentStoreCoordinator)
        {
            NSLog(@"Could not create managed object context. Persistent store coordinator is nil.");
            return nil;
        }
        
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!managedObjectModel)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ServiceLog" withExtension:@"momd"];
        
        if (!modelURL)
        {
            NSLog(@"Could not create managed object model. Model URL is nil.");
            return nil;
        }
        
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!persistentStoreCoordinator)
    {
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ServiceLog.sqlite"];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        NSError *error = nil;
        
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
        {
            NSLog(@"Could not add persistent store to persistent store coordinator. %@, %@", error, error.userInfo);
            return nil;
        }
    }
    
    return persistentStoreCoordinator;
}

#pragma mark - Application's Documents Directory
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end