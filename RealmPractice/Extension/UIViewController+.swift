//
//  UIViewController+.swift
//  RealmPractice
//
//  Created by BAE on 3/7/25.
//

import UIKit

extension UIViewController {
    func saveImageToDocument(image: UIImage, filaname: String) {
        // 도큐먼트 폴더 위치
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 이미지를 저장할 경로(파일명까지) 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filaname).jpg")

        // 이미지 용량 줄이기: 압축, 해상도 조절, 리사이징, 다운 샘플링
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        
        // 실제 저장하려는 이미지 파일
        do {
            try data.write(to: fileURL)
        } catch {
            print("이미지 저장 실패")
            // 언제 실패할까?
            // 1. 용량 부족할 때
            // 2. 경로에 문제가 있을 때?
        }
    }
    
    func loadImageFromDocument(filename: String) -> UIImage? {
        // 도큐먼트 위치 확인
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return UIImage(systemName: "xmark")
        }
        
        // 이미지 파일 경로를 확인
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        // 이 경로에 실제로 파일이 존재하느닞도 체크
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return UIImage(systemName: "xmark")
        }
    }
    
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            
            do {
                try FileManager.default.removeItem(atPath: fileURL.path())
            } catch {
                print("file remove error", error)
            }
            
        } else {
            print("file no exist")
        }
        
    }
}
