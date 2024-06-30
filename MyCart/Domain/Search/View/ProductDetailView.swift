//
//  ProductDetailView.swift
//  MyCart
//
//  Created by 유철원 on 7/1/24.
//

import UIKit
import WebKit


class ProductDetailView: BaseView {
    
    var delegate: ProductDetailViewDelegate?
    
    let webView = WKWebView()
    let errorView = UIView()
    let errorLabel = UILabel().then {
        $0.font = Resource.Font.boldSystem16
        $0.textAlignment = .center
        $0.textColor = Resource.MyColor.lightGray
    }
    

    override func configHierarchy() {
        self.addSubview(webView)
    }
    
    override func configLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        self.backgroundColor = Resource.MyColor.white
        configErrorView()
        guard let delegate else {
            return
        }
    }
    
    override func configExternalResource() {
        guard let delegate else {
            return
        }
        delegate.configExternalResource()
    }
    
    func configErrorView() {
        let errorImage = UIImageView(image: Resource.SystemImage.networkSlash).then {
            $0.tintColor = Resource.MyColor.lightGray
            $0.contentMode = .scaleAspectFit
        }
        
        self.addSubview(errorView)
        errorView.addSubview(errorImage)
        errorView.addSubview(errorLabel)
        
        errorView.snp.makeConstraints {
            $0.size.equalTo(300)
            $0.center.equalTo(safeAreaLayoutGuide)
        }
        
        errorImage.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.8)
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(errorImage.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    func viewToggle(error: MapKitError) {
        switch error {
        case .productURLNotExist, .productConnectionFailed:
            webView.isHidden = true
            errorView.isHidden = false
        default:
            webView.isHidden = false
           errorView.isHidden = true
        }
    }
}
