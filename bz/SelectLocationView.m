//
//  SelectLocationView.m
//  bz
//
//  Created by qianchuang on 2017/1/13.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "SelectLocationView.h"
#import "DataBaseService.h"

@interface SelectLocationView () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<Address *> *addressArray;
@end

@implementation SelectLocationView

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (IBAction)closeAction:(UIButton *)sender
{
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"selectlocationcell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _addressArray = [[DataBaseService sharedService] getAllCity];
    [_tableView reloadData];
}

- (void)initView
{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.618];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        UserLocationModel *model = [Utility getUserLocationInformation];
        return model?1:0;
    }
    return _addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectlocationcell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        UserLocationModel *model = [Utility getUserLocationInformation];
        cell.textLabel.text = model.city;
    } else {
        Address *address =_addressArray[indexPath.row];
        cell.textLabel.text = address.areaName;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectlocationcell"];
    cell.backgroundColor = [UIColor lightGrayColor];
    if (section == 0) {
        cell.textLabel.text = Localized(@"我们猜您在");
    } else {
        cell.textLabel.text = Localized(@"请选择");
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
