//
//  LGSoundRecorder.h
//  LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol LGSoundRecorderDelegate <NSObject>

- (void)showSoundRecordFailed;
- (void)didStopSoundRecordView;

@end

@interface LGSoundRecorder : NSObject

@property (nonatomic, weak) id<LGSoundRecorderDelegate>delegate;

+ (LGSoundRecorder *)shareInstance;
/**
 *  开始录音
 */
- (void)startSoundRecord:(UIView *)view recordPath:(NSString *)path;
/**
 *  录音结束
 */
- (void)stopSoundRecord:(UIView *)view;
/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)soundRecordFailed:(UIView *)view;
/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)readyCancelSound;
/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)resetNormalRecord;
/**
 *  录音时间过短
 */
- (void)showShotTimeSign:(UIView *)view ;
/**
 *  最后10秒，显示你还可以说X秒
 *
 *  @param countDown X秒
 */
- (void)showCountdown:(int)countDown;

- (CGFloat)soundRecordTime;
@end
