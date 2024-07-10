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
            print(#function, searchBar.text)
            return
        }
        print(#function, query)
        viewModel.inputAddSearchedWord.value = query
        goSearchResultView(query: query)
    }
    
    func searchBarFilter(searchText: String) -> String? {
        let filter = TextInputFilter.shared
        return filter.removeSerialSpace(searchText)
    }
}
