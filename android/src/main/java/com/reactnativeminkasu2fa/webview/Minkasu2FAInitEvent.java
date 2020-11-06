package com.reactnativeminkasu2fa.webview;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.Event;
import com.facebook.react.uimanager.events.RCTEventEmitter;

class Minkasu2FAInitEvent extends Event<Minkasu2FAInitEvent> {

    static final String EVENT_NAME = "minkasu2FAInitEvent";

    private final WritableMap mParams;

    Minkasu2FAInitEvent(int viewTag, WritableMap params) {
        super(viewTag);
        this.mParams = params;
    }

    @Override
    public String getEventName() {
        return EVENT_NAME;
    }

    @Override
    public boolean canCoalesce() {
        return false;
    }

    @Override
    public short getCoalescingKey() {
        return 0;
    }

    @Override
    public void dispatch(RCTEventEmitter rctEventEmitter) {
        init(getViewTag());
        rctEventEmitter.receiveEvent(getViewTag(), getEventName(), mParams);
    }
}
