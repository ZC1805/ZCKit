//
//  PageSwiftVC.swift
//  ZCTest
//
//  Created by zjy on 2022/2/23.
//

import UIKit

class PageSwiftVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var listView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI();
    }
    
    func initUI() -> Void {
        navigationItem.title = "swift-page"
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = .all
        
        listView = UITableView.init(frame: view.bounds, style: .grouped)
        listView?.dataSource = self
        listView?.delegate = self
        listView?.backgroundColor = .clear
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        headerView.backgroundColor = .orange
        listView?.tableHeaderView = headerView
        if let lview = listView { //可选绑定
            view.addSubview(lview)
        }
        
        let addBtn = UIButton.init(type: .custom)
        addBtn.frame = CGRect(x: (view.frame.size.width - 120)/2, y: (listView?.frame.height ?? 0) - 80.0, width: 120, height: 50)
        addBtn.addTarget(self, action: #selector(onAdd(sender:)), for: .touchUpInside)
        addBtn.layer.cornerRadius = 10
        addBtn.backgroundColor = .white
        addBtn.setTitle("Add", for: .normal)
        addBtn.setTitleColor(.red, for: .normal)
        addBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(addBtn)
        
        
        print(test()(10))
        
        
        
        
    }
    
    
    func test() -> (Int) -> Int {
        var a = 10
        
        let onBlock = { [a] (x: Int) -> Int in
            x + a
        }
        
        a = 20
        return onBlock
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 1 ? 3 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }
        //cell?.textLabel?.text = "row index is \(indexPath.row)"
        cell?.textLabel?.text = String(format: "index is %03ld", indexPath.row)
        return cell!
    }
    
    @objc func onAdd(sender: UIButton) {
        //print(sender.title(for: .normal) ?? "nil")
        self.present(UIViewController.init(), animated: true) {
            print("present")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}


struct Dict<K: Hashable, V> {
    var a: Int
}
