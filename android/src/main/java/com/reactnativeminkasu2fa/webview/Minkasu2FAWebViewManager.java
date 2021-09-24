package com.reactnativeminkasu2fa.webview;

import android.webkit.WebView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.Event;
import com.minkasu.android.twofa.exceptions.MissingDataException;
import com.minkasu.android.twofa.exceptions.MissingPermissionExceptions;
import com.minkasu.android.twofa.exceptions.PlatformNotSupportedException;
import com.minkasu.android.twofa.model.Address;
import com.minkasu.android.twofa.model.Config;
import com.minkasu.android.twofa.model.CustomerInfo;
import com.minkasu.android.twofa.model.OrderInfo;
import com.minkasu.android.twofa.sdk.Minkasu2faSDK;
import com.reactnativecommunity.webview.RNCWebViewManager;

import java.io.IOException;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

@ReactModule(name = Minkasu2FAWebViewManager.REACT_CLASS)
public class Minkasu2FAWebViewManager extends RNCWebViewManager {

    static final String REACT_CLASS = "Minkasu2FAWebView";
    private static final String STATUS = "status";
    private static final String SUCCESS = "Success";
    private static final String FAILURE = "Failure";
    private static final String ERROR_MESSAGE = "errorMessage";
    private static final String ERROR_CODE = "errorCode";
    private static final String INIT_TYPE = "initType";
    private static final String INIT_BY_METHOD = "byMethod";
    private static final String INIT_BY_PROPERTY = "byProperty";
    private static final String M_ID = "m_id";
    private static final String M_TOKEN = "m_token";
    private static final String CUSTOMER_ID = "customer_id";
    private static final String CUSTOMER_INFO = "customer_info";
    private static final String C_FIRST_NAME = "c_first_name";
    private static final String C_LAST_NAME = "c_last_name";
    private static final String C_EMAIL = "c_email";
    private static final String C_PHONE = "c_phone";
    private static final String CUSTOMER_ADDRESS_INFO = "customer_address_info";
    private static final String ADDRESS_LINE_1 = "address_line_1";
    private static final String ADDRESS_LINE_2 = "address_line_2";
    private static final String ADDRESS_CITY = "address_city";
    private static final String ADDRESS_STATE = "address_state";
    private static final String ADDRESS_COUNTRY = "address_country";
    private static final String ADDRESS_ZIP_CODE = "address_zip_code";
    private static final String CUSTOMER_ORDER_INFO = "customer_order_info";
    private static final String ORDER_ID = "order_id";
    private static final String SDK_MODE_SANDBOX = "sdk_mode_sandbox";
    private static final String ENABLE_BANK_APP_NB = "enable_bank_app_nb";
    private static final String SKIP_INIT = "skip_init";

    private static final int COMMAND_CONFIG_MINKASU2FA = 24680;

    private static Minkasu2FAWebViewModule getMinkasu2FAModule(ReactContext reactContext) {
        return reactContext.getNativeModule(Minkasu2FAWebViewModule.class);
    }
    
    private static String appendMinkasu2faUserAgent(String existingAgent) {
        String userAgent = Minkasu2faSDK.removeDuplicatesFromUserAgent(existingAgent);
        return userAgent + " " + Minkasu2faSDK.getMinkasu2faUserAgent();
    }

    @Override
    protected RNCWebView createRNCWebViewInstance(ThemedReactContext reactContext) {
        Minkasu2FAWebView webView = new Minkasu2FAWebView(reactContext);
        Minkasu2faSDK.setMinkasu2faUserAgent(webView);
        return webView;
    }

    @NonNull
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected void addEventEmitters(ThemedReactContext reactContext, WebView view) {
        view.setWebViewClient(new Minkasu2FAWebViewClient());
    }

    @Override
    public Map getExportedCustomDirectEventTypeConstants() {
        Map<String, Object> export = super.getExportedCustomDirectEventTypeConstants();
        if (export == null) {
            export = MapBuilder.newHashMap();
        }
        export.put(Minkasu2FAInitEvent.EVENT_NAME, MapBuilder.of("registrationName", "onMinkasu2FAInit"));
        return export;
    }

