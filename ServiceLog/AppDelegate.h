//
//  AppDelegate.h
//  ServiceLog
//
//  Created by Mark Adams on 1/9/12.
//  Copyright (c) 2012 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
