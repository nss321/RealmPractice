//
//  FolderViewController.swift
//  RealmPractice
//
//  Created by BAE on 3/5/25.
//

import UIKit

import RealmSwift

final class FolderViewController: UIViewController {
    private let tableView = UITableView()
    private var list: Results<Folder>!
    private let repository: FolderRepository = FolderTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureView()
        configureConstraints()
        list = repository.fetchAll()
        dump(list)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil, image: UIImage(systemName: "star.fill"), target: self, action: #selector(rightBarButtonItemClicked))
    }
    
    @objc func rightBarButtonItemClicked() {
        let vc = MainViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureConstraints() {
         
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id) as! ListTableViewCell
        
        let data = list[indexPath.row]
        cell.titleLabel.text = data.name
        cell.subTitleLabel.text = "\(data.detail.count)개"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = list[indexPath.row]
        repository.createMemo(data: data)
        tableView.reloadData()
        
        // 폴더 삭제
        // 폴더 지울 때 세부 항목도 지울 것인지?
        // 폴더 지울 때 세부 항목을 다른 폴더로 이동해 줄 것인지?
//        let data = list[indexPath.row]
//        repository.deleteItem(data: data)
//        tableView.reloadData()
        
        
        // 화면 전환
//        let data = list[indexPath.row]
//        let vc = FolderDetailViewController()
//        vc.list = data.detail
//        vc.id = data.id
//        self.navigationController?.pushViewController(vc, animated: true)
    }
      
}
