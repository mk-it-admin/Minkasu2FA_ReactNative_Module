import React, { Component } from 'react';
import { requireNativeComponent, NativeModules, UIManager as NotTypedUIManager } from 'react-native';
import { WebView } from 'react-native-webview';
const { Minkasu2FAWebViewManager } = NativeModules;

const UIManager = NotTypedUIManager;

export const Minkasu2FAUIConstants = UIManager.Minkasu2FAWebView.Constants;

export const Minkasu2FAWebViewModule = NativeModules.Minkasu2FAWebViewModule;

export const Minkasu2FAModuleConstants = Minkasu2FAWebViewModule.getConstants();

export default class Minkasu2FAWebView extends Component {

    minkasu2FAWebView = null;

    _onMinkasu2FAInit = (event) => {
        const { onMinkasu2FAInit } = this.props;
        onMinkasu2FAInit && onMinkasu2FAInit(event);
    };

    _getMinkasu2FAWebViewCommands = () => {
        return UIManager.getViewManagerConfig('Minkasu2FAWebView').Commands;
    };

    getWebViewRef = () => {
        return this.minkasu2FAWebView;
    }

    goForward = () => {
        UIManager.dispatchViewManagerCommand(this.minkasu2FAWebView.getWebViewHandle(), this._getMinkasu2FAWebViewCommands().goForward, undefined);
    };

    goBack = () => {
        UIManager.dispatchViewManagerCommand(this.minkasu2FAWebView.getWebViewHandle(), this._getMinkasu2FAWebViewCommands().goBack, undefined);
    };

    reload = () => {
        this.minkasu2FAWebView.setState({ viewState: 'LOADING' });
        UIManager.dispatchViewManagerCommand(this.minkasu2FAWebView.getWebViewHandle(), this._getMinkasu2FAWebViewCommands().reload, undefined);
    };

    stopLoading = () => {
        UIManager.dispatchViewManagerCommand(this.minkasu2FAWebView.getWebViewHandle(), this._getMinkasu2FAWebViewCommands().stopLoading, undefined);
    };

    requestFocus = () => {
        UIManager.dispatchViewManagerCommand(this.minkasu2FAWebView.getWebViewHandle(), this._getMinkasu2FAWebViewCommands().requestFocus, undefined);
    };

    postMessage = (data) => {
        UIManager.dispatchViewManagerCommand(this.minkasu2FAWebView.getWebViewHandle(), this._getMinkasu2FAWebViewCommands().postMessage, [String(data)]);
    };

    injectJavaScript = (data) => {
        UIManager.dispatchViewManagerCommand(this.minkasu2FAWebView.getWebViewHandle(), this._getMinkasu2FAWebViewCommands().injectJavaScript, [data]);
    };

    initMinkasu2FA = (obj) => {
        UIManager.dispatchViewManagerCommand(this.minkasu2FAWebView.getWebViewHandle(), this._getMinkasu2FAWebViewCommands().initMinkasu2FA, [obj]);
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

const Minkasu2FAWebViewComponent = requireNativeComponent('Minkasu2FAWebView'); 