//
//  ViewController.m
//  ShiuCustomDropDown
//
//  Created by AllenShiu on 2016/5/23.
//  Copyright © 2016年 AllenShiu. All rights reserved.
//

#import "ViewController.h"
#import "CustomDropDown.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"1", @"2", @"3", @"4", @"5", @"6",@"7",@"8", @"9", @"10"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)buttonAction:(id)sender {
    CustomDropDown *customDropDown = [[CustomDropDown alloc] initShowCustomDropDownWithButton:self.button tableViewDataSource:self.dataArray direction:AnimationDirectionDown newFrame:self.button.frame selectCompleteBlock: ^(NSInteger selectIndex) {
        [customDropDown removeFromSuperview];
    }];
    [self.view addSubview:customDropDown];
}


@end
