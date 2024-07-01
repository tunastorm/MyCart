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
        configProfileImage()
        configInteraction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        configUpdateViewToggle()
    }
    
    func configProfileImage() {
        rootView.profileImageView.image = selectedPhoto
    }
    
    func configInteraction() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        rootView.collectionView.register(SelectPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: SelectPhotoCollectionViewCell.identifier)
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

   
}
 
