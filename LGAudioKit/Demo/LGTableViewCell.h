//
//  LGTableViewCell.h
//  下载地址：https://github.com/gang544043963/LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMessageModel.h"

typedef NS_ENUM(NSUInteger, LGVoicePlayState){
	LGVoicePlayStateNormal,/**< 未播放状态 */
	LGVoicePlayStateDownloading,/**< 正在下载中 */
	LGVoicePlayStatePlaying,/**< 正在播放 */
	LGVoicePlayStateCancel,/**< 播放被取消 */
};

@class LGTableViewCell;
@protocol LGTableViewCellDelegate <NSObject>

- (void)voiceMessageTaped:(LGTableViewCell *)cell;

@end

@interface LGTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger soundSeconds;
@property (nonatomic, assign) LGVoicePlayState voicePlayState;
@property (nonatomic, weak) id<LGTableViewCellDelegate>delegate;

- (void)configureCellWithData:(LGMessageModel *)messageModel;

@end
