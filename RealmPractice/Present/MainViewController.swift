//
//  MainViewController.swift
//  SeSAC6Database
//
//  Created by Jack on 3/4/25.
//

import UIKit

import SnapKit
import RealmSwift

class MainViewController: UIViewController {

    let tableView = UITableView()
    
    var list: Results<HouseholdLedger>!
    
    let repository = RealmTableRepository()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        print(repository.getFileURL())
        configureHierarchy()
        configureView()
        configureConstraints()
        
        list = repository.fetchAll()
        
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
    }
    
    private func configureView() {
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
         
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
        cell.titleLabel.text = data.content
        cell.subTitleLabel.text = data.memo
        cell.overviewLabel.text = "\(data.money)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let data = list[indexPath.row]
        repository.deleteItem(data: data) // realm write
        tableView.reloadData()

    }
      
    
}
