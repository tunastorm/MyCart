//
//  MainViewSearchBarController.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit


extension MainViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.placeholder = nil
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = Resource.Text.searchBarPlaceHolder
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, let query = searchBarFilter(searchText: searchText) else {
            print(#function, "잘못된 검색어", searchBar.text)
            makeBasicToast(message: "올바른 검색어를 입력해주세요", duration: 3.0, position: .bottom)
            return
        }
        print(#function, query)
        goSearchResultView(query: query)
    }
    
    func searchBarFilter(searchText: String) -> String? {
        return Utils.textFilter.removeSerialSpace(searchText)
    }
}
