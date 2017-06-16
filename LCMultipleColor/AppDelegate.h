//
//  AppDelegate.h
//  LCMultipleColor
//
//  Created by 凌创科技 on 2017/6/16.
//  Copyright © 2017年 凌创科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

