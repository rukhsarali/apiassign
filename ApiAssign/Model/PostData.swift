//
//  PostData.swift
//  ApiAssign
//
//  Created by Rukhsar on 19/08/2020.
//  Copyright © 2020 Rukhsar. All rights reserved.
//

import Foundation
struct PostData : Codable {
    var response : Holidays
}

struct Holidays : Codable {
    var holidays : [holidaysDetails]
}

struct holidaysDetails : Codable {
    var name: String
    var description : String
}