    @Nullable
    @Override
    public Map<String, Object> getExportedViewConstants() {
        Map<String, Object> export = super.getExportedViewConstants();
        if (export == null) {
            export = MapBuilder.newHashMap();
        }
        export.put("MERCHANT_ID", M_ID);
        export.put("MERCHANT_TOKEN", M_TOKEN);
        export.put("CUSTOMER_ID", CUSTOMER_ID);
        export.put("CUSTOMER_INFO", CUSTOMER_INFO);
        export.put("CUSTOMER_FIRST_NAME", C_FIRST_NAME);
        export.put("CUSTOMER_LAST_NAME", C_LAST_NAME);
        export.put("CUSTOMER_EMAIL", C_EMAIL);
        export.put("CUSTOMER_PHONE", C_PHONE);
        export.put("CUSTOMER_ADDRESS_INFO", CUSTOMER_ADDRESS_INFO);
        export.put("CUSTOMER_ADDRESS_LINE_1", ADDRESS_LINE_1);
        export.put("CUSTOMER_ADDRESS_LINE_2", ADDRESS_LINE_2);
        export.put("CUSTOMER_ADDRESS_CITY", ADDRESS_CITY);
        export.put("CUSTOMER_ADDRESS_STATE", ADDRESS_STATE);
        export.put("CUSTOMER_ADDRESS_COUNTRY", ADDRESS_COUNTRY);
        export.put("CUSTOMER_ADDRESS_ZIP_CODE", ADDRESS_ZIP_CODE);
        export.put("CUSTOMER_ORDER_INFO", CUSTOMER_ORDER_INFO);
        export.put("CUSTOMER_ORDER_ID", ORDER_ID);
        export.put("SDK_MODE_SANDBOX", SDK_MODE_SANDBOX);
        export.put("ENABLE_BANK_APP_NB", ENABLE_BANK_APP_NB);
        export.put("STATUS", STATUS);
        export.put("STATUS_SUCCESS", SUCCESS);
        export.put("STATUS_FAILURE", FAILURE);
        export.put("ERROR_MESSAGE", ERROR_MESSAGE);
        export.put("ERROR_CODE", ERROR_CODE);
        export.put("INIT_TYPE", INIT_TYPE);
        export.put("INIT_BY_METHOD", INIT_BY_METHOD);
        export.put("INIT_BY_ATTRIBUTE", INIT_BY_PROPERTY);
        export.put("SKIP_INIT", SKIP_INIT);
        export.put("MINKASU_2FA_USER_AGENT", Minkasu2faSDK.getMinkasu2faUserAgent());
        return export;
    }

    @javax.annotation.Nullable
    @Override
    public Map<String, Integer> getCommandsMap() {
        Map<String, Integer> exportCommandMap = super.getCommandsMap();
        if (exportCommandMap == null) {
            exportCommandMap = MapBuilder.<String, Integer>builder().build();
        }
        exportCommandMap.put("initMinkasu2FA", COMMAND_CONFIG_MINKASU2FA);
        return exportCommandMap;
    }

    @Override
    public void receiveCommand(WebView root, int commandId, @javax.annotation.Nullable ReadableArray args) {
        if (commandId == COMMAND_CONFIG_MINKASU2FA) {
            ReadableMap configMap = null;
            if (args != null) {
                configMap = args.getMap(0);
            }
            initSDK(root, configMap, INIT_BY_METHOD);
        } else {
            super.receiveCommand(root, commandId, args);
        }
    }

    @ReactProp(name = "source")
    public void setSource(WebView view, @Nullable ReadableMap source) {
        if (source != null && source.hasKey("headers")) {
            HashMap<String, Object> sourceMap = source.toHashMap();
            L1:
            for (Map.Entry<String, Object> entry : sourceMap.entrySet()) {
                if (entry.getKey().equals("headers")) {
                    Object value = entry.getValue();
                    if (value instanceof Map) {
                        HashMap<String, Object> headerMap = (HashMap<String, Object>) entry.getValue();
                        if (headerMap != null) {
                            for (Map.Entry<String, Object> headerEntry : headerMap.entrySet()) {
                                if ("user-agent".equals(headerEntry.getKey().toLowerCase(Locale.ENGLISH))) {
                                    headerEntry.setValue(appendMinkasu2faUserAgent((String) headerEntry.getValue()));
                                    break L1;
                                }
                            }
                        }
                    }
                }
            }
            WritableMap map = Arguments.makeNativeMap(sourceMap);
            super.setSource(view, map);
        } else {
            super.setSource(view, source);
        }
    }

    @ReactProp(name = "userAgent")
    public void setUserAgent(WebView view, @Nullable String userAgent) {
        super.setUserAgent(view, appendMinkasu2faUserAgent(userAgent));
    }

    @ReactProp(name = "minkasu2FAConfig")
    public void setMinkasu2FAConfig(WebView view, ReadableMap configMap) {
        initSDK(view, configMap, INIT_BY_PROPERTY);
    }

    private String getReadableMapStringValue(ReadableMap map, String keyName, String defaultValue) {
        return map.hasKey(keyName) ? map.getString(keyName) : defaultValue;
    }

