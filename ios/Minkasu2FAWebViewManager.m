//
//  Minkasu2FAWebViewManager.m
//  SampleMinkasuApp
//
//  Created by Habibur on 17/03/20.
//  Copyright © 2020 Minkasu. All rights reserved.
//

#import "Minkasu2FAWebViewManager.h"
#import "Minkasu2FAWebView.h"
#import <Minkasu2FA/Minkasu2FA.h>
#import <React/RCTUIManager.h>
#import "Minkasu2FAConstants.h"

@interface RNCWebView()
@property (nonatomic, copy) WKWebView *webView;
@end

@interface Minkasu2FAWebViewManager () <RNCWebViewDelegate>

@end

@implementation Minkasu2FAWebViewManager

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(onMinkasu2FAInit, RCTDirectEventBlock)

- (NSDictionary *)constantsToExport{
  
  NSDictionary *export = @{@"MERCHANT_ID":MERCHANT_ID,
                           @"MERCHANT_TOKEN":MERCHANT_TOKEN,
                           @"CUSTOMER_ID":CUSTOMER_ID,
                           @"CUSTOMER_INFO":CUSTOMER_INFO,
                           @"CUSTOMER_FIRST_NAME":CUSTOMER_FIRST_NAME,
                           @"CUSTOMER_LAST_NAME":CUSTOMER_LAST_NAME,
                           @"CUSTOMER_EMAIL":CUSTOMER_EMAIL,
                           @"CUSTOMER_PHONE":CUSTOMER_PHONE,
                           @"CUSTOMER_ADDRESS_INFO":CUSTOMER_ADDRESS_INFO,
                           @"CUSTOMER_ADDRESS_LINE_1":CUSTOMER_ADDRESS_LINE_1,
                           @"CUSTOMER_ADDRESS_LINE_2":CUSTOMER_ADDRESS_LINE_2,
                           @"CUSTOMER_ADDRESS_CITY":CUSTOMER_ADDRESS_CITY,
                           @"CUSTOMER_ADDRESS_STATE":CUSTOMER_ADDRESS_STATE,
                           @"CUSTOMER_ADDRESS_COUNTRY":CUSTOMER_ADDRESS_COUNTRY,
                           @"CUSTOMER_ADDRESS_ZIP_CODE":CUSTOMER_ADDRESS_ZIP_CODE,
                           @"CUSTOMER_ORDER_INFO":CUSTOMER_ORDER_INFO,
                           @"CUSTOMER_ORDER_ID":CUSTOMER_ORDER_ID,
                           @"SDK_MODE_SANDBOX":SDK_MODE_SANDBOX,
                           @"STATUS":STATUS,
                           @"STATUS_SUCCESS":STATUS_SUCCESS,
                           @"STATUS_FAILURE":STATUS_FAILURE,
                           @"ERROR_MESSAGE":ERROR_MESSAGE,
                           @"ERROR_CODE":ERROR_CODE,
                           @"INIT_TYPE":INIT_TYPE,
                           @"INIT_BY_METHOD":INIT_BY_METHOD,
                           @"INIT_BY_ATTRIBUTE":INIT_BY_ATTRIBUTE,
                           @"SKIP_INIT":SKIP_INIT,
                           @"NAVIGATION_BAR_COLOR":NAVIGATION_BAR_COLOR,
                           @"NAVIGATION_BAR_TEXT_COLOR":NAVIGATION_BAR_TEXT_COLOR,
                           @"BUTTON_BACKGROUND_COLOR":BUTTON_BACKGROUND_COLOR,
                           @"BUTTON_TEXT_COLOR":BUTTON_TEXT_COLOR,
                           @"DARK_MODE_NAVIGATION_BAR_COLOR":DARK_MODE_NAVIGATION_BAR_COLOR,
                           @"DARK_MODE_NAVIGATION_BAR_TEXT_COLOR":DARK_MODE_NAVIGATION_BAR_TEXT_COLOR,
                           @"DARK_MODE_BUTTON_BACKGROUND_COLOR":DARK_MODE_BUTTON_BACKGROUND_COLOR,
                           @"DARK_MODE_BUTTON_TEXT_COLOR":DARK_MODE_BUTTON_TEXT_COLOR,
                           @"SUPPORT_DARK_MODE":SUPPORT_DARK_MODE,
                           @"IOS_THEME_OBJ":IOS_THEME_OBJ
  };
  return export;
}
- (UIView *)view
{
  Minkasu2FAWebView *webView = [Minkasu2FAWebView new];
  webView.delegate = self;
  return webView;
}

