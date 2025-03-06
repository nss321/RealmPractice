//
//  FolderRepository.swift
//  RealmPractice
//
//  Created by BAE on 3/5/25.
//

import Foundation

import RealmSwift

protocol FolderRepository {
    func createItem(name: String)
    func fetchAll() -> Results<Folder>
    func deleteItem(data: Folder)
    func createMemo(data: Folder)
}

final class FolderTableRepository: FolderRepository {
    private let realm = try! Realm()
    
    func createMemo(data: Folder) {
        let memo = Memo()
        memo.content = "메모 콘텐츠"
        memo.regDate = Date()
        memo.editData = Date()
        
        do {
            try realm.write {
                data.memo = memo
            }
        } catch {
            print("메모 추가 실페")
        }
    }
    
    func deleteItem(data: Folder) {
        do {
            try realm.write {
                realm.delete(data.detail) // 하위 항목까지 제거
                realm.delete(data)
            }
        } catch {
            print("폴더 삭제 실패")
        }
    }
    
    func createItem(name: String) {
        do {
            try realm.write {
                let folder = Folder(name: name)
                realm.add(folder)
            }
        } catch {
            print("폴더 저장 실패")
        }
    }
    
    func fetchAll() -> Results<Folder> {
        return realm.objects(Folder.self)
    }
}
