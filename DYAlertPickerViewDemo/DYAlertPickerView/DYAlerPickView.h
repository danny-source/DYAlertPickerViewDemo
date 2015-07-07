//
//  DYAlerPickView.h
//  DYAlertPickerViewDemo
//
//  Created by danny on 2015/7/7.
//  Copyright (c) 2015年 danny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DYAlerPickView;

@protocol DYAlerPickViewDataSource <NSObject>
@required

//
- (NSAttributedString *)DYAlerPickView:(DYAlerPickView *)pickerView
                            titleForRow:(NSInteger)row;


//

- (NSInteger)numberOfRowsInPickerView:(DYAlerPickView *)pickerView;

@end

@protocol DYAlerPickViewDelegate <NSObject>
@optional

// delegate for selecting item
- (void)DYAlerPickView:(DYAlerPickView *)pickerView
          didConfirmWithItemAtRow:(NSInteger)row;

// delegate for canceling
- (void)DYAlertPickerViewDidClickCancelButton:(DYAlerPickView *)pickerView;
@end

@interface DYAlerPickView : UIView<UITableViewDataSource, UITableViewDelegate>

//tap background to dismiss
@property BOOL tapBackgroundToDismiss;

//tap item to select and confirm
@property BOOL tapPickerViewItemToConfirm;

/*
 
 @param headerTitle
 @param cancelButtonTitle
 @param confirmButtonTitle
 @param switchButtonTitle

 */
- (id)initWithHeaderTitle:(NSString *)headerTitle
        cancelButtonTitle:(NSString *)cancelButtonTitle
       confirmButtonTitle:(NSString *)confirmButtonTitle switchButtonTitle:(NSString *)switchButtonTitle;

@property id<DYAlerPickViewDelegate> delegate;
@property id<DYAlerPickViewDataSource> dataSource;

//header background color */
@property (nonatomic, strong) UIColor *headerBackgroundColor;

//header title color */
@property (nonatomic, strong) UIColor *headerTitleColor;

//cancel button background color
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;

//cancel button normal state color
@property (nonatomic, strong) UIColor *cancelButtonNormalColor;

//cancel button highlighted state color
@property (nonatomic, strong) UIColor *cancelButtonHighlightedColor;

//confirm button background color
@property (nonatomic, strong) UIColor *confirmButtonBackgroundColor;

//confirm button normal state color
@property (nonatomic, strong) UIColor *confirmButtonNormalColor;

//confirm button highlighted state color
@property (nonatomic, strong) UIColor *confirmButtonHighlightedColor;

//switch button title
@property (nonatomic, strong) NSString *switchButtonTitle;


//show the AlerPickerView

- (void)show;

//show AlerPickerView and default selected
- (void)showAndSelectedIndex:(NSInteger)index;

@end
