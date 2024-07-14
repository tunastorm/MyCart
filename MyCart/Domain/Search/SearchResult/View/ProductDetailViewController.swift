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


final class ProductDetailViewController: BaseViewController {
    
    var delegate: SearchResultCollectionViewCellDelegate?
    var row: Int?
    var product: ShopItem?

    let webView = WKWebView()
    let errorView = UIView()
    let errorLabel = UILabel().then {
        $0.font = Resource.Font.boldSystem16
        $0.textAlignment = .center
        $0.textColor = Resource.MyColor.lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configExternalResource()
    }
    
    override func configHierarchy() {
        view.addSubview(webView)
    }
    
    override func configLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        super.configView()
        configErrorView()
    }
    
    func configErrorView() {
        let errorImage = UIImageView(image: Resource.SystemImage.networkSlash).then {
            $0.tintColor = Resource.MyColor.lightGray
            $0.contentMode = .scaleAspectFit
        }
        errorImage.isHidden = true
        
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

    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        let title = product?.title.replacingOccurrences(of: "<b>", with: "")
        navigationItem.title = title?.replacingOccurrences(of: "</b>", with: "")
        guard let delegate, let productId = product?.productId else {
            return
        }
        configLikeButton(delegate.checkIsLikedItem(productId))
    }
    
    private func configExternalResource() {
        webView.navigationDelegate = self
        guard let link = product?.link, let url = URL(string: link) else {
            errorLabel.text = MapKitError.productURLNotExist.message
            viewToggle(error: MapKitError.productURLNotExist)
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func configLikeButton(_ isLiked: Bool = false) {
        guard let delegate, let row else {
            return
        }
        let cartImage = isLiked ? Resource.IsLike.like.image : Resource.IsLike.unLike.image
        let likeButton = UIBarButtonItem(image: cartImage, style: .plain, target: self, action: #selector(likeButtonClicked))
        likeButton.tag = row
        navigationItem.rightBarButtonItem = likeButton
    }
    
    @objc private func likeButtonClicked(_ sender: UIBarButtonItem) {
        guard let productId = product?.productId else {
            return
        }
        var isLiked = sender.image == Resource.NamedImage.likeUnselected ? true : false
        configLikeButton(isLiked)
        delegate?.updateLikedList(sender.tag, productId)
    }
}

extension ProductDetailViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        errorLabel.text = MapKitError.productConnectionFailed.message
        viewToggle(error:MapKitError.productConnectionFailed)
    }
}


