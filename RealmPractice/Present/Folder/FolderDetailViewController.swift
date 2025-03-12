//
//  FolderDetailViewController.swift
//  RealmPractice
//
//  Created by BAE on 3/5/25.
//

import UIKit

import RealmSwift

final class FolderDetailViewController: UIViewController {

    private let tableView = UITableView()
    
    var list: List<HouseholdLedger>!
    var id: ObjectId?
    
    private let repository: RealmRepository = RealmTableRepository()
    private let folderRepository: FolderRepository = FolderTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        print(repository.getFileURL())
        configureHierarchy()
        configureView()
        configureConstraints()
        print(list)
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
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension FolderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.thumbnailImageView.image = loadImageFromDocument(filename: "\(data.id)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = list[indexPath.row]
        removeImageFromDocument(filename: "\(data.id)")
        repository.deleteItem(data: data)
        tableView.reloadData()

    }
}