RCT_CUSTOM_VIEW_PROPERTY(minkasu2FAConfig, NSDictionary, Minkasu2FAWebView
                         ) {
  view.minkasu2FAConfig = json == nil? nil:[RCTConvert NSDictionary: json];
  Minkasu2FAConfig *config = [self createConfig:view.minkasu2FAConfig];
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *status = STATUS_SUCCESS;
    if (self->_isSkipInit) {
      view.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_ATTRIBUTE });
    }else{
      @try {
        [Minkasu2FA initWithWKWebView:view.webView andConfiguration:config inViewController:nil];
        view.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_ATTRIBUTE});
      }
      @catch (NSException *exception) {
        status = STATUS_FAILURE;
        view.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_ATTRIBUTE,@"errorMessage":exception.reason,@"errorCode":exception.name});
      }
    }
  });
}

RCT_EXPORT_METHOD(initMinkasu2FA:(nonnull NSNumber *)reactTag minkasu2FAConfig:(NSDictionary*)minkasu2FAConfig)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, Minkasu2FAWebView *> *viewRegistry) {
    Minkasu2FAWebView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[Minkasu2FAWebView class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting RNCWebView, got: %@", view);
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        Minkasu2FAConfig *config = [self createConfig:minkasu2FAConfig];
        NSString *status = STATUS_SUCCESS;
        if (self.isSkipInit) {
          view.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_METHOD });
        }else{
          @try {
            [Minkasu2FA initWithWKWebView:view.webView andConfiguration:config inViewController:nil];
            view.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_METHOD });
          } @catch (NSException *exception) {
            status = STATUS_FAILURE;
            view.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_METHOD,@"errorMessage":exception.reason,@"errorCode":exception.name});
          }
        }
      });
    }
  }];
}

