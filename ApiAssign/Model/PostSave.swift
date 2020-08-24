//
//  PostSave.swift
//  ApiAssign
//
//  Created by Rukhsar on 20/08/2020.
//  Copyright © 2020 Rukhsar. All rights reserved.
//

import Foundation
import RealmSwift

class PostSave : Object {
    @objc dynamic var nameSave : String = ""
    @objc dynamic var descriptionSave: String = ""
}

