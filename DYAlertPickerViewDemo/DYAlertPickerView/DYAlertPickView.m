//
//  DYAlerPickView.h
//  DYAlertPickerViewDemo
//
//  Created by danny on 2015/7/7.
//  Copyright (c) 2015年 danny. All rights reserved.
//

#import "DYAlertPickView.h"

#define DY_BACKGROUND_ALPHA 0.4
#define DY_HEADER_HEIGHT 44.0
#define DY_SWITCH_HEIGHT 35.0
#define DY_FOOTER_HEIGHT 40.0
#define DY_TABLEVIEW_CELL_HEIGHT 44.0


@interface DYAlertPickView ()
@property NSString *headerTitle;
@property NSString *cancelButtonTitle;
@property NSString *confirmButtonTitle;
@property UIView *backgroundMaskView;
@property UIView *containerView;
@property UIView *headerView;
@property UIView *switchView;
@property UIView *footerview;
@property UITableView *tableView;
@property NSIndexPath *selectedIndexPath;

@end

typedef void (^DYAlertPickerViewDismissCallback)(void);

@implementation DYAlertPickView{
    DYAlertPickerViewDismissCallback callback;
    BOOL isUIDeviceOrientation;
}

#pragma mark - initial UIControl

- (id)initWithHeaderTitle:(NSString *)headerTitle
        cancelButtonTitle:(NSString *)cancelButtonTitle
       confirmButtonTitle:(NSString *)confirmButtonTitle switchButtonTitle:(NSString *)switchButtonTitle {
    self = [super init];
    if(self){
        self.tapBackgroundToDismiss = YES;
 
        self.headerTitle = headerTitle ? headerTitle : @"";
        self.headerTitleColor = [UIColor whiteColor];
        self.headerBackgroundColor = [UIColor colorWithRed:51.0/255 green:153.0/255 blue:255.0/255 alpha:1];
        
        // footer button
        self.confirmButtonTitle = confirmButtonTitle ? confirmButtonTitle: @"";
        self.confirmButtonNormalColor = [UIColor whiteColor];
        self.confirmButtonHighlightedColor = [UIColor grayColor];
        self.confirmButtonBackgroundColor = [UIColor colorWithRed:56.0/255 green:185.0/255 blue:158.0/255 alpha:1];
        
        self.cancelButtonTitle = cancelButtonTitle ? cancelButtonTitle:@"";
        self.cancelButtonNormalColor = [UIColor whiteColor];
        self.cancelButtonHighlightedColor = [UIColor grayColor];
        self.cancelButtonBackgroundColor = [UIColor colorWithRed:255.0/255 green:71.0/255.0 blue:25.0/255 alpha:1];
    
        self.switchButtonTitle = switchButtonTitle ? switchButtonTitle:@"";
        self.tapPickerViewItemToConfirm = NO;
        CGRect rect= [UIScreen mainScreen].bounds;
        self.frame = rect;
        isUIDeviceOrientation = NO;
    }
    return self;
}

