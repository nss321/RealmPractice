//
//  MainViewController.swift
//  SeSAC6Database
//
//  Created by Jack on 3/4/25.
//

import UIKit

import FSCalendar
import SnapKit
import RealmSwift

final class MainViewController: UIViewController {

    private let tableView = UITableView()
    let calendar = FSCalendar()
    
    var list: Results<HouseholdLedger>!
    
    private let repository: RealmRepository = RealmTableRepository()
    private let folderRepository: FolderRepository = FolderTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        folderRepository.createItem(name: "션")
//        folderRepository.createItem(name: "립우")
//        folderRepository.createItem(name: "맹고")
//        folderRepository.createItem(name: "먀")
        
        print(#function)
        print(repository.getFileURL())
        configureHierarchy()
        configureView()
        configureConstraints()
        
        list = repository.fetchAll()
        print(list)
        
        // Results 타입이 아니라 Array 타입으로 사용하고 싶을때
//        let data = realm.objects(HouseholdLedger.self)
//        let value = Array(data)
        
        // 필터
//            .where { $0.content.contains("sesa", options: .caseInsensitive)}
//            .sorted(byKeyPath: "money", ascending: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
//        let data = realm.objects(HouseholdLedger.self)
//        let value = Array(data)
        tableView.reloadData()
    }
    
    private func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(calendar)
    }
    
    private func configureView() {
        calendar.backgroundColor = .systemGreen
        calendar.delegate = self
        calendar.dataSource = self
        
        view.backgroundColor = .white
        tableView.rowHeight = 130
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
          
        let image = UIImage(systemName: "plus")
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
        navigationItem.rightBarButtonItem = item
    }
    
    private func configureConstraints() {
        calendar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(250)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
     
    @objc func rightBarButtonItemClicked() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id) as! ListTableViewCell
        
        let data = list[indexPath.row]
        cell.titleLabel.text = "\(data.content), \(data.category)"
        cell.subTitleLabel.text = "\(data.folder)"
        cell.overviewLabel.text = "\(data.money)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = list[indexPath.row]
        repository.deleteItem(data: data) // realm write
        tableView.reloadData()

    }
}

extension MainViewController: FSCalendarDataSource, FSCalendarDelegate {
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        print(date)
//        return 2
//    }
//    
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        
//    }
//    
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        UIImage(systemName: "heart")
//    }
//    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        "따이뜰"
//    }
//    
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        "싸부따이뜰"
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(#function, date)
        
        // 선택한 날짜
        let start = Calendar.current.startOfDay(for: date)
        
        // 선택한 날짜의 다음날 날짜
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        
        let name = "식비"
        // Realm where filter, iOS NSPredicate
        let predicate = NSPredicate(format: "regDate >= %@ && regDate < %@",
                                    start as NSDate, end as NSDate)
        
        let realm = try! Realm()
        
        let result = realm.objects(HouseholdLedger.self).filter(predicate)
        
        dump(result)
//        start <= date < end
    }
}
