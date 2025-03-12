//
//  BackUpViewController.swift
//  RealmPractice
//
//  Created by BAE on 3/10/25.
//

import UIKit

import Zip

final class BackUpViewController: UIViewController {
    
    private let backupButton = {
        let view = UIButton()
        view.backgroundColor = .systemOrange
        return view
    }()
    
    private let restoreButton = {
        let view = UIButton()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    private let backupTableView = {
        let view = UITableView()
        view.rowHeight = 50
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        setConstraints()
    }
    
    func configure() {
        view.addSubview(backupTableView)
        view.addSubview(backupButton)
        view.addSubview(restoreButton)
        
        backupTableView.delegate = self
        backupTableView.dataSource = self
        
        backupButton.addTarget(self, action: #selector(backupButtonTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
    }
    
    func setConstraints() {
        backupTableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        backupButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        return documentDirectory
    }
    
    @objc
    func backupButtonTapped() {
        print(#function)
        // document file -> zip
        // 도큐먼트 위치 조회
        // 백업할 파일을 조회
        // 백업할 파일을 압축 파일로 묶는작업
        guard let path = documentDirectoryPath() else {
            print("도큐먼ㅌ 위치에 오류가 있습니다.")
            return
        }
        
        // 백업할 파일을 조회(e.g. default, realm)
        let realmFile = path.appendingPathComponent("default.realm")
        
        // 백업할 파일 경로가 유효한지 확인
        guard FileManager.default.fileExists(atPath: realmFile.path()) else {
            print("백업할 파일이 없습니다.")
            return
        }
        
        // 압축하고자 하는 파일을 urlPath에 추가
        var urlPaths = [URL]()
        urlPaths.append(realmFile)
        
        // 백업할 파일을 압축 팡닐로 묶는 작업
        do {
            
            let filePath = try Zip.quickZipFiles(urlPaths, fileName: "SeanArchive") { progress in
                print(progress)
            }
            print("Zip location: ", filePath)
        } catch {
            print("백업에 실패했어요")
            // 기기 용량 부족, 화면 dismiss, 다른 탭 전환, 백그라운드
        }
    }
    
    @objc
    func restoreButtonTapped() {
        print(#function)
        let documment = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documment.delegate = self
        documment.allowsMultipleSelection = false
        present(documment, animated: true)
        
    }
}

extension BackUpViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // 파일앱 경로
        guard let selectedFileURL = urls.first else {
            print("선택한 파일에 오류가 있습니다.")
            return
        }
        
        // 파일앱 데이터 -> 도큐먼트 폴더로 ㄴ넣기
        guard let path = documentDirectoryPath() else {
            return
        }
        
        // 도큐먼트 폴더 내에 저장할 경로 설정
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        // 압축 파일을 저장하고, 풀면 됨
        // 이미 경로에 파일이 존재하는지 확인 -> 압축 바로 해제
        // 경로에 파일이 존재하지 않는다면 -> 파일 앱의 압축 파일 -> 도큐먼트 경로로 복사 -> 도큐먼트에 저장 -> 저장된 압축 파일을 해제
        if FileManager.default.fileExists(atPath: sandboxFileURL.path()) {
            let fileURL = path.appendingPathComponent("SeanArchive.zip")
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil) { progress in
                    print("progress", progress)
                } fileOutputHandler: { unzippedFile in
                    print("압축해제 완료", unzippedFile)
                }

            } catch {
                print("압축 해제 실패")
            }
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
            } catch {
                print("파일 copy 실패, 압축 해제 실패")
            }
        }
    }
}

/*
 Todo.
 - 사진 데이터가 백업이 되고 있지 않은 상태
 - 백업 압축 파일에 default.realm만 있는 상황
 - 폴더 기반으로 이미지 저장
 
 - 백업 파일명, 내부 폴더 구조
 - Sean_날짜_초단위.zip
 - default.realm
 
 - 백업본A. 근데 까먹고 새로 설치한 앱에 데이터를 많이 쌓아두었다
 - 그리고 나중에 알게됨 -> 덮어 써진다!
 - defailt.realm -> 앱을 처음 실행해야만 동작. 루트 뷰 바꿔도 안됨.
 -> json 형태로 백업/복구하면 런타임에서 적용 가능
 
 - 도큐먼트나 파일앱을 다룰 때, info.plist에서 어떤값을 설정하라는 블로그가 많음.
    - 도큐먼트 폴더는 개발자가 다루는 영역
    - 근데 ? 설정이나 파일앱에 띄울 수 있음 -> 사용자도 접근할 수 있음
    - 그래서 라이브러리 폴더로 옮겨버리거나, 비번을 거는 경우도 있음.
    - 라이브러리 폴더로 옮기면 let realm = try! Realm()은 동작하지 않음
 */
extension BackUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func fetchZipList() -> [String] {
        // 도큐먼트 위치 조회
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다.")
            return[]
        }
        
        var list: [String] = []
        // 도큐먼트 폴더내의 컨텐츠들 조회 zip filter
        do {
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
//            dump(docs)
            let zip = docs.filter { $0.pathExtension == "zip" }
//            dump(zip)
            list = zip.map { $0.lastPathComponent }
//            dump(last)
            
            
        } catch(let error) {
            print("도큐먼트 폴더 내의 컨텐츠 조회 실패")
            print(error)
        }
        
        return list
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchZipList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        cell.textLabel?.text = ["1","2"][indexPath.row]
        cell.textLabel?.text = fetchZipList()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ~~/SeanArchive.zip 구성이 되어있는 파일을 외부로 보내기
        
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let backupFileURL = path.appendingPathComponent(fetchZipList()[indexPath.row])
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: nil)
        present(vc, animated: true)
    }
}
