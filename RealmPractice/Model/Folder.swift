//
//  Folder.swift
//  RealmPractice
//
//  Created by BAE on 3/5/25.
//

import Foundation

import RealmSwift

final class Folder: Object {
    @Persisted var id: ObjectId
    @Persisted var name: String
    
    // 1:N, to many relationship
    @Persisted var detail: List<HouseholdLedger>
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
