//
//  Minkasu2FAWebView.h
//  SampleMinkasuApp
//
//  Created by Habibur on 17/03/20.
//  Copyright © 2020 Minkasu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RNCWebView.h>


NS_ASSUME_NONNULL_BEGIN

@interface Minkasu2FAWebView : RNCWebView
@property (nonatomic, copy) NSDictionary *minkasu2FAConfig;
@property (nonatomic, strong) RCTDirectEventBlock onMinkasu2FAInit;
@end

NS_ASSUME_NONNULL_END
