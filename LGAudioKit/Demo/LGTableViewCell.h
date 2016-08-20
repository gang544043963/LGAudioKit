//
//  LGTableViewCell.h
//  LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LGVoicePalyState){
	LGVoicePalyStateNormal,/**< 未播放状态 */
	LGVoicePalyStateDownloading,/**< 正在下载中 */
	LGVoicePalyStatePlaying,/**< 正在播放 */
	LGVoicePalyStateCancel,/**< 播放被取消 */
};

@class LGTableViewCell;
@protocol LGTableViewCellDelegate <NSObject>

- (void)voiceMessageTaped:(LGTableViewCell *)cell;

@end

@interface LGTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger soundSeconds;
@property (nonatomic, assign) LGVoicePalyState voicePlayState;
@property (nonatomic, weak) id<LGTableViewCellDelegate>delegate;

- (void)configureCellWithData:(NSInteger)seconds;

@end
