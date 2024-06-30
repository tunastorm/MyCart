//
//  SelectPhotoViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit


protocol SelectPhotoViewDelegate {
    func getSelectedPhoto() -> UIImage?
}


class SelectPhotoViewController: UIViewController {
    
    var isUpdateView = false
    
    var delegate: DataReceiveDelegate?
    
    let rootView = SelectPhotoView()
    
    var selectedCell: IndexPath?
    var selectedPhoto: UIImage?
    
    let photoList = Resource.NamedImage.allProfile
    
    override func loadView() {
        view = rootView
        rootView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUpdateViewToggle()
    }
    
    func configBaseSetting() {
        rootView.collectiomView.delegate = self
        rootView.collectiomView.dataSource = self
        rootView.collectiomView.register(SelectPhotoCollectionViewCell.self,
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
    func getSelectedPhoto() -> UIImage? {
        return selectedPhoto
    }
}
 
