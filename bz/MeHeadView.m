//
//  MeHeadView.m
//  bz
//
//  Created by qianchuang on 2016/12/27.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "MeHeadView.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+Addition.h"
//头像宽高
#define kHeadIconWidth 80.f
//自身总高度
#define kSelfHeight 300.f
//上部分头像和按钮加背景的高度
#define kTopViewHeight 200.f

@interface MeHeadView()

@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UIButton *loginButton;

@end

@implementation MeHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, kScreenWidth, kSelfHeight);
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
    backView.backgroundColor = kPinkColor;
    [self addSubview:backView];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kHeadIconWidth, kHeadIconWidth)];
    _faceImageView.center = CGPointMake(self.frame.size.width/2.0, backView.frame.size.height/2.0 - 20);
    _faceImageView.image = [UIImage imageNamed:@"member-head"];
    _faceImageView.backgroundColor = [UIColor clearColor];
    [_faceImageView setCorneRadius:kHeadIconWidth/2];
    [backView addSubview:_faceImageView];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(backView.frame.size.width/2.0 - 60, CGRectGetMaxY(_faceImageView.frame), 120, 40);
    [_loginButton setTitle:Localized(@"登录/注册") forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor clearColor]];
    [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_loginButton];
    
    NSArray *nameArray = @[@"我的订单", @"代付订单", @"常购清单"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width/3.0*i, CGRectGetMaxY(backView.frame) + 10, self.frame.size.width/3.0, kSelfHeight-kTopViewHeight-20);
        btn.tag = i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:btn];
        //按钮上面的文案
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(btn.frame)/2.0-21, CGRectGetWidth(btn.frame), 21)];
        numberLabel.textColor = [UIColor darkGrayColor];
        numberLabel.text = @"0";
        numberLabel.tag = 100 + i;
        numberLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:numberLabel];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(btn.frame)/2.0, CGRectGetWidth(btn.frame), 21)];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.text = nameArray[i];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:nameLabel];
        //分割线
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame)-0.3, CGRectGetMinY(btn.frame), 0.3, CGRectGetHeight(btn.frame))];
        label.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:label];
    }
}

- (void)login:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(loginButtonAction)]) {
        [_delegate loginButtonAction];
    }
}

- (void)btnAction:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(orderButtonAction:)]) {
        [_delegate orderButtonAction:btn.tag];
    }
}

- (void)setUserModel:(UserModel *)userModel
{
    [_faceImageView setImageWithURL:[NSURL URLWithString:userModel.faceUrl] placeholderImage:[UIImage imageNamed:@"member-head"]];
    [_loginButton setTitle:userModel.loginName forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
