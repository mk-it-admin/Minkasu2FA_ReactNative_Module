package com.reactnativeminkasu2fa.webview;

import android.util.Log;
import android.webkit.WebView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.module.annotations.ReactModule;
import com.minkasu.android.twofa.enums.Minkasu2faOperationType;
import com.minkasu.android.twofa.model.Config;
import com.minkasu.android.twofa.sdk.Minkasu2faSDK;
import com.reactnativecommunity.webview.RNCWebViewModule;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@ReactModule(name = Minkasu2FAWebViewModule.MODULE_NAME)
public class Minkasu2FAWebViewModule extends RNCWebViewModule {
    static final String MODULE_NAME = "Minkasu2FAWebViewModule";

    private static final String CHANGE_PIN = "changePin";
    private static final String ENABLE_BIOMETRICS = "enableBiometrics";
    private static final String DISABLE_BIOMETRICS = "disableBiometrics";

    Minkasu2FAWebViewModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return MODULE_NAME;
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        Map<String, Object> exportConstant = super.getConstants();
        if (exportConstant == null) {
            exportConstant = new HashMap<>();
        }
        exportConstant.put("CHANGE_PIN", CHANGE_PIN);
        exportConstant.put("ENABLE_BIOMETRICS", ENABLE_BIOMETRICS);
        exportConstant.put("DISABLE_BIOMETRICS", DISABLE_BIOMETRICS);
        return exportConstant;
    }

    @ReactMethod
    public void getAvailableMinkasu2faOperations(Promise promise) {
        List<Minkasu2faOperationType> operationTypes = Minkasu2faSDK.getAvailableMinkasu2faOperations(getCurrentActivity());
        WritableMap operationTypeMap = Arguments.createMap();
        for (Minkasu2faOperationType operationType : operationTypes) {
            switch (operationType) {
                case CHANGE_PAYPIN:
                    operationTypeMap.putString(CHANGE_PIN, operationType.getValue());
                    break;
                case ENABLE_BIOMETRICS:
                    operationTypeMap.putString(ENABLE_BIOMETRICS, operationType.getValue());
                    break;
                case DISABLE_BIOMETRICS:
                    operationTypeMap.putString(DISABLE_BIOMETRICS, operationType.getValue());
                    break;
            }
        }
        promise.resolve(operationTypeMap);
    }

    @ReactMethod
    public void performMinkasu2FAOperation(String merchantCustomerId, String operationTypeStr, Promise promise) {
        if (merchantCustomerId == null || merchantCustomerId.length() == 0) {
            promise.reject(new Exception("Invalid Merchant Customer Id"));
            return;
        }
        if (getCurrentActivity() != null) {
            List<Minkasu2faOperationType> operationTypes = Minkasu2faSDK.getAvailableMinkasu2faOperations(getCurrentActivity());
            Minkasu2faOperationType operationType = null;
            if (operationTypeStr != null && operationTypeStr.length() > 0) {
                for (Minkasu2faOperationType opType : operationTypes) {
                    if (opType.getValue().equalsIgnoreCase(operationTypeStr)) {
                        operationType = opType;
                        break;
                    }
                }
            }
            if (operationType == null) {
                promise.reject(new Exception("Invalid Operation Type"));
                return;
            }
            try {
                Minkasu2faSDK minkasu2faSDKInstance = Minkasu2faSDK.create(getCurrentActivity(), operationType, merchantCustomerId);
                minkasu2faSDKInstance.start();
                promise.resolve("Success");
            } catch (Exception e) {
                Log.i("Exception", e.toString());
                promise.reject(e);
            }
        } else {
            promise.reject(new Exception("Activity unavailable"));
        }
    }

    void initSDK(@NonNull WebView view, @NonNull Config config) throws Exception {
        Minkasu2faSDK.init(getCurrentActivity(), config, view);
    }
}
