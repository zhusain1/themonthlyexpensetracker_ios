//
//  SetupWebView.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/5/22.
//

import SwiftUI
import WebKit

struct Webview: UIViewRepresentable{
    
    let url : URL?
    
    func makeUIView(context: Context) -> WKWebView{
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        return WKWebView(frame: .zero, configuration: config)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let unwrappedUrl = url else {
            return
        }
        let request = URLRequest(url: unwrappedUrl)
        uiView.load(request)
    }
    
    
    
    
}
