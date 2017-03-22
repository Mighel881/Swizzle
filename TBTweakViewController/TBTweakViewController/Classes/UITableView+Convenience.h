//
//  UITableView+Convenience.h
//  TBTweakViewController
//
//  Created by Tanner on 3/9/17.
//  Copyright © 2017 Tanner Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Convenience)

/// @param cellClass must be a TBBaseValueCell subclass
- (void)registerCell:(Class)cellClass;

/// @param classes an array of TBBaseValueCell subclasses
- (void)registerCells:(NSArray *)classes;

- (void)reloadSection:(NSUInteger)section;
- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

@end
