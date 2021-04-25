//
//  ListsPresenter.swift
//  employee
//
//  Created by Ahmed on 3/17/21.
//

import Foundation

/// list types that will this class display it depends on API requests
enum ListsTypes{
    case vacations,
         otherVacations,
         mandates,
         administiartion
    
}

protocol ListsView: class{
    
    /// tell the view that the data is successfully featched
    func dataFeatchedSuccessfully()
    
    /// tell the view that some errors happend when featching the data
    func errorWhenFeatcheingDate()
    
    /// submit the data to the view to transfer ir to the parent viwew that uses this list
    /// - Parameters:
    ///   - id: the id pof the selected row
    ///   - name: the title of the item that he selected to show it in the list placeHol;der
    ///   - available: the available days and its optional because there is lists did not contains this property
    func submit(id: String, name: String, available: String?)
}

class ListsPresenter{
    //MARK:- variables
    private var view: ListsView?
    
    private let User = UserModel()
    private let API = Requests()
    
    //typesModels
    private var vacations = [VacationSERDataModel]()
    private var othreVacations = [VacationSEROtherDataModel]()
    private var mandates = [MandateSERDataModel]()
    private var administraration = [AdministrationSERDataModel]()
    
    
    
    //MARK:- initialization
    init(view: ListsView){
        self.view = view
    }
    
    //MARK:- functions
    func viewdidload(type: ListsTypes, Date: Int64? = nil){
        switch type {
        case .vacations, .otherVacations:
            getVacationTypes(of: Date, type: type)
            break
            
        case .mandates:
            getMandateTypes(of: Date)
            break
        
        case .administiartion:
            getAdministrationSer()
            break
        }
    }
    
    //MARK:- vacations
    private func getVacationTypes(of date: Int64?, type: ListsTypes){
        API.getvacationServices(userID: User.getID(),
                                date: date?.convertDate(formate: "yyyy-MM-dd", language: "en") ?? "") { [weak self] (result, statusCode) in
    guard let self = self else { return }
            switch result{
            case .success(let model):
                self.vacations = model.data ?? []
                if type != .vacations{
                    self.vacations.forEach { (item) in
                        if item.vtype_id == "8"{
                            self.othreVacations = item.other ?? []
                        }
                    }
                }
                
                self.view?.dataFeatchedSuccessfully()
                break
                
            case .failure(_):
                self.view?.errorWhenFeatcheingDate()
                break
            }
        }
    }
    
    
    //MARK:- mandate
    private func getMandateTypes(of date: Int64?){
        API.getmandateServices(userID: User.getID()) { [weak self] (result, statusCode) in
    guard let self = self else { return }
            switch result{
            case .success(let model):
                self.mandates = model.data ?? []
                
                self.view?.dataFeatchedSuccessfully()
                break
                
            case .failure(_):
                self.view?.errorWhenFeatcheingDate()
                break
            }
        }
    }
    
    //MARK:- getAdministrationServices
    private func getAdministrationSer(){
        API.getAdministrationServices { [weak self] (result, statusCode) in
    guard let self = self else { return }
            switch result{
            case .success(let model):
                self.administraration = model.data ?? []
                
                self.view?.dataFeatchedSuccessfully()
                break
                
            case .failure(_):
                self.view?.errorWhenFeatcheingDate()
                break
            }
        }
    }
    
    
    //MARK:- picker functions
    func getRowsNumber(type: ListsTypes) -> Int{
        switch type {
        case .vacations:
            return vacations.count
            
        case .otherVacations:
            return othreVacations.count
            
        case .mandates:
            return mandates.count
            
        case .administiartion:
            return administraration.count
        }
    }
    
    func getRowTitle(type: ListsTypes, at row: Int) -> String{
        switch type {
        case .vacations:
            return vacations[row].vtype_name ?? ""
            
        case .otherVacations:
            return othreVacations[row].sociltype_name ?? ""
            
        case .mandates:
            return mandates[row].mandate_name ?? ""
        
        case .administiartion:
            return administraration[row].request_name ?? ""
        }
    }
    
    func getTypedata(type: ListsTypes, of row: Int){
        switch type {
        case .vacations:
            let obj = vacations[row]
            view?.submit(id: obj.vtype_id ?? "0",
                         name: obj.vtype_name ?? "",
                         available: obj.vacbalance ?? "0")
            break
            
        case .otherVacations:
            let obj = othreVacations[row]
            view?.submit(id: obj.sociltype_id ?? "0",
                         name: obj.sociltype_name ?? "",
                         available: obj.socilbalance ?? "0")
            break
        
        case .mandates:
            let obj = mandates[row]
            view?.submit(id: obj.mandate_id ?? "0",
                         name: obj.mandate_name ?? "",
                         available: nil)
        break
            
        case .administiartion:
            let obj = administraration[row]
            view?.submit(id: obj.request_id ?? "0",
                         name: obj.request_name ?? "",
                         available: nil)
            break
        }
    }
    
    
}
