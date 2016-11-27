//
//  ViewController.m
//  下载地址：https://github.com/gang544043963/LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import "ViewController.h"
#import "LGTableViewCell.h"
#import "LGMessageModel.h"
#import "LGAudioKit.h"
#import "Masonry.h"

#define SOUND_RECORD_LIMIT 60
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,LGTableViewCellDelegate,LGSoundRecorderDelegate,LGAudioPlayerDelegate>


@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) UIButton    *recordButton;
@property (nonatomic, weak) NSTimer *timerOf60Second;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
	[super viewDidLoad];
	_dataArray  = [NSMutableArray arrayWithCapacity:0];
	[LGAudioPlayer sharePlayer].delegate = self;
	self.view.backgroundColor = [UIColor brownColor];
	[self initTableView];
	[self initButton];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
	[_chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view.mas_top).with.offset(20);
		make.left.equalTo(self.view.mas_left).with.offset(10);
		make.right.equalTo(self.view.mas_right).with.offset(-10);
		make.bottom.equalTo(self.view.mas_bottom).with.offset(-70);
	}];
	[super updateViewConstraints];
}

#pragma mark - Initialize

- (void)initTableView {
	_chatTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
	_chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_chatTableView.delegate = self;
	_chatTableView.dataSource = self;
	_chatTableView.backgroundColor = [UIColor whiteColor];
	_chatTableView.layer.cornerRadius = 5;
	_chatTableView.layer.masksToBounds = YES;
	_chatTableView.tableHeaderView = nil;
	[self.view addSubview:_chatTableView];
}

- (void)initButton {
	_recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_recordButton setBackgroundImage:[[UIImage imageNamed:@"btn_chatbar_press_normal" ] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
	[_recordButton setBackgroundImage:[[UIImage imageNamed:@"btn_chatbar_press_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
	_recordButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[_recordButton setTitle:@"按住录音" forState:UIControlStateNormal];
	[_recordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[_recordButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
	[_recordButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
	[_recordButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
	[_recordButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
	[_recordButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
	
	[_recordButton setFrame:CGRectMake(10, self.view.frame.size.height - 60, self.view.frame.size.width - 20, 50)];
	[self.view addSubview:_recordButton];
}

#pragma mark - Private Methods

/**
 *  开始录音
 */
- (void)startRecordVoice{
	__block BOOL isAllow = 0;
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
		[audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
			if (granted) {
				isAllow = 1;
			} else {
				isAllow = 0;
			}
		}];
	}
	if (isAllow) {
//		//停止播放
		[[LGAudioPlayer sharePlayer] stopAudioPlayer];
//		//开始录音
		[[LGSoundRecorder shareInstance] startSoundRecord:self.view recordPath:[self recordPath]];
		//开启定时器
		if (_timerOf60Second) {
			[_timerOf60Second invalidate];
			_timerOf60Second = nil;
		}
		_timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopAndSendVedio) userInfo:nil repeats:YES];
	} else {
		
	}
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice {
	if ([[LGSoundRecorder shareInstance] soundRecordTime] == 0) {
		return;//60s自动发送后，松开手走这里
	}
	if ([[LGSoundRecorder shareInstance] soundRecordTime] < 1.0f) {
		if (_timerOf60Second) {
			[_timerOf60Second invalidate];
			_timerOf60Second = nil;
		}
		[self showShotTimeSign];
		return;
	}
	
	[self sendSound];
	[[LGSoundRecorder shareInstance] stopSoundRecord:self.view];
	
	if (_timerOf60Second) {
		[_timerOf60Second invalidate];
		_timerOf60Second = nil;
	}
}

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)updateCancelRecordVoice {
	[[LGSoundRecorder shareInstance] readyCancelSound];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice {
	[[LGSoundRecorder shareInstance] resetNormalRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice {
	[[LGSoundRecorder shareInstance] soundRecordFailed:self.view];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
	[[LGSoundRecorder shareInstance] showShotTimeSign:self.view];
}

- (void)sixtyTimeStopAndSendVedio {
	int countDown = SOUND_RECORD_LIMIT - [[LGSoundRecorder shareInstance] soundRecordTime];
	NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[LGSoundRecorder shareInstance] soundRecordTime]);
	if (countDown <= 10) {
		[[LGSoundRecorder shareInstance] showCountdown:countDown];
	}
	if ([[LGSoundRecorder shareInstance] soundRecordTime] >= SOUND_RECORD_LIMIT && [[LGSoundRecorder shareInstance] soundRecordTime] <= SOUND_RECORD_LIMIT + 1) {
		
		if (_timerOf60Second) {
			[_timerOf60Second invalidate];
			_timerOf60Second = nil;
		}
		[self.recordButton sendActionsForControlEvents:UIControlEventTouchUpInside];
	}
}

/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)recordPath {
	NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		NSError *error = nil;
		[[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
		if (error) {
			NSLog(@"%@", error);
		}
	}
	return filePath;
}

- (void)sendSound {
	LGMessageModel *messageModel = [[LGMessageModel alloc] init];
	messageModel.soundFilePath = [[LGSoundRecorder shareInstance] soundFilePath];
	messageModel.seconds = [[LGSoundRecorder shareInstance] soundRecordTime];
	[self.dataArray addObject:messageModel];
	[self.chatTableView reloadData];
}

#pragma mark - LGSoundRecorderDelegate 

- (void)showSoundRecordFailed{
//	[[SoundRecorder shareInstance] soundRecordFailed:self];
	if (_timerOf60Second) {
		[_timerOf60Second invalidate];
		_timerOf60Second = nil;
	}
}

- (void)didStopSoundRecord {

}

#pragma mark - LGAudioPlayerDelegate

- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	LGTableViewCell *voiceMessageCell = [_chatTableView cellForRowAtIndexPath:indexPath];
	LGVoicePlayState voicePlayState;
	switch (audioPlayerState) {
        case LGAudioPlayerStateNormal:
			voicePlayState = LGVoicePlayStateNormal;
		break;
		case LGAudioPlayerStatePlaying:
			voicePlayState = LGVoicePlayStatePlaying;
			break;
		case LGAudioPlayerStateCancel:
			voicePlayState = LGVoicePlayStateCancel;
			break;
			
		default:
			break;
	}
	dispatch_async(dispatch_get_main_queue(), ^{
		[voiceMessageCell setVoicePlayState:voicePlayState];
	});
}

#pragma mark - LGTableViewCellDelegate

- (void)voiceMessageTaped:(LGTableViewCell *)cell {
	[cell setVoicePlayState:LGVoicePlayStatePlaying];
	
	NSIndexPath *indexPath = [_chatTableView indexPathForCell:cell];
	LGMessageModel *messageModel = [self.dataArray objectAtIndex:indexPath.row];
	[[LGAudioPlayer sharePlayer] playAudioWithURLString:messageModel.soundFilePath atIndex:indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	LGTableViewCell *cell = [[LGTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	cell.delegate = self;
	LGMessageModel *messageModel = [self.dataArray objectAtIndex:indexPath.row];
	[cell configureCellWithData:messageModel];
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 60)];
	textView.backgroundColor = [UIColor redColor];
	textView.text = @"欢迎使用本框架\n\n如果在使用过程中遇到问题请及时提issue\n博客:http://blog.csdn.net/gang544043963";
	textView.textAlignment = NSTextAlignmentCenter;
	textView.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14];
	return textView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 100;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	return @"adfasdf";
//}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 66;
}
	
@end
