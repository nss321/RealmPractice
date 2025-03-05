//
//  RealmTableRepository.swift
//  RealmPractice
//
//  Created by BAE on 3/5/25.
//

import Foundation
import RealmSwift

final class RealmTableRepository {
    private let realm = try! Realm()
    // tmi -> get, fetch, request 뭐가 적절한지? 스스로 정리해보기
    func getFileURL() {
        print(realm.configuration.fileURL)
    }
    
    func fetchAll() -> Results<HouseholdLedger> {
        let data = realm.objects(HouseholdLedger.self)
            .where { $0.content.contains("sesa", options: .caseInsensitive)}
            .sorted(byKeyPath: "money", ascending: true)
        return data
    }
    
    func createItem() {
        do {
            try realm.write {
                let data = HouseholdLedger(
                    money: .random(in: 1...1000) * 1000,
                    category: ["카페", "생활비", "식비", "잡비"].randomElement()!,
                    content: ["점심", "커피", "칫솔", "주유"].randomElement()!,
                    isIncome: true,
                    memo: "커피",
                    regDate: .now,
                    isLiked: false
                )
                realm.add(data)
                print("렐름 저장 완료")
            }
        } catch {
            print("렐름에 저장 실패")
        }
    }
    
    func deleteItem(data: HouseholdLedger) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("렐름 삭제 실패")
        }
    }
    
    func updateItem(data: HouseholdLedger) {
        do {
            try realm.write {
                realm.create(HouseholdLedger.self, value: [
                    "id": data.id,
                    "money": 10000000000
                ], update: .modified)
            }
        } catch {
            print("렐름 수정 실패")
        }
    }
}
