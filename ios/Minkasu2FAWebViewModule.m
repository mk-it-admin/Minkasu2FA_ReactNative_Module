//
//  Minkasu2FAWebViewModule.m
//  SampleMinkasuApp
//
//  Created by Habibur on 28/04/20.
//  Copyright © 2020 Minkasu. All rights reserved.
//

#import "Minkasu2FAWebViewModule.h"
#import <Minkasu2FA/Minkasu2FA.h>
#import "Minkasu2FAConstants.h"

@implementation Minkasu2FAWebViewModule

RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport{
  
  NSDictionary *export = @{@"CHANGE_PIN":CHANGE_PIN,
                           @"ENABLE_BIOMETRIC":ENABLE_BIOMETRIC,
                           @"DISABLE_BIOMETRIC":DISABLE_BIOMETRIC
  };
  return export;
}

RCT_REMAP_METHOD(getMinkasu2FAOperationTypes,
                 resolver: (RCTPromiseResolveBlock)resolve
                 rejecter: (RCTPromiseRejectBlock)reject)
{
  NSMutableArray *minkasu2FAOperations = [Minkasu2FA getAvailableMinkasu2FAOperations];
  NSMutableDictionary *operations = [[NSMutableDictionary alloc] init];
  if([minkasu2FAOperations count] > 0){
    for (NSNumber *operation in minkasu2FAOperations){
      if(operation.intValue == MINKASU2FA_CHANGE_PAYPIN) {
        [operations setObject:@"CHANGE PIN" forKey:CHANGE_PIN];
      }else if(operation.intValue == MINKASU2FA_ENABLE_BIOMETRY) {
        [operations setObject:@"ENABLE BIOMETRIC" forKey:ENABLE_BIOMETRIC];
      } else if(operation.intValue == MINKASU2FA_DISABLE_BIOMETRY) {
        [operations setObject:@"DISABLE BIOMETRIC" forKey:DISABLE_BIOMETRIC];
      }
    }
  }
  resolve(operations);
}

RCT_REMAP_METHOD(performMinkasu2FAOperation,
                 merchantCustomerId:(NSString *)merchantCustomerId
                 operationTypeStr:(NSString *)operationTypeStr
                 colourTheme:(NSDictionary*)colourTheme
                 resolver: (RCTPromiseResolveBlock)resolve
                 rejecter: (RCTPromiseRejectBlock)reject){
  NSMutableArray *minkasu2FAOperations = [Minkasu2FA getAvailableMinkasu2FAOperations];
  if([minkasu2FAOperations count] > 0){
    Minkasu2FACustomTheme *mkcolorTheme = [Minkasu2FACustomTheme new];
    if (colourTheme && colourTheme != nil) {
      if (colourTheme[NAVIGATION_BAR_COLOR]) {
        mkcolorTheme.navigationBarColor = [self colorFromHexString:colourTheme[NAVIGATION_BAR_COLOR]];
      }
      if (colourTheme[NAVIGATION_BAR_TEXT_COLOR]) {
        mkcolorTheme.navigationBarTextColor = [self colorFromHexString:colourTheme[NAVIGATION_BAR_TEXT_COLOR]];
      }
      if (colourTheme[BUTTON_BACKGROUND_COLOR]) {
        mkcolorTheme.buttonBackgroundColor = [self colorFromHexString:colourTheme[BUTTON_BACKGROUND_COLOR]];
      }
      if (colourTheme[BUTTON_TEXT_COLOR]) {
        mkcolorTheme.buttonTextColor = [self colorFromHexString:colourTheme[BUTTON_TEXT_COLOR]];
      }
      if (colourTheme[DARK_MODE_NAVIGATION_BAR_COLOR]) {
        mkcolorTheme.darkModeNavigationBarColor = [self colorFromHexString:colourTheme[DARK_MODE_NAVIGATION_BAR_COLOR]];
      }
      if (colourTheme[DARK_MODE_NAVIGATION_BAR_TEXT_COLOR]) {
        mkcolorTheme.darkModeNavigationBarTextColor = [self colorFromHexString:colourTheme[DARK_MODE_NAVIGATION_BAR_TEXT_COLOR]];
      }
      if (colourTheme[DARK_MODE_BUTTON_BACKGROUND_COLOR]) {
        mkcolorTheme.darkModeButtonBackgroundColor = [self colorFromHexString:colourTheme[DARK_MODE_BUTTON_BACKGROUND_COLOR]];
      }
      if (colourTheme[DARK_MODE_BUTTON_TEXT_COLOR]) {
        mkcolorTheme.darkModeButtonTextColor = [self colorFromHexString:colourTheme[DARK_MODE_BUTTON_TEXT_COLOR]];
      }
      if (colourTheme[SUPPORT_DARK_MODE]) {
        mkcolorTheme.supportDarkMode = colourTheme[SUPPORT_DARK_MODE];
      }
    }
    if ([operationTypeStr isEqualToString:@"CHANGE PIN"]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [Minkasu2FA performMinkasu2FAOperation:MINKASU2FA_CHANGE_PAYPIN merchantCustomerId:merchantCustomerId customTheme:mkcolorTheme];
      });
    }else if([operationTypeStr isEqualToString:@"ENABLE BIOMETRIC"]){
      dispatch_async(dispatch_get_main_queue(), ^{
        [Minkasu2FA performMinkasu2FAOperation:MINKASU2FA_ENABLE_BIOMETRY merchantCustomerId:merchantCustomerId customTheme:mkcolorTheme];
      });
    }else if ([operationTypeStr isEqualToString:@"DISABLE BIOMETRIC"]){
      dispatch_async(dispatch_get_main_queue(), ^{
        [Minkasu2FA performMinkasu2FAOperation:MINKASU2FA_DISABLE_BIOMETRY merchantCustomerId:merchantCustomerId customTheme:mkcolorTheme];
      });
    }
    resolve(STATUS_SUCCESS);
  }
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (BOOL)requiresMainQueueSetup
{
  return YES;  // only do this if your module initialization relies on calling UIKit!
}

@end
