//
//  SettingsViewController.swift
//  Health-Connect
//
//  Created by Haida, Makouangou on 2025-04-11.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    enum SettingType {
        case toggle(Bool)
        case navigation
    }
    
    struct SettingItem {
        let title: String
        var type: SettingType
    }
    
    var settings: [SettingItem] = [
        SettingItem(title: "Notification", type: .toggle(true)),
        SettingItem(title: "Calendar Sync", type: .toggle(false)),
        SettingItem(title: "Privacy", type: .navigation),
        SettingItem(title: "Preferences", type: .navigation)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let setting = settings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)

        cell.textLabel?.text = setting.title
        cell.selectionStyle = .none
        cell.accessoryView = nil
        cell.accessoryType = .none
        
        switch setting.type {
        case .toggle(let isOn):
            let toggleSwitch = UISwitch()
            toggleSwitch.isOn = isOn
            toggleSwitch.tag = indexPath.row
            toggleSwitch.addTarget(self, action: #selector(didToggleSwitch(_:)), for: .valueChanged)
            cell.accessoryView = toggleSwitch
        case .navigation:
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.row]
        
        switch setting.title {
        case "Privacy":
            print("Navigate to Privacy screen")
            // navigationController?.pushViewController(PrivacyViewController(), animated: true)
        case "Preferences":
            print("Navigate to Preferences screen")
            // navigationController?.pushViewController(PreferencesViewController(), animated: true)
        default:
            break
        }
    }
    
    @objc func didToggleSwitch(_ sender: UISwitch) {
        let index = sender.tag
        var setting = settings[index]
        
        if case .toggle(_) = setting.type {
            setting.type = .toggle(sender.isOn)
            settings[index] = setting
            print("\(setting.title) switched to \(sender.isOn)")
        }
    }
}