    private synchronized void initSDK(WebView view, ReadableMap configMap, String initType) {
        if (configMap != null && configMap.toHashMap().size() > 0) {
            WritableMap eventData = Arguments.createMap();
            String status = SUCCESS;
            String errorMessage = null;
            CustomerInfo customer = new CustomerInfo();
            boolean isSkipInit = configMap.hasKey(SKIP_INIT) && configMap.getBoolean(SKIP_INIT);
            if (!isSkipInit) {
                if (configMap.hasKey(CUSTOMER_INFO)) {
                    ReadableMap customerInfo = configMap.getMap(CUSTOMER_INFO);
                    if (customerInfo != null) {
                        customer.setFirstName(getReadableMapStringValue(customerInfo, C_FIRST_NAME, null));
                        customer.setLastName(getReadableMapStringValue(customerInfo, C_LAST_NAME, null));
                        customer.setEmail(getReadableMapStringValue(customerInfo, C_EMAIL, null));
                        customer.setPhone(getReadableMapStringValue(customerInfo, C_PHONE, null));
                    }
                    Address address = new Address();
                    if (configMap.hasKey(CUSTOMER_ADDRESS_INFO)) {
                        ReadableMap addressInfo = configMap.getMap(CUSTOMER_ADDRESS_INFO);
                        if (addressInfo != null) {
                            address.setAddressLine1(getReadableMapStringValue(addressInfo, ADDRESS_LINE_1, null));
                            address.setAddressLine2(getReadableMapStringValue(addressInfo, ADDRESS_LINE_2, null));
                            address.setCity(getReadableMapStringValue(addressInfo, ADDRESS_CITY, null));
                            address.setState(getReadableMapStringValue(addressInfo, ADDRESS_STATE, null));
                            address.setCountry(getReadableMapStringValue(addressInfo, ADDRESS_COUNTRY, null));
                            address.setZipCode(getReadableMapStringValue(addressInfo, ADDRESS_ZIP_CODE, null));
                        }
                    }
                    customer.setAddress(address);
                }
                OrderInfo order = null;
                if (configMap.hasKey(CUSTOMER_ORDER_INFO)) {
                    ReadableMap orderInfo = configMap.getMap(CUSTOMER_ORDER_INFO);
                    if (orderInfo != null) {
                        order = new OrderInfo();
                        order.setOrderId(getReadableMapStringValue(orderInfo, ORDER_ID, null));
                    }
                }
                String mId = getReadableMapStringValue(configMap, M_ID, null);
                String mToken = getReadableMapStringValue(configMap, M_TOKEN, null);
                String customerId = getReadableMapStringValue(configMap, CUSTOMER_ID, null);

                Config configObj = Config.getInstance(mId, mToken, customerId, customer);
                String sdkMode = Config.PRODUCTION_MODE;
                if (configMap.hasKey(SDK_MODE_SANDBOX) && configMap.getBoolean(SDK_MODE_SANDBOX)) {
                    sdkMode = Config.SANDBOX_MODE;
                }
                configObj.setSDKMode(sdkMode);
                configObj.setEnableBankAppForNetBanking(configMap.hasKey(ENABLE_BANK_APP_NB) && configMap.getBoolean(ENABLE_BANK_APP_NB));
                configObj.setOrderInfo(order);
                configObj.setDisableMinkasu2faUserAgent(true);
                try {
                    getMinkasu2FAModule((ReactContext) view.getContext()).initSDK(view, configObj);
                } catch (MissingDataException e) {
                    errorMessage = e.getMessage();
                    eventData.putString(ERROR_CODE, e.getErrorCode());
                } catch (PlatformNotSupportedException e1) {
                    errorMessage = e1.getMessage();
                } catch (MissingPermissionExceptions e2) {
                    errorMessage = e2.getMessage();
                } catch (IOException e3) {
                    errorMessage = e3.getMessage();
                } catch (Exception e4) {
                    errorMessage = e4.getMessage();
                }
                if (errorMessage != null) {
                    eventData.putString(ERROR_MESSAGE, errorMessage);
                    status = FAILURE;
                }
            }
            eventData.putString(INIT_TYPE, initType);
            eventData.putString(STATUS, status);
            ((Minkasu2FAWebView) view).dispatchEvent(view, new Minkasu2FAInitEvent(view.getId(), eventData));
        }
    }

    private static class Minkasu2FAWebViewClient extends RNCWebViewClient {
    }

    private static class Minkasu2FAWebView extends RNCWebView {
        public Minkasu2FAWebView(ThemedReactContext reactContext) {
            super(reactContext);
        }

        @Override
        protected void dispatchEvent(WebView webView, Event event) {
            super.dispatchEvent(webView, event);
        }
    }
}