# LGAudioKit

[![Travis](https://img.shields.io/travis/rust-lang/rust.svg)]()   [![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/GIKICoder/GDataBase/master/LICENSE)&nbsp;

[swift版传送门](https://github.com/gang544043963/LGAudioKit_swift)

简单易用的语音录制、播放控件。流程和界面参考微信（如果对您有帮助，记得star，动力源自鼓励）

<img src="https://github.com/gang544043963/MyDataSource/blob/master/C81B65C4-5EB1-4FE9-AF3E-E234132300C6.jpeg?raw=true" alt="CXLSlideList Screenshot" width="200" height="360"/>  <img src="https://github.com/gang544043963/MyDataSource/blob/master/37E9A97C-6EE5-4542-94F5-5B40326177E9.jpeg?raw=true" alt="CXLSlideList Screenshot" width="200" height="360"/>

## 添加到工程
- 拷贝'Class'文件夹到你的工程
- #import "LGAudioKit.h"

## 播放器 LGAudioPlayer

- 开始播放
```OC
- (void)playAudioWithURLString:(NSString *)URLString atIndex:(NSUInteger)index;
```
URLString: 语音文件本地路径。如果要播放网络文件，先下载到本地，再播放

- 停止播放
```OC
- (void)stopAudioPlayer
```

- 代理方法
```OC
- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index
```

- 播放状态 LGAudioPlayerState
```OC
typedef NS_ENUM(NSUInteger, LGAudioPlayerState){
	LGAudioPlayerStateNormal = 0,/**< 未播放状态 */
	LGAudioPlayerStatePlaying = 2,/**< 正在播放 */
	LGAudioPlayerStateCancel = 3,/**< 播放被取消 */
};
```

## 录音器

- 开始录音
```OC
- (void)startSoundRecord:(UIView *)view recordPath:(NSString *)path;
```
view: 传入录音动画的父view（录音动画要展示的依托view）；
path: 语音文件存储路径

- 结束录音
```OC
- (void)stopSoundRecord:(UIView *)view;
```

- 录音失败/取消录音
```OC
- (void)soundRecordFailed:(UIView *)view;
```

- 提示‘松开手指，取消录音’。这个状态下，录音继续。
```OC
- (void)readyCancelSound;
```

- 恢复正常提示动画。（手指重新滑动到按钮范围内,提示‘手指上滑，取消发送’）
```OC
- (void)resetNormalRecord;
```

- 提示‘说话时间太短’
```OC
- (void)showShotTimeSign:(UIView *)view
```

- 展示录音倒计时
```OC
- (void)showCountdown:(int)countDown;
```
countDown: 剩余时间，秒。

- 文件格式转换，caf文件转换为amr
```OC
- (NSData *)convertCAFtoAMR:(NSString *)fielPath;
```

- 获取录音时长
```OC
- (NSTimeInterval)soundRecordTime;
```

## 说明
- Demo中包含两个控件：

    录音控件：'LGSoundRecorder'

    播放控件：'LGSoundPlayer'
    
- 录音文件格式为.caf，提供转amr方法，可转成amr发给安卓

- 播放语音格式支持：amr、caf、wav
    
- 具体的使用细节请参考Demo中的ViewController.m

-  语音录放的一些简单分析请参考 [iOS通信软件中的语音录制与播放 ](http://blog.csdn.net/gang544043963/article/details/52266903)

## 环境支持
- iOS7及以上



_______________________________________________________
