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



final class ProductDetailViewController: MVCViewController<ProductDetailView> {

    var delegate: SearchResultCollectionViewCellDelegate?
    
    var row: Int?
    var product: ShopItem?
    
    var likeButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configExternalResource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let delegate, let productId = product?.productId else {
            return
        }
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        let title = product?.title.replacingOccurrences(of: "<b>", with: "")
        navigationItem.title = title?.replacingOccurrences(of: "</b>", with: "")
        configLikeButton()
    }
    
    private func configExternalResource() {
        rootView.webView.navigationDelegate = self
        guard let link = product?.link, let url = URL(string: link) else {
            print(#function, "아아날ㅇ나ㅣㅁ러리ㅏㅁ너라ㅣㅁ너라ㅣㄴㅁ럼나ㅣㄹㄴㅁㄹ")
            rootView.errorLabel.text = MapKitError.productURLNotExist.message
            rootView.viewToggle(error: MapKitError.productURLNotExist)
            return
        }
        let request = URLRequest(url: url)
        rootView.webView.load(request)
    }
    
    private func configLikeButton() {
        var cartImage = Resource.IsLike.unLike.image
        guard let id = product?.productId, let row else {
            return
        }
        
        likeButton = UIBarButtonItem(image: cartImage,
                                         style: .plain, target: self,
                                         action: #selector(likeButtonClicked))
        likeButton?.tag = row
        guard let likeButton else {return}
        navigationItem.rightBarButtonItems = [likeButton]
    }
    
    @objc private func likeButtonClicked(_ sender: UIButton) {
        guard let productId = product?.productId, let row = likeButton?.tag else {
            return
        }
        if sender.image(for: .normal) == Resource.NamedImage.likeSelected {
            
        }
        delegate?.updateLikedList(row, productId)
        configLikeButton()
    }
}

extension ProductDetailViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        rootView.errorLabel.text = MapKitError.productConnectionFailed.message
        rootView.viewToggle(error:MapKitError.productConnectionFailed)
    }
}


