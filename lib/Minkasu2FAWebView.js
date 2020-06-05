import React, { Component } from 'react';
import * as PropTypes from 'prop-types';
import { requireNativeComponent, NativeModules, UIManager as NotTypedUIManager } from 'react-native';
import { WebView } from 'react-native-webview';
const { Minkasu2FAWebViewManager } = NativeModules;

export const Minkasu2FAUIConstants = NotTypedUIManager.Minkasu2FAWebView.Constants;

export const Minkasu2FAWebViewModule = NativeModules.Minkasu2FAWebViewModule;

export default class Minkasu2FAWebView extends Component {
    static propTypes = {
        ...WebView.propTypes,
        onMinkasu2FAInit: PropTypes.func,
        minkasu2FAConfig: PropTypes.object
    };

    minkasu2FAWebView = null;

    _onMinkasu2FAInit = (event) => {
        const { onMinkasu2FAInit } = this.props;
        onMinkasu2FAInit && onMinkasu2FAInit(event);
    };

    _getMinkasu2FAWebViewCommands = () => { return NotTypedUIManager.getViewManagerConfig('Minkasu2FAWebView').Commands; };

    initMinkasu2FA = (obj) => {
        NotTypedUIManager.dispatchViewManagerCommand(this.minkasu2FAWebView.getWebViewHandle(), this._getMinkasu2FAWebViewCommands().initMinkasu2FA, [obj]);
    }

    render() {
        return (
            <WebView
                ref={ref => (this.minkasu2FAWebView = ref)}
                {...this.props}
                nativeConfig={{
                    component: Minkasu2FAWebViewComponent,
                    viewManager: Minkasu2FAWebViewManager,
                    props: {
                        minkasu2FAConfig: this.props.minkasu2FAConfig,
                        onMinkasu2FAInit: this._onMinkasu2FAInit
                    }
                }} />
        );
    }
}

const Minkasu2FAWebViewComponent = requireNativeComponent(
    'Minkasu2FAWebView',
    Minkasu2FAWebView,
    {
        ...WebView.extraNativeComponentConfig
    }
);