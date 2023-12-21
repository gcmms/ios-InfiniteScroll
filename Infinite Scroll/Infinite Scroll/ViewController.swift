//
//  ViewController.swift
//  Infinite Scroll
//
//  Created by Gabriel Chirico Mahtuk de Melo Sanzone on 20/12/23.
//

import UIKit
import UIScrollView_InfiniteScroll

class ViewController: UIViewController {

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    let service = APICaller.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        setUpDataBindings()
    }

    func setUpDataBindings() {
        service.fetchData { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        tableView.infiniteScrollDirection = .vertical
        tableView.addInfiniteScroll { [weak self] table in
            self?.service.loadMorePosts { [weak self] moreData in
                DispatchQueue.main.async {
                    let startIndex = Int((moreData.first?.components(separatedBy: " ").last)!)
                    let start = startIndex-1
                    let end = start + moreData.count
                    let indices = Array(start...end).compactMap({
                        return IndexPath(item: $0, section: 0)
                    })
                }
                self?.tableView.reloadData()
                self?.tableView.finishInfiniteScroll()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "oi"
        return cell
    }
    

}
