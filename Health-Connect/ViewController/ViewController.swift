import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!

    var doctors: DoctorList = []
    var filteredDoctors: DoctorList = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDoctors()
        setup()
    }
    
    private func setup() {
        filteredDoctors = doctors
        tableView.dataSource = self
        setupSearchBarStyle()
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    private func setupSearchBarStyle() {
        // Rounded corners and background
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.borderWidth = 0.5
        searchTextField.layer.borderColor = UIColor.systemGray4.cgColor
        searchTextField.backgroundColor = UIColor.systemGray6
        searchTextField.textColor = .label
        searchTextField.tintColor = .systemBlue
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.leftViewMode = .always

        // Add left icon (search)
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .systemGray
        icon.contentMode = .center
        icon.frame = CGRect(x: 0, y: 0, width: 30, height: 20)

        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        iconContainer.addSubview(icon)
        icon.center = iconContainer.center

        searchTextField.leftView = iconContainer

        // Shadow
        searchTextField.layer.shadowColor = UIColor.black.cgColor
        searchTextField.layer.shadowOpacity = 0.05
        searchTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchTextField.layer.shadowRadius = 4

        // Placeholder style
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search doctors...",
            attributes: [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
    }

    
    func fetchDoctors() {
        let apiURL = "https://67f58a5b913986b16fa4f0a1.mockapi.io/api/doctor"
        NetworkingManager.shared.fetchData(from: apiURL) { (result: Result<DoctorList, Error>) in
            switch result {
            case .success(let response):
                self.doctors = response
                self.filteredDoctors = response
                self.tableView.reloadData()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }

        
    }
    
    @objc func searchTextChanged() {
            guard let searchText = searchTextField.text, !searchText.isEmpty else {
                filteredDoctors = doctors
                tableView.reloadData()
                return
            }
            
            filteredDoctors = doctors.filter {
                $0.name.lowercased().contains(searchText.lowercased()) || $0.specialization.lowercased().contains(searchText.lowercased())
            }

            tableView.reloadData()
        }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDoctors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath) as? DoctorCell else {
            return UITableViewCell()
        }

        let doctor = filteredDoctors[indexPath.row]
        cell.configure(with: doctor)  // Configure the cell with the doctor model
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedDoctor = filteredDoctors[indexPath.row]
        
        
        let doctorDetailVC = DoctorDetailViewController(doctor: selectedDoctor)
        
        
        navigationController?.pushViewController(doctorDetailVC, animated: true)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
