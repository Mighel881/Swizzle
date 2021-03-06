//
//  TBConfigureHookViewController.h
//  TBTweakViewController
//
//  Created by Tanner on 8/22/16.
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBMethodHook.h"
@class TBSectionController, TBHookTypeSectionController;
@class TBReturnValueHookSectionController, TBSwitchCell;


/// Used to edit the configuration of a tweak, existing or new.
@interface TBConfigureHookViewController : UITableViewController

+ (instancetype)forHook:(TBMethodHook *)hook saveAction:(void(^)())saveAction;


// Internal

@property (nonatomic, readonly) TBMethodHook *hook;
@property (nonatomic          ) TBHookType hookType;
@property (nonatomic, copy    ) void (^saveAction)();

@property (nonatomic) TBValue *hookedReturnValue;
@property (nonatomic) NSMutableArray<TBValue*> *hookedArguments;
@property (nonatomic) NSString *chirpString;

@property (nonatomic, readonly) TBHookTypeSectionController *hookTypeSectionController;
@property (nonatomic, readonly) TBReturnValueHookSectionController *returnValueHookSectionController;
@property (nonatomic, readonly) NSMutableArray<TBSectionController*> *dynamicSectionControllers;

@end
