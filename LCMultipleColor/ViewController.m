//
//  ViewController.m
//  LCMultipleColor
//
//  Created by 凌创科技 on 2017/6/16.
//  Copyright © 2017年 凌创科技. All rights reserved.
//

#import "ViewController.h"
#import "LCMultipleColorViewController.h"

@interface ViewController ()
@property (nonatomic,strong)ViewController *controller;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
//    ViewController *controller = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];

    NSInteger index = self.navigationController.viewControllers.count % 3;
    if(index == 0){
        controller.config = [[LCMultipleColorConfig alloc]initWithColorString:@"FFFFF0" hidden:NO whiteTitle:NO];
        
    }else if(index == 1){
        controller.config = [[LCMultipleColorConfig alloc]initWithColorString:@"FF3E96" hidden:NO whiteTitle:YES];

    }else if (index == 2){
        controller.config = [[LCMultipleColorConfig alloc]initWithColorString:@"00B2EE" hidden:YES whiteTitle:YES];

    }
    
    self.controller = controller;
    self.title = [NSString stringWithFormat:@"第%ld个页面",index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextClick {
    
    [self.navigationController pushViewController:self.controller animated:YES];
}

@end
