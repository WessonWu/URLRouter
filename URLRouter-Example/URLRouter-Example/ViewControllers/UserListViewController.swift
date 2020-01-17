//
//  ViewController.swift
//  URLNavigatorExample
//
//  Created by Suyeol Jeon on 7/12/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import URLRouter

class UserListViewController: UIViewController {
    
    // MARK: Properties
    private let router: URLRouterType
    let users = [User(name: "apple", urlString: "router://user/apple"),
                 User(name: "google", urlString: "router://user/google"),
                 User(name: "facebook", urlString: "router://user/facebook"),
                 User(name: "alert", urlString: "router://alert?title=Hello&message=World"),
                 User(name: "fallback", urlString: "router://notMatchable"),
                 User(name: "AutoParse BuildInTypes", urlString: "router://parse/buildIn/Lebron James?age=23&height=203.5"),
                 User(name: "AutoParse CustomTypes", urlString: "router://parse/custom?player=Kobe Bryant"),
    ]
    
    
    // MARK: UI Properties
    
    let tableView = UITableView()
    
    
    // MARK: Initializing
    init(router: URLRouterType) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.title = "GitHub Users"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UserCell.self, forCellReuseIdentifier: "user")
    }
    
    
    // MARK: Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
}


// MARK: - UITableViewDataSource

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! UserCell
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.urlString
        cell.detailTextLabel?.textColor = .gray
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}


// MARK: - UITableViewDelegate

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let user = self.users[indexPath.row]
        
        let isPushed = self.router.push(user.urlString) != nil
        if isPushed {
            print("[URLRouter] push: \(user.urlString)")
        } else {
            print("[URLRouter] handle: \(user.urlString)")
            self.router.handle(user.urlString)
        }
    }
}
