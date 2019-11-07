//
//  LGAudioPlayer.h
//  下载地址：https://github.com/gang544043963/LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LGAudioPlayerState){
	LGAudioPlayerStateNormal = 0,/** 未播放状态 */
	LGAudioPlayerStatePlaying = 2,/** 正在播放 */
	LGAudioPlayerStateCancel = 3,/** 播放被取消 */
};

@protocol LGAudioPlayerDelegate <NSObject>

- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index;

@end

@interface LGAudioPlayer : NSObject

@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, weak) id<LGAudioPlayerDelegate>delegate;

+ (instancetype)sharePlayer;
/// 可播放mp3、caf、wav、amr格式的音频
- (void)playAudioWithURLString:(NSString *)URLString atIndex:(NSUInteger)index;

- (void)stopAudioPlayer;
/// 播放在线音频
- (void)playAudioOnlineWithContentsOfURL:(NSURL *)url;

@end
