//
//  AppDelegate.swift
//  SeSAC6Database
//
//  Created by Jack on 3/4/25.
//

import UIKit

import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 현재 사용자가 쓰고 있는 DB Schema Version
        migration()
        let realm = try! Realm()
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version, ", version)
        } catch {
            print("Schema Failed")
        }
        
        
        return true
    }
    
    func migration() {
        let config = Realm.Configuration(schemaVersion: 6) { migration, oldSchemaVersion in
            // 0 -> 1: like 삭제
            if oldSchemaVersion < 1 {
                
            }
            
            // 1 -> 2: Folder에 like 추가
            if oldSchemaVersion < 2 {
                
            }
            
            // 2 -> 3: like2 추가
            if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: HouseholdLedger.className()) { oldObject, newObject in
                    guard let newObject = newObject else {
                        return
                    }
                    newObject["like2"] = true
                }
            }
            
            // 3 -> 4: Folder like를 favorite으로 변경
            if oldSchemaVersion < 4 {
                migration.renameProperty(onType: HouseholdLedger.className(), from: "like", to: "favorite")
            }

            // 4 -> 5: Folder nameDescription 추가
            if oldSchemaVersion < 5 {
                migration.enumerateObjects(ofType: Folder.className()) { oldObject, newObject in
                    guard let oldObejct = oldObject else { return }
                    guard let newObject = newObject else { return }
                    newObject["nameDescription"] = "\(oldObejct["name"] ?? "") 폴더에 대해서 설명해주세요."
                }
            }
            
            // 5 -> 6: Folder EmbeddeddObject 추가
            if oldSchemaVersion < 6 {
            }
            
        }
        Realm.Configuration.defaultConfiguration = config
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

