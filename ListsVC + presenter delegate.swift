//
//  ListsVC + presenter delegate.swift
//  employee
//
//  Created by Ahmed on 3/17/21.
//

import UIKit


extension ListsVC: ListsView{
    func dataFeatchedSuccessfully() {
        confirmBTN.isHidden = false
        cancleBTN.isHidden = false
        loading.isHidden = true
        listPicker.reloadAllComponents()
        begin(initial: false)
    }
    
    func errorWhenFeatcheingDate() {
        cancleBTN.isHidden = false
        loading.isHidden = true
    }
    
    func submit(id: String, name: String, available: String?) {
        end {
            self.delegate?.get(name: name, id: id, avalaiable: available)
        }
    }
}
