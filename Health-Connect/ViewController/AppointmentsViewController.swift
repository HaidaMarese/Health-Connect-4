//
//  ProfileViewController.swift
//  Health-Connect
//
//  Created by Haida, Makouangou on 2025-04-08.
//

import UIKit




import UIKit

class AppointmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allAppointments: [String] = []
    var doctorID: String?
    var timeSlotTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationItem.title = "Appointments"
        // Setup UI components
        setupTableView()
        
        // Load appointments
        loadAppointments()
    }
    
    // MARK: - Setup Table View
    private func setupTableView() {
        timeSlotTableView = UITableView()
        timeSlotTableView.delegate = self
        timeSlotTableView.dataSource = self
        timeSlotTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimeSlotCell")
        
        view.addSubview(timeSlotTableView)
        
        // Set up constraints for tableView
        timeSlotTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeSlotTableView.topAnchor.constraint(equalTo: view.topAnchor),
            timeSlotTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            timeSlotTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            timeSlotTableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    // MARK: - Load Appointments
    private func loadAppointments() {
        // Assuming Doctor ID is passed or available
        guard let doctorID = doctorID else { return }
        
        
        let key = "bookedTimeSlots_\(doctorID)"
        if let savedBookedSlots = UserDefaults.standard.array(forKey: key) as? [String] {
            allAppointments = savedBookedSlots
        }
        
        // Reload the tableView to display updated data
        timeSlotTableView.reloadData()
    }
    
    // MARK: - Table View Data Source & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Only one section for all appointments
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAppointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSlotCell", for: indexPath)
        
        let appointment = allAppointments[indexPath.row]
        
        cell.textLabel?.text = appointment
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Appointments"
    }
}
