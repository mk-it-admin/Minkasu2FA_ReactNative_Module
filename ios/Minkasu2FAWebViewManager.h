//
//  Minkasu2FAWebViewManager.h
//  SampleMinkasuApp
//
//  Created by Habibur on 17/03/20.
//  Copyright © 2020 Minkasu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RNCWebViewManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface Minkasu2FAWebViewManager : RNCWebViewManager

@property (nonatomic,assign)BOOL isSkipInit;

@end

NS_ASSUME_NONNULL_END
