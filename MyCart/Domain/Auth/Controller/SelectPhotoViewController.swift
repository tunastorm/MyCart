//
//  SelectPhotoViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit


protocol SelectPhotoViewDelegate {
    
    func configInteraction()
}


class SelectPhotoViewController: BaseViewController<SelectPhotoView>{
    
    var isUpdateView = false
    var delegate: DataReceiveDelegate?
    var selectedCell: IndexPath?
    var selectedPhoto: UIImage?
    
    let photoList = Resource.NamedImage.allProfile
    
    override func loadView() {
        super.loadView()
        rootView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configInteraction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configProfileImage()
        configUpdateViewToggle()
    }
    
    func configProfileImage() {
        rootView.profileImageView.image = selectedPhoto
    }
    
    func configUpdateViewToggle() {
        var naviTitle =  Resource.Text.profileSetting
        if isUpdateView {
            naviTitle = Resource.Text.editProfileTitle
        }
        navigationItem.title = naviTitle
    }
}

extension SelectPhotoViewController: SelectPhotoViewDelegate {

    func configInteraction() {
        rootView.collectiomView.delegate = self
        rootView.collectiomView.dataSource = self
        rootView.collectiomView.register(SelectPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: SelectPhotoCollectionViewCell.identifier)
    }
}
 
