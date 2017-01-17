//
//  QGDropDownMenu.m
//  bz
//
//  Created by qianchuang on 2017/1/16.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "QGDropDownMenu.h"

@interface QGTableViewCell : UITableViewCell

@property(nonatomic,readonly) UILabel *cellTextLabel;
@property(nonatomic,strong) UIImageView *cellAccessoryView;

-(void)setCellText:(NSString *)text align:(NSString*)align;

@end

@implementation QGTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, screenSize.width-60, 30)];
        CGPoint center = _cellTextLabel.center;
        center.y = self.bounds.size.height/2;
        _cellTextLabel.center = center;
        _cellTextLabel.textAlignment = NSTextAlignmentLeft;
        _cellTextLabel.font = [UIFont systemFontOfSize:14.0f];
        _cellTextLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_cellTextLabel];
        
        _cellAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(_cellTextLabel.frame.origin.x+_cellTextLabel.frame.size.width, (self.frame.size.height-12)/2, 16, 12)];
        _cellAccessoryView.image = [UIImage imageNamed:@"ico_make"];
        [self addSubview:_cellAccessoryView];
        _cellAccessoryView.hidden = YES;
    }
    return self;
}

-(void)setCellText:(NSString *)text align:(NSString*)align{
    
    _cellTextLabel.text = text;
    
//    if (![@"left" isEqualToString:align]) {
//        marginX = (self.frame.size.width-textSize.width)/2;
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    _cellAccessoryView.hidden = !selected;
}

@end

@interface QGDropDownMenu () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) BOOL hadSelected;
@property (nonatomic, strong) UITableView *leftTableView;

@end

@implementation QGDropDownMenu

- (void)dealloc
{
    NSLog(@"QGDropDownMenu dealloc");
}

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andWidth:(CGFloat)width {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, width, screenSize.height)];
    if (self) {
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;
        
        _hadSelected = NO;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.618];
        //tableView init
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, screenSize.height) style:UITableViewStyleGrouped];
        _leftTableView.rowHeight = 38;
        _leftTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        
        _leftTableView.sectionFooterHeight = 0;
        _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, CGFLOAT_MIN)];
        _leftTableView.sectionHeaderHeight = 0;
        _leftTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, CGFLOAT_MIN)];
        
        [self addSubview:_leftTableView];
        
    }
    return self;
}

- (void)reloadData
{
//    [_leftTableView reloadData];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect frame = _leftTableView.frame;
    //如果size过大，按小的算
    frame.size.height = _leftTableView.contentSize.height>screenSize.height-64-self.frame.origin.y-80?screenSize.height-64-self.frame.origin.y-80:_leftTableView.contentSize.height;
//    frame.size.height = _leftTableView.contentSize.height;
    _leftTableView.frame = frame;
    
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[_dateSource selectRowDropDownMenu:self] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self remove];
}

- (void)remove
{
    WS(weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.leftTableView.frame = CGRectMake(0, 0, weakSelf.leftTableView.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.delegate didRemoveForSuperViewDropDownMenu:weakSelf];
    }];
}

#pragma mark - UITableViewDeledate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dateSource numberOfRowsDropDownMenu:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";
    QGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QGTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    [cell setCellText:[_dateSource dropDownMenu:self titleForRow:indexPath.row] align:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(dropDownMenu:didSelectedRow:)]) {
        [_delegate dropDownMenu:self didSelectedRow:indexPath.row];
    }
    
    [self remove];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
