//
//  LGCellContentView.m
//  下载地址：https://github.com/gang544043963/LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import "LGCellContentView.h"

@implementation LGCellContentView

- (instancetype)init {
	if ([super init]) {
		CAShapeLayer *maskLayer = [CAShapeLayer layer];
		maskLayer.contentsCenter = CGRectMake(.5f, .7f, .1f, .1f);
		//2X图，contentsScale设为2
		maskLayer.contentsScale = 2;
		self.layer.mask = maskLayer;
	}
	return self;
}
- (void)layoutSublayersOfLayer:(CALayer *)layer {
	[super layoutSublayersOfLayer:layer];
	self.layer.mask.frame = CGRectInset(self.bounds, 0, 0);
}

@end
