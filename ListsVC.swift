//
//  ListsVC.swift
//  employee
//
//  Created by Ahmed on 3/17/21.
//

import UIKit


protocol ListsDelegate{
    func get(name: String, id: String, avalaiable: String?)
}

/// this VC is to show popup list of pickerView with animation
/// required:  type of list & & date & set delegate
class ListsVC: UIViewController, UIDocumentPickerDelegate,UINavigationControllerDelegate {

    //MARK:- variables
    var presenter: ListsPresenter?
    var types: ListsTypes?
    var delegate: ListsDelegate?
    var Date: Int64?
    var selectedRow: Int?
    
    
    //MARK:- outlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var containerBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var confirmBTN: UIButton!
    @IBOutlet weak var cancleBTN: UIButton!
    @IBOutlet weak var listPicker: UIPickerView!
    
    //MARK:- view
    override func viewDidLoad() {
        super.viewDidLoad()
        UI()
    }
    
    //MARK:- functions
    
    
    /// begin animation for list view in two cases
    /// - case1: (true)  initial form that the loading is visible until the data featched from API
    /// - case2: (false) show the all view to display the data in the list
    /// - Parameter initial: take if the animation is in initial form or not
    func begin(initial: Bool){
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [self] (_) in
            UIView.animate(withDuration: 0.3) {
                containerBottomContraint.constant = initial ? -130:0
                view.layoutIfNeeded()
            }
        }
    }
    
    /// end the animation with ecuted scope and its optional
    /// - Parameter scope: the scope that will ecute after the animation ended
    func end(scope: (() -> Void)? = nil){
        UIView.animate(withDuration: 0.3) { [self] in
            self.containerBottomContraint.constant = -180
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [self] (_) in
                DispatchQueue.main.async {
                    self.dismiss(animated: false){
                        scope?()
                    }
                }
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
    func UI(){
        presenter = ListsPresenter(view: self)
        container.setCurveToCorners(topLeft: true, topRight: true)
        begin(initial: true)
        presenter?.viewdidload(type: types ?? .vacations, Date: Date)
        let swipeGeaster = UISwipeGestureRecognizer(target: self, action: #selector(DatePickerVC.backAction(_:)))
        swipeGeaster.direction = .down
        container.addGestureRecognizer(swipeGeaster)
    }
    
    //MARK:- actions
    @IBAction func backAction(_ sender: UIButton) {
        end()
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        presenter?.getTypedata(type: types ?? .vacations, of: selectedRow ?? 0)
    }

}