-(Minkasu2FAConfig*)createConfig:(NSDictionary*)minkasu2FAConfig{
  Minkasu2FAConfig *config = [Minkasu2FAConfig new];
  if (minkasu2FAConfig && !minkasu2FAConfig[SKIP_INIT]) {
    Minkasu2FACustomerInfo *customer = [Minkasu2FACustomerInfo new];
    Minkasu2FAAddress *address = [Minkasu2FAAddress new];
    Minkasu2FAOrderInfo *orderInfo = [Minkasu2FAOrderInfo new];
    if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO] && minkasu2FAConfig[CUSTOMER_ADDRESS_INFO] != nil) {
      if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_LINE_1]) {
        address.line1 = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_LINE_1];
      }
      if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_LINE_2]) {
        address.line2 = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_LINE_2];
      }
      if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_CITY]) {
        address.city = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_CITY];
      }
      if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_STATE]) {
        address.state = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_STATE];
      }
      if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_COUNTRY]) {
        address.country = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_COUNTRY];
      }
      if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_ZIP_CODE]) {
        address.zipCode = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_ZIP_CODE];
      }
    }
    if (minkasu2FAConfig[CUSTOMER_INFO] && minkasu2FAConfig[CUSTOMER_INFO] != nil ) {
      if (minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_FIRST_NAME]) {
        customer.firstName = minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_FIRST_NAME];
      }
      if (minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_LAST_NAME]) {
        customer.lastName = minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_LAST_NAME];
      }
      if (minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_PHONE]) {
        customer.phone = minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_PHONE];
      }
      if (minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_EMAIL]) {
        customer.email = minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_EMAIL];
      }
    }
    customer.address = address;
    if (minkasu2FAConfig[MERCHANT_ID]) {
      config.merchantId = minkasu2FAConfig[MERCHANT_ID];
    }
    if (minkasu2FAConfig[MERCHANT_TOKEN]) {
      config.merchantToken = minkasu2FAConfig[MERCHANT_TOKEN];
    }
    if (minkasu2FAConfig[CUSTOMER_ID]) {
      config.merchantCustomerId = minkasu2FAConfig[CUSTOMER_ID];
    }
    config.customerInfo = customer;
    if (minkasu2FAConfig[SDK_MODE_SANDBOX]) {
      config.sdkMode = [minkasu2FAConfig[SDK_MODE_SANDBOX]  isEqual: @1] ? MINKASU2FA_SANDBOX_MODE : MINKASU2FA_PRODUCTION_MODE;
    }
    if (minkasu2FAConfig[CUSTOMER_ORDER_INFO] && minkasu2FAConfig[CUSTOMER_ORDER_INFO] != nil && minkasu2FAConfig[CUSTOMER_ORDER_INFO][CUSTOMER_ORDER_ID]) {
      orderInfo.orderId = minkasu2FAConfig[CUSTOMER_ORDER_INFO][CUSTOMER_ORDER_ID];
    }
    config.orderInfo = orderInfo;
    Minkasu2FACustomTheme *mkcolorTheme = [Minkasu2FACustomTheme new];
    if (minkasu2FAConfig[IOS_THEME_OBJ] && minkasu2FAConfig[IOS_THEME_OBJ] != nil) {
      if (minkasu2FAConfig[IOS_THEME_OBJ][NAVIGATION_BAR_COLOR]) {
        mkcolorTheme.navigationBarColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][NAVIGATION_BAR_COLOR]];
      }
      if (minkasu2FAConfig[IOS_THEME_OBJ][NAVIGATION_BAR_TEXT_COLOR]) {
        mkcolorTheme.navigationBarTextColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][NAVIGATION_BAR_TEXT_COLOR]];
      }
      if (minkasu2FAConfig[IOS_THEME_OBJ][BUTTON_BACKGROUND_COLOR]) {
        mkcolorTheme.buttonBackgroundColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][BUTTON_BACKGROUND_COLOR]];
      }
      if (minkasu2FAConfig[IOS_THEME_OBJ][BUTTON_TEXT_COLOR]) {
        mkcolorTheme.buttonTextColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][BUTTON_TEXT_COLOR]];
      }
      if (minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_NAVIGATION_BAR_COLOR]) {
        mkcolorTheme.darkModeNavigationBarColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_NAVIGATION_BAR_COLOR]];
      }
      if (minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_NAVIGATION_BAR_TEXT_COLOR]) {
        mkcolorTheme.darkModeNavigationBarTextColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_NAVIGATION_BAR_TEXT_COLOR]];
      }
      if (minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_BUTTON_BACKGROUND_COLOR]) {
        mkcolorTheme.darkModeButtonBackgroundColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_BUTTON_BACKGROUND_COLOR]];
      }
      if (minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_BUTTON_TEXT_COLOR]) {
        mkcolorTheme.darkModeButtonTextColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_BUTTON_TEXT_COLOR]];
      }
      if (minkasu2FAConfig[IOS_THEME_OBJ][SUPPORT_DARK_MODE]) {
        mkcolorTheme.supportDarkMode = minkasu2FAConfig[IOS_THEME_OBJ][SUPPORT_DARK_MODE];
      }
    }
    config.customTheme = mkcolorTheme;
  }else{
    _isSkipInit = true;
  }
  return config;
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+(BOOL)requiresMainQueueSetup
{  return YES;  // only do this if your module initialization relies on calling UIKit!
}

-(BOOL)webView:(RNCWebView * _Nonnull)webView shouldStartLoadForRequest:(NSMutableDictionary<NSString *,id> * _Nonnull)request withCallback:(RCTDirectEventBlock _Nonnull)callback {
  return true;
}

@end
