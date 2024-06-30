//
//  ProductDetailViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit
import WebKit

import SnapKit
import Then

class ProductDetailViewController: UIViewController {
    
    var delegate: SearchViewController?
    
    var product: ShopItem?
    
    let webView = WKWebView()
    let errorView = UIView()
    let errorLabel = UILabel().then {
        $0.font = Resource.Font.boldSystem16
        $0.textAlignment = .center
        $0.textColor = Resource.MyColor.lightGray
    }
    
    var likeButton: UIBarButtonItem?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseSetting()
        configHierarchy()
        configLayout()
        configView()
        configErrorView()
        viewToggle(isError: false)
        configLikeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let title = product?.title.replacingOccurrences(of: "<b>", with: "")
        navigationItem.title = title?.replacingOccurrences(of: "</b>", with: "")
        configWebView()
    }
    
    func configBaseSetting() {
        webView.navigationDelegate = self
    }
    
    func configHierarchy() {
        view.addSubview(webView)
    }
    
    func configLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configView() {
        view.backgroundColor = Resource.MyColor.white
    }
    
    func configWebView() {
        guard let link = product?.link,
              let url = URL(string: link) else {
            errorLabel.text = StatusMessage.APIError.productURLNotExist.message
            viewToggle(isError: true)
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func configErrorView() {
        let errorImage = UIImageView(image: Resource.SystemImage.networkSlash).then {
            $0.tintColor = Resource.MyColor.lightGray
            $0.contentMode = .scaleAspectFit
        }
        
        view.addSubview(errorView)
        errorView.addSubview(errorImage)
        errorView.addSubview(errorLabel)
        
        errorView.snp.makeConstraints {
            $0.size.equalTo(300)
            $0.center.equalTo(view.safeAreaLayoutGuide)
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
    
    
    func viewToggle(isError: Bool) {
        if isError {
            webView.isHidden = true
            errorView.isHidden = false
        } else {
            webView.isHidden = false
            errorView.isHidden = true
        }
    }
    
    func configLikeButton() {
        
        var cartImage = Resource.NamedImage.likeUnselected?.withRenderingMode(.alwaysOriginal)

        guard let id = product?.productId,
              let isLiked = delegate?.getIsLiked(productId: id) else {return}
        
        if isLiked {
            cartImage = Resource.NamedImage.likeSelected?.withRenderingMode(.alwaysOriginal)
        }
        likeButton = UIBarButtonItem(image: cartImage,
                                         style: .plain, target: self,
                                         action: #selector(likeButtonClicked))
        guard let likeButton else {return}
        navigationItem.rightBarButtonItems = [likeButton]
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        guard let productId = product?.productId else {return}
        delegate?.setIsLiked(productId)
        configLikeButton()
    }
}

extension ProductDetailViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        errorLabel.text = StatusMessage.APIError.productConnectionFailed.message
        viewToggle(isError: true)
    }
    
    
}
