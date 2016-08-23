//
//  LGTableViewCell.m
//  下载地址：https://github.com/gang544043963/LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import "LGTableViewCell.h"
#import "LGCellContentView.h"
#import "Masonry.h"

@interface LGTableViewCell()


@property (nonatomic, strong) UIImageView       *headImageView;

@property (nonatomic, strong) LGCellContentView *msgContentView;

@property (nonatomic, strong) UIImageView       *msgBackGoundImageView;

@property (nonatomic, strong) UIImageView       *messageVoiceStatusImageView;

@property (nonatomic, strong) UILabel           *messageVoiceSecondsLabel;


@end

@implementation LGTableViewCell

#pragma mark - Override Methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self setup];
	}
	return self;
}

- (void)updateConstraints {
	[self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.contentView.mas_right).with.offset(-13);
		make.top.equalTo(self.contentView.mas_top).with.offset(13);
		make.width.equalTo(@40);
		make.height.equalTo(@40);
	}];
	
	[self.msgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.headImageView.mas_left).with.offset(-8);
		make.top.equalTo(self.headImageView.mas_top);
		make.width.lessThanOrEqualTo(@([UIApplication sharedApplication].keyWindow.frame.size.width/5*3)).priorityHigh();
		make.bottom.equalTo(self.headImageView.mas_bottom);
	}];
	
	[self.messageVoiceStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.msgContentView.mas_right).with.offset(-20);
		make.centerY.equalTo(self.msgContentView.mas_centerY);
		make.top.equalTo(self.msgContentView.mas_top).with.offset(11);
		make.bottom.equalTo(self.msgContentView.mas_bottom).with.offset(-11);
	}];
	
	[self.messageVoiceSecondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.msgContentView.mas_left).with.offset(-8);
		make.centerY.equalTo(self.msgContentView.mas_centerY);
	}];
	
	[self.msgBackGoundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.msgContentView);
	}];
	
	[self.msgContentView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@(50 + self.soundSeconds * 2.5));//根据时长变化
	}];
	
	[super updateConstraints];
}

#pragma mark - Public Methods

- (void)configureCellWithData:(LGMessageModel *)messageModel {
	self.soundSeconds = messageModel.seconds;
	self.messageVoiceSecondsLabel.text = [NSString stringWithFormat:@"%ld''",(long)self.soundSeconds];
	[self setNeedsUpdateConstraints];
}

#pragma mark - Private Methods

- (void)setup {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.backgroundColor = [UIColor clearColor];
	
	[self.contentView addSubview:self.headImageView];
	[self.contentView addSubview:self.msgContentView];
	[self.contentView addSubview:self.messageVoiceSecondsLabel];
	[self.contentView addSubview:self.messageVoiceStatusImageView];
	[self.msgBackGoundImageView setImage:[[UIImage imageNamed:@"bg_chat_me"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 8, 20) resizingMode:UIImageResizingModeStretch]];
	[self.msgBackGoundImageView setHighlightedImage:[[UIImage imageNamed:@"bg_chat_me"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 8, 20) resizingMode:UIImageResizingModeStretch]];
	self.msgContentView.layer.mask.contents = (__bridge id _Nullable)(self.msgBackGoundImageView.image.CGImage);
	[self.contentView insertSubview:self.msgBackGoundImageView belowSubview:self.msgContentView];
	[self updateConstraintsIfNeeded];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[self.contentView addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
	if (_delegate && [_delegate respondsToSelector:@selector(voiceMessageTaped:)]) {
		[_delegate voiceMessageTaped:self];
	}
}

#pragma mark - Setters 

- (void)setVoicePlayState:(LGVoicePlayState)voicePlayState {
	if (_voicePlayState != voicePlayState) {
		_voicePlayState = voicePlayState;
	}
	self.messageVoiceSecondsLabel.hidden = NO;
	self.messageVoiceStatusImageView.hidden = NO;
	
	if (_voicePlayState == LGVoicePlayStatePlaying) {
		self.messageVoiceStatusImageView.highlighted = YES;
		[self.messageVoiceStatusImageView startAnimating];
	}else if (_voicePlayState == LGVoicePlayStateDownloading) {
		self.messageVoiceSecondsLabel.hidden = YES;
		self.messageVoiceStatusImageView.hidden = YES;
	}else {
		self.messageVoiceStatusImageView.highlighted = NO;
		[self.messageVoiceStatusImageView stopAnimating];
	}
}

#pragma mark - Getters

- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
		_headImageView.layer.cornerRadius = 5.0f;
		_headImageView.layer.masksToBounds = YES;
		_headImageView.backgroundColor = [UIColor lightGrayColor];
		_headImageView.image = [UIImage imageNamed:@"headImage"];
	}
	return _headImageView;
}

- (LGCellContentView *)msgContentView {
	if (!_msgContentView) {
		_msgContentView = [[LGCellContentView alloc] init];
	}
	return _msgContentView;
}

- (UIImageView *)msgBackGoundImageView {
	if (!_msgBackGoundImageView) {
		_msgBackGoundImageView = [[UIImageView alloc] init];
	}
	return _msgBackGoundImageView;
}

- (UIImageView *)messageVoiceStatusImageView {
	if (!_messageVoiceStatusImageView) {
		_messageVoiceStatusImageView = [[UIImageView alloc] init];
		_messageVoiceStatusImageView.image = [UIImage imageNamed:@"icon_voice_sender_3"] ;
		UIImage *image1 = [UIImage imageNamed:@"icon_voice_sender_1"];
		UIImage *image2 = [UIImage imageNamed:@"icon_voice_sender_2"];
		UIImage *image3 = [UIImage imageNamed:@"icon_voice_sender_3"];
		_messageVoiceStatusImageView.highlightedAnimationImages = @[image1,image2,image3];
		_messageVoiceStatusImageView.animationDuration = 1.5f;
		_messageVoiceStatusImageView.animationRepeatCount = NSUIntegerMax;
	}
	return _messageVoiceStatusImageView;
}

- (UILabel *)messageVoiceSecondsLabel {
	if (!_messageVoiceSecondsLabel) {
		_messageVoiceSecondsLabel = [[UILabel alloc] init];
		_messageVoiceSecondsLabel.font = [UIFont systemFontOfSize:14.0f];
		_messageVoiceSecondsLabel.text = @"0''";
	}
	return _messageVoiceSecondsLabel;
}

@end
