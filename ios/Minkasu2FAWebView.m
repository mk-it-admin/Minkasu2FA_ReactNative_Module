//
//  Minkasu2FAWebView.m
//  SampleMinkasuApp
//
//  Created by Habibur on 17/03/20.
//  Copyright © 2020 Minkasu. All rights reserved.
//

#import "Minkasu2FAWebView.h"

@implementation Minkasu2FAWebView

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"minkasuPayByAttribute" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"minkasuPayByMethod" object:nil userInfo:nil];
}
@end
