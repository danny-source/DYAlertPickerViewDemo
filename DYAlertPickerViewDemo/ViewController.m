//
//  ViewController.m
//  DYAlertPickerViewDemo
//
//  Created by danny on 2015/7/7.
//  Copyright (c) 2015年 danny. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property NSArray *item;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.item = @[@"Left", @"Right", @"Left binds", @"Right binds", @"Other"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *)DYAlertPickView:(DYAlertPickView *)pickerView
                           titleForRow:(NSInteger)row{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.item[row]];
    return str;
}
- (NSInteger)numberOfRowsInPickerView:(DYAlertPickView *)pickerView {
    return self.item.count;
}
- (void)DYAlertPickView:(DYAlertPickView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    NSLog(@"%@ didConfirm", self.item[row]);
}

- (void)DYAlertPickerViewDidClickCancelButton:(DYAlertPickView *)pickerView {
    NSLog(@"Canceled");
}

- (void)DYAlertPickerViewDidClickSwitchButton:(UISwitch *)switchButton {
    NSLog(@"switch:%@",(switchButton.isOn?@"On":@"Off"));
}

- (BOOL)DYAlertPickerViewStateOfSwitchButton {
    return YES;
}

- (IBAction)showAlertPickerView:(id)sender {
    DYAlertPickView *picker = [[DYAlertPickView alloc] initWithHeaderTitle:@"Both Action" cancelButtonTitle:@"2" confirmButtonTitle:@"1" switchButtonTitle:@""];
    picker.delegate = self;
    picker.dataSource = self;
    [picker showAndSelectedIndex:3];
}
@end
