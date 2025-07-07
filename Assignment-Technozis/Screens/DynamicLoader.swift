//
//  DynamicLoader.swift
//  Assignment-Technozis
//
//  Created by abh on 07/07/25.
//

import UIKit

class CustomLoaderView: UIView {
    private var backgroundView: UIView!
    private var loadingView: UIView!
    private var activityIndicator: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoaderView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLoaderView()
    }

    private func setupLoaderView() {
        // Background View
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.4
        addSubview(backgroundView)

        // Loading View
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        loadingView.center = backgroundView.center // Center the loadingView in backgroundView
        loadingView.backgroundColor = UIColor.white
        loadingView.layer.cornerRadius = 8

        // Activity Indicator
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = UIColor.gray
        activityIndicator.center = CGPoint(x: loadingView.bounds.width / 2, y: loadingView.bounds.height / 2)
        activityIndicator.startAnimating()

        // Add subviews
        loadingView.addSubview(activityIndicator)
        addSubview(loadingView)

        // Initial visibility
        isHidden = true
    }

    func startLoading() {
        isHidden = false
    }

    func stopLoading() {
        isHidden = true
    }
}
