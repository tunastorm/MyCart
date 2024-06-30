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


protocol ProductDetailViewDelegate {
    func configExternalResource()
}

class ProductDetailViewController: BaseViewController<ProductDetailView> {

    var product: ShopItem?
    
    var likeButton: UIBarButtonItem?
    
    override func loadView() {
        super.loadView()
        rootView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        let title = product?.title.replacingOccurrences(of: "<b>", with: "")
        navigationItem.title = title?.replacingOccurrences(of: "</b>", with: "")
        configLikeButton()
    }
    
    func configLikeButton() {
        var cartImage = Resource.IsLike.unLike.image
        guard let id = product?.productId else {
            return
        }
        if userModel.getIsLiked(productId: id) {
            cartImage = Resource.IsLike.like.image
        }
        likeButton = UIBarButtonItem(image: cartImage,
                                         style: .plain, target: self,
                                         action: #selector(likeButtonClicked))
        guard let likeButton else {return}
        navigationItem.rightBarButtonItems = [likeButton]
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        guard let productId = product?.productId else {return}
        userModel.setIsLiked(productId)
        configLikeButton()
    }
}

extension ProductDetailViewController: ProductDetailViewDelegate {
    
    func configExternalResource() {
        rootView.webView.navigationDelegate = self
        guard let link = product?.link, let url = URL(string: link) else {
            rootView.errorLabel.text = MapKitError.productURLNotExist.message
            rootView.viewToggle(error: MapKitError.productURLNotExist)
            return
        }
        let request = URLRequest(url: url)
        rootView.webView.load(request)
    }
}

extension ProductDetailViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        rootView.errorLabel.text = MapKitError.productConnectionFailed.message
        rootView.viewToggle(error:MapKitError.productConnectionFailed)
    }
}


