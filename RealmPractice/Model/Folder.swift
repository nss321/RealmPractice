//
//  Folder.swift
//  RealmPractice
//
//  Created by BAE on 3/5/25.
//

import Foundation

import RealmSwift

class User: Hashable, Equatable {
    let id = UUID()
    let name: String
    let age: Int
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

class Memo: EmbeddedObject {
    @Persisted var content: String
    @Persisted var regDate: Date
    @Persisted var editData: Date
}

final class Folder: Object {
    @Persisted var id: ObjectId
    @Persisted var name: String
    @Persisted var favorite: Bool
    @Persisted var like2: Bool
    @Persisted var nameDescription: String
    
    // 1:1, to one relationship
    @Persisted var memo: Memo?
    
    // 1:N, to many relationship
    @Persisted var detail: List<HouseholdLedger>
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
