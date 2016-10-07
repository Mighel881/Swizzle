//
//  TBTweakRootViewController.m
//  TBTweakViewController
//
//  Created by Tanner on 8/24/16.
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

#import "TBTweakRootViewController.h"
#import "TBTweakListViewController.h"
#import "TBTweakManager.h"


@implementation TBTweakRootViewController

- (id)init {
    self = [super init];
    if (self) {
        TBTweakManager *manager = [TBTweakManager sharedManager];
        if (manager.appTweaksTableViewController &&
            manager.systemTweaksTableViewController) {
            self.viewControllers = @[manager.appTweaksTableViewController, manager.systemTweaksTableViewController];
        } else {
            self.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:[TBTweakListViewController appTweaks]],
                                     [[UINavigationController alloc] initWithRootViewController:[TBTweakListViewController systemTweaks]]];
            manager.appTweaksTableViewController = [self.viewControllers[0] viewControllers][0];
            manager.systemTweaksTableViewController = [self.viewControllers[1] viewControllers][0];
        }
        
    }
    
    return self;
}

@end