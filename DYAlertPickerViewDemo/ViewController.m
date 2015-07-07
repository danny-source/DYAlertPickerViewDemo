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
    self.item = @[@"Left", @"Right", @"Left binds", @"Right binds"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *)DYAlerPickView:(DYAlerPickView *)pickerView
                           titleForRow:(NSInteger)row{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.item[row]];
    return str;
}
- (NSInteger)numberOfRowsInPickerView:(DYAlerPickView *)pickerView{
    return self.item.count;
}
- (void)DYAlerPickView:(DYAlerPickView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    NSLog(@"%@ is chosen!", self.item[row]);
}

- (void)DYAlertPickerViewDidClickCancelButton:(DYAlerPickView *)pickerView{
    NSLog(@"Canceled.");
}

- (IBAction)showAlertPickerView:(id)sender {
    DYAlerPickView *picker = [[DYAlerPickView alloc] initWithHeaderTitle:@"Both Action" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"OK" switchButtonTitle:@"Don't Ask Me"];
    picker.delegate = self;
    picker.dataSource = self;

    [picker showAndSelectedIndex:5];
}
@end
