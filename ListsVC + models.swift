//
//  ListsVC + models.swift
//  employee
//
//  Created by Ahmed on 3/17/21.
//

import Foundation

//MARK:- vacation
class VacationSERModel: Codable{
    var status_code, error_message: String?
    var data: [VacationSERDataModel]?
}

class VacationSERDataModel: Codable{
    var vtype_id,
    vtype_name,
    vacbalance: String?
    
    var other: [VacationSEROtherDataModel]?
}

class VacationSEROtherDataModel: Codable{
    var sociltype_id,
    sociltype_name,
    socilbalance: String?
}


//MARK:- mandate
class MandateSERModel: Codable{
    var status_code, error_message: String?
    var data: [MandateSERDataModel]?
}

class MandateSERDataModel: Codable{
    var mandate_id,
        mandate_name: String?
}


//MARK:- administration
class AdministrationSERModel: Codable{
    var status_code, error_message: String?
    var data: [AdministrationSERDataModel]?
}

class AdministrationSERDataModel: Codable{
    var request_id,
        request_name: String?
}