- (void)setupSubViews {
    CGRect rect= [UIScreen mainScreen].bounds;
    self.frame = rect;
    //mask is full screen
    self.backgroundMaskView = [self buildBackgroundMaskView];
    [self addSubview:self.backgroundMaskView];
    
    self.containerView = [self buildContainerView];
    [self addSubview:self.containerView];
    
    self.tableView = [self buildTableView];
    [self.containerView addSubview:self.tableView];
    
    self.headerView = [self buildHeaderView];
    [self.containerView addSubview:self.headerView];
    self.switchView = [self buildSwitchView];
    [self.containerView addSubview:self.switchView];
    self.footerview = [self buildFooterView];
    [self.containerView addSubview:self.footerview];

    
    CGRect frame = self.containerView.frame;
    self.containerView.frame = CGRectMake(frame.origin.x,
                                          frame.origin.y,
                                          frame.size.width,
                                          self.headerView.frame.size.height + self.tableView.frame.size.height +
                                          self.footerview.frame.size.height + self.switchView.frame.size.height);
    
    self.containerView.center = CGPointMake(self.center.x, self.center.y);

//
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (UIView *)buildContainerView{
    CGAffineTransform transform = CGAffineTransformMake(0.8, 0, 0.0, 0.6, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);
    UIView *bcv = [[UIView alloc] initWithFrame:newRect];
    bcv.layer.cornerRadius = 5.0f;
    bcv.clipsToBounds = YES;
    return bcv;
}

- (UITableView *)buildTableView{
    CGAffineTransform transform = CGAffineTransformMake(0.8, 0, 0, 0.6, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);
    NSInteger n = [self.dataSource numberOfRowsInDYAlertPickerView:self];
    CGRect tableRect;
    float heightOffset = DY_HEADER_HEIGHT + (([self.confirmButtonTitle isEqualToString:@""] && [self.cancelButtonTitle isEqualToString:@""])? 0.0f:DY_FOOTER_HEIGHT) + ([self.switchButtonTitle isEqualToString:@""]?0.0f:DY_SWITCH_HEIGHT);
    if(n > 0){
        float height = n * DY_TABLEVIEW_CELL_HEIGHT;
        height = height > newRect.size.height - heightOffset ? newRect.size.height - heightOffset : height;
        tableRect = CGRectMake(0, DY_TABLEVIEW_CELL_HEIGHT, newRect.size.width, height);
    } else {
        tableRect = CGRectMake(0, DY_TABLEVIEW_CELL_HEIGHT, newRect.size.width, newRect.size.height - heightOffset);
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}

- (UIView *)buildBackgroundMaskView{
    
    UIView *bgv;
    bgv = [[UIView alloc] initWithFrame:self.frame];
    bgv.alpha = 0.0;
    bgv.backgroundColor = [UIColor blackColor];
    if(self.tapBackgroundToDismiss){
        [bgv addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(cancelButtonPressed:)]];
    }
    return bgv;
}

- (UIView *)buildFooterView{
    
    if (([self.cancelButtonTitle isEqualToString:@""]) && ([self.confirmButtonTitle isEqualToString:@""])){
        self.tapPickerViewItemToConfirm = YES;
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    CGRect rect = ([self.switchButtonTitle isEqualToString:@""]?self.tableView.frame:self.switchView.frame);
    CGRect newRect = CGRectMake(0,
                                rect.origin.y + rect.size.height,
                                rect.size.width,
                                DY_FOOTER_HEIGHT);
    
    CGRect leftRect = CGRectZero;
    CGRect rightRect = CGRectZero;
    //
    if ([self.cancelButtonTitle isEqualToString:@""]){
        rightRect = CGRectMake(0,0, newRect.size.width, DY_FOOTER_HEIGHT);
    }else if ([self.confirmButtonTitle isEqualToString:@""]){
        leftRect = CGRectMake(0,0, newRect.size.width, DY_FOOTER_HEIGHT);
    }else {
        leftRect = CGRectMake(0,0, (newRect.size.width /2), DY_FOOTER_HEIGHT);
        rightRect = CGRectMake((newRect.size.width/2),0, (newRect.size.width/2), DY_FOOTER_HEIGHT);
    }
    UIView *bfv = [[UIView alloc] initWithFrame:newRect];
    bfv.backgroundColor = [UIColor blackColor];
    //
    if ((leftRect.size.width > 0) && (leftRect.size.height > 0)) {

        UIButton *cancelButton = [[UIButton alloc] initWithFrame:leftRect];
        [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor: self.cancelButtonNormalColor forState:UIControlStateNormal];
        [cancelButton setTitleColor:self.cancelButtonHighlightedColor forState:UIControlStateHighlighted];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        cancelButton.backgroundColor = self.cancelButtonBackgroundColor;
        [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [bfv addSubview:cancelButton];
    }
    if ((rightRect.size.width > 0) && (rightRect.size.height > 0)) {
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:rightRect];
        [confirmButton setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
        [confirmButton setTitleColor:self.confirmButtonNormalColor forState:UIControlStateNormal];
        [confirmButton setTitleColor:self.confirmButtonHighlightedColor forState:UIControlStateHighlighted];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        confirmButton.backgroundColor = self.confirmButtonBackgroundColor;
        [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [bfv addSubview:confirmButton];
    }

    

    return bfv;
}


- (UIView *)buildHeaderView {
    UIView *bhv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, DY_HEADER_HEIGHT)];
    bhv.backgroundColor = self.headerBackgroundColor;
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName: self.headerTitleColor,
                           NSFontAttributeName: [UIFont systemFontOfSize:16.0]
                           };
    NSAttributedString *at = [[NSAttributedString alloc] initWithString:self.headerTitle attributes:dict];
    UILabel *label = [[UILabel alloc] initWithFrame:bhv.frame];
    label.attributedText = at;
    [label sizeToFit];
    [bhv addSubview:label];
    label.center = bhv.center;
    return bhv;
}

- (UIView *)buildSwitchView {
    if ([self.switchButtonTitle isEqualToString:@""]){
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    UIView *bsv = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height + 1, self.tableView.frame.size.width, DY_SWITCH_HEIGHT)];
    bsv.backgroundColor = [UIColor whiteColor];
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectZero];
    sw.frame = CGRectMake(self.tableView.frame.size.width - sw.frame.size.width - 2, (bsv.frame.size.height - sw.frame.size.height)/2, sw.frame.size.width, sw.frame.size.height);
    [sw addTarget:self action:@selector(switchButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, bsv.frame.size.width - sw.frame.size.width - 15, bsv.frame.size.height)];
    if([self.delegate respondsToSelector:@selector(DYAlertPickerViewStateOfSwitchButton)]){
        sw.on = [self.delegate DYAlertPickerViewStateOfSwitchButton];
    }
    label.text = self.switchButtonTitle;
    label.textColor = [UIColor darkGrayColor];
    [label setNeedsDisplay];
    [bsv addSubview:label];
    [bsv addSubview:sw];
    return bsv;
}

