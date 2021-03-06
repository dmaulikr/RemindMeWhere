//
//  AppDelegate.m
//  LocationReminders
//
//  Created by Jake Romer on 5/1/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

#import "AppDelegate.h"
#import "ParseConfiguration.h"
@import UserNotifications;

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self registerForNotifications];
  [ParseConfiguration configure];
  return YES;
}

- (void)registerForNotifications {
  UNAuthorizationOptions options;
  options = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge |
            UNAuthorizationOptionSound;

  UNUserNotificationCenter *center;
  center = [UNUserNotificationCenter currentNotificationCenter];
  [center requestAuthorizationWithOptions:options
                        completionHandler:^(BOOL granted,
                                            NSError *_Nullable error) {
                          if (error) {
                            NSLog(@"error: %@", error.localizedDescription);
                          }
                          if (granted) {
                            NSLog(@"user permits notifications");
                          }
                        }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [self saveContext];
}

#pragma mark - Notifications

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:
              (void (^)(UIBackgroundFetchResult))completionHandler {
  NSLog(@"%@", userInfo);
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
  // The persistent container for the application. This implementation creates
  // and returns a container, having loaded the store for the application to it.
  @synchronized(self) {
    if (_persistentContainer == nil) {
      _persistentContainer =
          [[NSPersistentContainer alloc] initWithName:@"LocationReminders"];
      [_persistentContainer
          loadPersistentStoresWithCompletionHandler:^(
              NSPersistentStoreDescription *storeDescription, NSError *error) {
            if (error != nil) {
              // Replace this implementation with code to handle the error
              // appropriately. abort() causes the application to generate a
              // crash log and terminate. You should not use this function in a
              // shipping application, although it may be useful during
              // development.

              /*
               Typical reasons for an error here include:
               * The parent directory does not exist, cannot be created, or
               disallows writing. * The persistent store is not accessible, due
               to permissions or data protection when the device is locked. *
               The device is out of space. * The store could not be migrated to
               the current model version. Check the error message to determine
               what the actual problem was.
               */
              NSLog(@"Unresolved error %@, %@", error, error.userInfo);
              abort();
            }
          }];
    }
  }

  return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
  NSManagedObjectContext *context = self.persistentContainer.viewContext;
  NSError *error = nil;
  if ([context hasChanges] && ![context save:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You
    // should not use this function in a shipping application, although it may
    // be useful during development.
    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    abort();
  }
}

@end
