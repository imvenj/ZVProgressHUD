//
//  ZVStateView.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/13.
//  Copyright © 2017-2019 zevwings. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

public class IndicatorView: UIView {

    var strokeWidth: CGFloat = 3.0 {
        didSet {
            flatActivityIndicatorView?.strokeWidth = strokeWidth
        }
    }
    
    var indcatorType: IndicatorType = .none {
        didSet {
            switch indcatorType {
            case .indicator(let style):
                switch (style) {
                case .native:
                    configNativeActivityIndicatorView()
                case .flat:
                    configFlatActivityIndicatorView()
                }
            case .progress(let value):
                configProgressIndicatorView(with: value)
            case .error, .success, .warning:
                configImageIndicatorView(indcatorType.resource)
            case .image(let value, _):
                configImageIndicatorView(value)
            case .animation(let value, let duration):
                configImageIndicatorView(value, animationDuration: duration)
            default:
                break
            }
            isHidden = indcatorType.shouldHidden
        }
    }
    
    private var imageIndicaotorView: UIImageView?
    private var nativeActivityIndicatorView: UIActivityIndicatorView?
    private var flatActivityIndicatorView: ActivityIndicatorView?
    private var progressIndicatorView: ProgressView?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Override

extension IndicatorView {
    
    override public var tintColor: UIColor! {
        didSet {
            imageIndicaotorView?.tintColor = tintColor
            nativeActivityIndicatorView?.color = tintColor
            flatActivityIndicatorView?.tintColor = tintColor
            progressIndicatorView?.strokeColor = tintColor
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let subViewFrame = CGRect(origin: .zero, size: frame.size)
        
        imageIndicaotorView?.frame = subViewFrame
        flatActivityIndicatorView?.frame = subViewFrame
        nativeActivityIndicatorView?.frame = subViewFrame
        progressIndicatorView?.frame = subViewFrame
    }
}

// MARK: - Private Method

private extension IndicatorView {
    
    func configImageIndicatorView(_ value: Any, animationDuration: TimeInterval = 0.0) {

        flatActivityIndicatorView?.stopAnimating()
        flatActivityIndicatorView?.removeFromSuperview()
        
        nativeActivityIndicatorView?.stopAnimating()
        nativeActivityIndicatorView?.removeFromSuperview()
        
        imageIndicaotorView?.stopAnimating()
        imageIndicaotorView?.animationImages = nil
        imageIndicaotorView?.image = nil
        
        progressIndicatorView?.removeFromSuperview()
        
        if imageIndicaotorView == nil {
            imageIndicaotorView = UIImageView(frame: .zero)
            imageIndicaotorView?.isUserInteractionEnabled = false
        }

        if imageIndicaotorView?.superview == nil {
            addSubview(imageIndicaotorView!)
        }
        
        if let resource = value as? String,
            let path = Bundle(for: ProgressHUD.self).path(forResource: "Resource", ofType: "bundle") {
            
            let bundle = Bundle(path: path)
            guard let fileName = bundle?.path(forResource: resource, ofType: "png") else { return }
            let image = UIImage(contentsOfFile: fileName)?.withRenderingMode(.alwaysTemplate)
            imageIndicaotorView?.tintColor = tintColor
            imageIndicaotorView?.image = image
        } else if let image = value as? UIImage {
            
            imageIndicaotorView?.image = image
        } else if let animationImages = value as? [UIImage] {
            
            if animationImages.isEmpty {
                imageIndicaotorView?.image = nil
            } else if animationImages.count == 1 {
                imageIndicaotorView?.image = animationImages[0]
            } else {
                imageIndicaotorView?.animationImages = animationImages
                imageIndicaotorView?.animationDuration = animationDuration
                imageIndicaotorView?.startAnimating()
            }

            imageIndicaotorView?.animationImages = animationImages
            imageIndicaotorView?.startAnimating()
        }
    }
    
    func configProgressIndicatorView(with value: Float) {
        
        flatActivityIndicatorView?.stopAnimating()
        flatActivityIndicatorView?.removeFromSuperview()
        
        imageIndicaotorView?.animationImages = nil
        imageIndicaotorView?.image = nil
        imageIndicaotorView?.stopAnimating()
        imageIndicaotorView?.removeFromSuperview()
        
        nativeActivityIndicatorView?.stopAnimating()
        nativeActivityIndicatorView?.removeFromSuperview()

        if progressIndicatorView == nil {
            progressIndicatorView = ProgressView(frame: .zero)
            progressIndicatorView?.strokeColor = tintColor
        }
        
        if progressIndicatorView?.superview == nil {
            addSubview(progressIndicatorView!)
        }

        progressIndicatorView?.updateProgress(value)
    }
    
    private func configNativeActivityIndicatorView() {
        
        flatActivityIndicatorView?.stopAnimating()
        flatActivityIndicatorView?.removeFromSuperview()
        
        imageIndicaotorView?.animationImages = nil
        imageIndicaotorView?.image = nil
        imageIndicaotorView?.stopAnimating()
        imageIndicaotorView?.removeFromSuperview()

        progressIndicatorView?.removeFromSuperview()

        if nativeActivityIndicatorView == nil {
            nativeActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
            nativeActivityIndicatorView?.color = tintColor
            nativeActivityIndicatorView?.hidesWhenStopped = true
        }
        
        if nativeActivityIndicatorView?.superview == nil {
            addSubview(nativeActivityIndicatorView!)
        }
        
        nativeActivityIndicatorView?.startAnimating()
    }
    
    private func configFlatActivityIndicatorView() {
        
        nativeActivityIndicatorView?.stopAnimating()
        nativeActivityIndicatorView?.removeFromSuperview()
        
        imageIndicaotorView?.image = nil
        imageIndicaotorView?.animationImages = nil
        imageIndicaotorView?.stopAnimating()
        imageIndicaotorView?.removeFromSuperview()
        
        progressIndicatorView?.removeFromSuperview()

        if flatActivityIndicatorView == nil {
            flatActivityIndicatorView = ActivityIndicatorView()
            flatActivityIndicatorView?.tintColor = tintColor
            flatActivityIndicatorView?.hidesWhenStopped = true
            flatActivityIndicatorView?.strokeWidth = strokeWidth
        }
        
        if flatActivityIndicatorView?.superview == nil {
            addSubview(flatActivityIndicatorView!)
        }
        
        flatActivityIndicatorView?.startAnimating()
    }
}