#pragma mark - show/dismiss DYAlertPickerView

- (void)show {
    [self showAndSelectedIndex:-1];
}

- (void)showAndSelectedIndex:(NSInteger)index {
    
    [self setupSubViews];
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    self.frame = mainWindow.frame;
    [mainWindow addSubview:self];
    
    self.containerView.layer.opacity = 1.0f;
    self.layer.opacity = 0.5f;
    self.layer.transform = CATransform3DMakeScale(1.5f, 1.5f, 1.0f);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.layer.opacity = 1.0f;
                         self.backgroundMaskView.layer.opacity = 0.5f;
                         self.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:^(BOOL finished) {
                         NSInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
                         if ((index >=0) && (index <= numberOfRows)) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 self.selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
                                 [self.tableView reloadData];
                             });
                             
                         }
                         
                     }
     
     ];
}

- (void)dismiss:(DYAlertPickerViewDismissCallback)completion {
    callback = completion;
    
    if(callback){
        callback();
    }
    float delayTime;
    if (self.tapPickerViewItemToConfirm) {
        delayTime = 0.5;
    }else {
        delayTime = 0;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                             self.layer.opacity = 0.1f;
                             self.layer.transform = CATransform3DMakeScale(3.0f, 3.0f, 1.0f);
                         }
                         completion:^(BOOL finished) {
                             for (UIView *v in [self subviews]) {
                                 [v removeFromSuperview];
                             }
                             self.layer.transform = CATransform3DMakeScale(1, 1, 1);
                             [self removeFromSuperview];
                             [self setNeedsDisplay];
                         }
         ];
    });
    // Request to stop receiving accelerometer events and turn off accelerometer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

}

- (void)orientationChanged:(NSNotification *)notification {
    // Respond to changes in device orientation
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;

    if (isUIDeviceOrientation == NO
        && (UIDeviceOrientationIsPortrait(orientation)
        || UIDeviceOrientationIsLandscape(orientation))) {
        
    } else {
        return;
    }
    
    isUIDeviceOrientation = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIView *v in [self subviews]) {
            [v removeFromSuperview];
        }
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
        [self removeFromSuperview];
        [self setNeedsDisplay];
        // Request to stop receiving accelerometer events and turn off accelerometer
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        [self show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isUIDeviceOrientation = NO;
        });
        
    });

}

#pragma mark - cancel/confirm button delegate

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismiss:^{
        if([self.delegate respondsToSelector:@selector(DYAlertPickerViewDidClickCancelButton:)]){
            [self.delegate DYAlertPickerViewDidClickCancelButton:self];
        }
    }];
}

- (IBAction)confirmButtonPressed:(UIButton *)sender {
    [self dismiss:^{
        if(self.selectedIndexPath && [self.delegate respondsToSelector:@selector(DYAlertPickView:didConfirmWithItemAtRow:)]){
            [self.delegate DYAlertPickView:self didConfirmWithItemAtRow:self.selectedIndexPath.row];
        }
    }];
}

- (IBAction)switchButtonValueChanged:(UISwitch *)sender {
    if([self.delegate respondsToSelector:@selector(DYAlertPickerViewDidClickSwitchButton:)]){
        [self.delegate DYAlertPickerViewDidClickSwitchButton:sender];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInDYAlertPickerView:)]) {
        return [self.dataSource numberOfRowsInDYAlertPickerView:self];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"picker_view_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    }
    if(self.selectedIndexPath && [self.selectedIndexPath isEqual:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([self.dataSource respondsToSelector:@selector(DYAlertPickView:titleForRow:)]) {
        cell.textLabel.attributedText = [self.dataSource DYAlertPickView:self titleForRow:indexPath.row];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(self.selectedIndexPath){
        UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        if(prevCell){
            prevCell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    self.selectedIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.tapPickerViewItemToConfirm && [self.delegate respondsToSelector:@selector(DYAlertPickView:didConfirmWithItemAtRow:)]){
        [self dismiss:^{
            [self.delegate DYAlertPickView:self didConfirmWithItemAtRow:indexPath.row];
        }];
    }
}
@end
