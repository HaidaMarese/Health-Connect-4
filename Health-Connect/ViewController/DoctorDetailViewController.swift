//
//  DoctorDetailViewController.swift
//  Health-Connect
//
//  Created by Haida, Makouangou on 2025-04-09.
//

import UIKit

class DoctorDetailViewController: UIViewController {
    
    var doctor: DoctorModel?
    var availableSlots: [String] = []
    var selectedTimeSlot: String? // To store the selected time slot
    var bookedTimeSlots: [String] = [] // To store booked time slots for the current doctor
    var selectedIndexPath: IndexPath?
    
    // UI Elements
    var nameLabel: UILabel!
    var specializationLabel: UILabel!
    var hospitalLabel: UILabel!
    var locationLabel: UILabel!
    var photoImageView: UIImageView!
    var timeSlotTableView: UITableView!
    var confirmButton: UIButton! // Button to confirm the appointment
    var cancelButton: UIButton!  // Button to cancel appointment
    
    // MARK: - Initializer
    init(doctor: DoctorModel) {
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureWithDoctor()
        loadBookedTimeSlots() // Load the booked slots for the specific doctor
        generateRandomTimeSlots()
        setupRightBarButton()
    }
    
    // MARK: - Setup Right Bar Button
       private func setupRightBarButton() {
           let rightButton = UIBarButtonItem(title: "Appointments", style: .plain, target: self, action: #selector(navigateToAppointments))
           self.navigationItem.rightBarButtonItem = rightButton
       }
       
       // MARK: - Navigation to Appointments View
       @objc private func navigateToAppointments() {
           guard let doctorID = doctor?.id else { return }
           let appointmentsVC = AppointmentsViewController()
           appointmentsVC.doctorID = doctorID // Pass the doctorID to the next screen
           // Navigate to the AppointmentsViewController
           self.navigationController?.pushViewController(appointmentsVC, animated: true)
       }
    
    // MARK: - Setup UI
    private func setupUI() {
        nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        specializationLabel = UILabel()
        specializationLabel.font = .systemFont(ofSize: 18)
        specializationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(specializationLabel)
        
        hospitalLabel = UILabel()
        hospitalLabel.font = .systemFont(ofSize: 18)
        hospitalLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hospitalLabel)
        
        locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 18)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationLabel)
        
        photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 75
        photoImageView.clipsToBounds = true
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        
        timeSlotTableView = UITableView()
        timeSlotTableView.register(UITableViewCell.self, forCellReuseIdentifier: "timeSlotCell")
        timeSlotTableView.dataSource = self
        timeSlotTableView.delegate = self
        timeSlotTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeSlotTableView)
        
        confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm Appointment", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmAppointment), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.isEnabled = false // Initially, disable the button until a slot is selected
        view.addSubview(confirmButton)
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel Appointment", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAppointment), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.isEnabled = false // Initially, disable the cancel button
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 150),
            photoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            specializationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            specializationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hospitalLabel.topAnchor.constraint(equalTo: specializationLabel.bottomAnchor, constant: 10),
            hospitalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: hospitalLabel.bottomAnchor, constant: 10),
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timeSlotTableView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            timeSlotTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timeSlotTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timeSlotTableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -20),
            
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
            
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureWithDoctor() {
        guard let doctor = doctor else { return }
        nameLabel.text = doctor.name
        specializationLabel.text = "Specialization: \(doctor.specialization)"
        hospitalLabel.text = "Hospital: \(doctor.hospital)"
        locationLabel.text = "Location: \(doctor.location)"
        
        if let url = URL(string: doctor.photo) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.photoImageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    private func loadBookedTimeSlots() {
        // Fetch booked slots for the specific doctor from UserDefaults
        if let doctorID = doctor?.id {
            let key = "bookedTimeSlots_\(doctorID)"
            if let savedBookedSlots = UserDefaults.standard.array(forKey: key) as? [String] {
                bookedTimeSlots = savedBookedSlots
            }
        }
    }
    
    private func generateRandomTimeSlots() {
        availableSlots = [
            "09:00 AM - 10:00 AM",
            "10:00 AM - 11:00 AM",
            "11:00 AM - 12:00 PM",
            "01:00 PM - 02:00 PM",
            "02:00 PM - 03:00 PM"
        ]
        
        timeSlotTableView.reloadData()
    }
    
    @objc private func confirmAppointment() {
        guard let selectedTimeSlot = selectedTimeSlot else { return }
        
        // Save the selected time slot to the booked list for the specific doctor
        if let doctorID = doctor?.id {
            let key = "bookedTimeSlots_\(doctorID)"
            bookedTimeSlots.append(selectedTimeSlot)
            UserDefaults.standard.set(bookedTimeSlots, forKey: key)
        }
        
        // Handle appointment confirmation (e.g., show confirmation message)
        print("Appointment Confirmed for \(selectedTimeSlot)")
        
        let alert = UIAlertController(title: "Appointment Confirmed", message: "Your appointment with Dr. \(doctor?.name ?? "") has been scheduled for \(selectedTimeSlot).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        generateRandomTimeSlots()
    }
    
    @objc private func cancelAppointment() {
        guard let selectedTimeSlot = selectedTimeSlot else { return }
        
        if let doctorID = doctor?.id {
            let key = "bookedTimeSlots_\(doctorID)"
            bookedTimeSlots.removeAll { $0 == selectedTimeSlot }
            UserDefaults.standard.set(bookedTimeSlots, forKey: key)
        }
        
        // Show an alert to confirm the cancellation
        let alert = UIAlertController(title: "Appointment Canceled", message: "Your appointment for \(selectedTimeSlot) has been canceled.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        generateRandomTimeSlots()
    }
    
    private func rescheduleAppointment(for slot: String) {
        // Handle rescheduling logic
        if let currentIndex = bookedTimeSlots.firstIndex(of: selectedTimeSlot ?? "") {
            bookedTimeSlots[currentIndex] = slot
            UserDefaults.standard.set(bookedTimeSlots, forKey: "bookedTimeSlots_\(doctor?.id ?? "")")
            
            // Show confirmation
            let alert = UIAlertController(title: "Appointment Rescheduled", message: "Your appointment has been rescheduled to \(slot).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
    }
}

extension DoctorDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeSlotCell", for: indexPath)
            
            let timeSlot = availableSlots[indexPath.row]
            cell.textLabel?.text = timeSlot
            
            // Check if this slot is selected
            if selectedTimeSlot == timeSlot {
                cell.accessoryType = .checkmark  // Show checkmark if selected
            } else {
                cell.accessoryType = .none  // Remove checkmark if not selected
            }
            
            // Change text color if the slot is booked
            if bookedTimeSlots.contains(timeSlot) {
                cell.textLabel?.textColor = .red // Slot is booked
                cell.accessoryType = .none // No checkmark for booked slots
            } else {
                cell.textLabel?.textColor = .black // Slot is available
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedSlot = availableSlots[indexPath.row]
            
            if bookedTimeSlots.contains(selectedSlot) {
                // If the slot is booked, show an alert
                let alert = UIAlertController(title: "Slot Already Booked", message: "This slot is already booked. Do you want to reschedule or cancel?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel Appointment", style: .destructive, handler: { _ in
                    self.cancelAppointment()
                }))
                alert.addAction(UIAlertAction(title: "Reschedule", style: .default, handler: { _ in
                    self.rescheduleAppointment(for: selectedSlot)
                }))
                present(alert, animated: true)
            } else {
                // If the slot is available, select it and enable the confirm button
                selectedTimeSlot = selectedSlot
                confirmButton.isEnabled = true
                cancelButton.isEnabled = true
                tableView.reloadData() // Reload the table to show the updated checkmark
            }
        }
        
    
    
}
