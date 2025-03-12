//
//  RealmModel.swift
//  SeSAC6Database
//
//  Created by BAE on 3/4/25.
//

import Foundation
import RealmSwift

final class HouseholdLedger: Object {
    /*
     1. 금액
     2. 카테고리
     3. 제목
     4. 수입/지출
     6. 내용
     */
    // 기본키, 중복X, 공백X, index embedded
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var money: Int
    @Persisted var category: String
    @Persisted(indexed: true) var content: String
    @Persisted var isIncome: Bool
    @Persisted var memo: String?
    @Persisted var regDate: Date
    @Persisted var isLiked: Bool
    
    @Persisted(originProperty: "detail")
    var folder: LinkingObjects<Folder>
    
    convenience init(money: Int, category: String, content: String, isIncome: Bool, memo: String?, regDate: Date, isLiked: Bool) {
        self.init()
        self.money = money
        self.category = category
        self.content = content
        self.isIncome = isIncome
        self.memo = memo
        self.regDate = regDate
        self.isLiked = isLiked
    }
}
