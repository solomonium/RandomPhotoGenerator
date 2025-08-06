//
//  ViewController.swift
//  RandomPhotoGenerator
//
//  Created by Solomon on 01/01/2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Tap to get new Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let colors: [UIColor] = [
        .systemPink,
        .systemRed,
        .systemBlue,
        .systemOrange,
        .systemCyan,
        .systemIndigo
            
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.center = view.center
        getRandomPhotos()
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton) , for: .touchUpInside)
       
    }
    @objc func didTapButton(){
        getRandomPhotos()
        view.backgroundColor = colors.randomElement()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(x: 30, y: view.frame.size.height-150-view.safeAreaInsets.bottom, width: view.frame.size.width-60, height: 55)
        
    }
     
    func getRandomPhotos() {
        let urlString = "https://picsum.photos/600/600"
        guard let url = URL(string: urlString) else {
            return
        }
        
        // Show loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = imageView.center
        activityIndicator.startAnimating()
        imageView.addSubview(activityIndicator)
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            // Ensure we remove the activity indicator regardless of outcome
            defer {
                DispatchQueue.main.async {
                    activityIndicator.removeFromSuperview()
                }
            }
            
            guard let data = data, error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}

