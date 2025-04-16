//
//  DoctorCell.swift
//  Health-Connect
//
//  Created by Haida, Makouangou on 2025-04-08.
//

import UIKit

class DoctorCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
        @IBOutlet weak var photoImageView: UIImageView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var specialtyLabel: UILabel!
        @IBOutlet weak var hospitalLabel: UILabel!
        @IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
           // Make the image circular
           photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
           photoImageView.clipsToBounds = true
           photoImageView.layer.borderWidth = 1
           photoImageView.layer.borderColor = UIColor.systemGray5.cgColor
           
           // Card-style background
           containerView.layer.cornerRadius = 12
           containerView.layer.shadowColor = UIColor.black.cgColor
           containerView.layer.shadowOpacity = 0.1
           containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
           containerView.layer.shadowRadius = 6
           containerView.backgroundColor = .systemBackground

           // Label Styling
           nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
           specialtyLabel.textColor = .systemBlue
           specialtyLabel.font = UIFont.systemFont(ofSize: 14)

           hospitalLabel.textColor = .darkGray
           locationLabel.textColor = .gray
       }
    
    func configure(with doctor: DoctorModel) {
              nameLabel.text = "👨‍⚕️ \(doctor.name)"
              specialtyLabel.text = "💼 \(doctor.specialization)"
              hospitalLabel.text = "🏥 \(doctor.hospital)"
              locationLabel.text = "📍 \(doctor.location)"
              
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

    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            UIView.animate(withDuration: 0.2) {
                self.containerView.backgroundColor = selected ? UIColor.systemGray5 : UIColor.systemBackground
            }
        }

}
