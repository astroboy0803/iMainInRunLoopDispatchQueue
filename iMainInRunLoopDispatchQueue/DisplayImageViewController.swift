/// <#Brief Description#> 
///
/// Created by TWINB00776283 on 2023/7/14.
/// Copyright © 2023 Cathay United Bank. All rights reserved.

import UIKit
import Combine

internal class DisplayImageViewController: UIViewController {    
    
    let scrollView: UIScrollView = .init()
    
    let queueLabel: UILabel = .init()
    let queueImgView: UIImageView = .init()
    
    let loopLabel: UILabel = .init()
    let loopImgView: UIImageView = .init()
    
    let closeButton: UIButton = .init()
    
    var cancellables: Set<AnyCancellable> = []
    
	var viewModel: CUBDisplayImageViewModel

	init() {
		viewModel = .init()
		super.init(nibName: nil, bundle: nil)
        setup()
	}
    
    private func setup() {
        view.backgroundColor = .white
        scrollView.backgroundColor = .systemRed
        scrollView.contentSize = UIScreen.main.bounds.size
        
        closeButton.addTarget(self, action: #selector(closing(sender:)), for: .touchUpInside)
        
        closeButton.setTitle("✖", for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.setTitleColor(.systemGray, for: .highlighted)
        
        queueLabel.text = "Main DispatchQueue"
        loopLabel.text = "Main RunLoop"
        
        [queueLabel, loopLabel].forEach {
            $0.textAlignment = .center
            $0.font = .preferredFont(forTextStyle: .body)
            $0.textColor = .black
            $0.layer.borderColor = UIColor.systemGray.cgColor
            $0.layer.borderWidth = 2
        }
        
        queueImgView.backgroundColor = .systemBlue
        loopImgView.backgroundColor = .systemYellow
        
        [queueImgView, loopImgView].forEach {
            $0.contentMode = .scaleAspectFit
        }
        
        [scrollView, closeButton, queueLabel, queueImgView, loopLabel, loopImgView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: queueLabel.topAnchor, constant: -10),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            
            queueLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            queueLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            queueLabel.heightAnchor.constraint(equalToConstant: 40),
            queueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            queueImgView.topAnchor.constraint(equalTo: queueLabel.bottomAnchor, constant: 10),
            queueImgView.widthAnchor.constraint(equalTo: queueLabel.widthAnchor),
            queueImgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            queueImgView.leadingAnchor.constraint(equalTo: queueLabel.leadingAnchor),
            
            loopLabel.topAnchor.constraint(equalTo: queueLabel.topAnchor),
            loopLabel.bottomAnchor.constraint(equalTo: queueLabel.bottomAnchor),
            loopLabel.widthAnchor.constraint(equalTo: queueLabel.widthAnchor),
            loopLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loopImgView.topAnchor.constraint(equalTo: loopLabel.bottomAnchor, constant: 10),
            loopImgView.widthAnchor.constraint(equalTo: loopLabel.widthAnchor),
            loopImgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            loopImgView.trailingAnchor.constraint(equalTo: loopLabel.trailingAnchor),
            
        ])
    }
    
    @objc
    private func closing(sender: UIButton) {
        self.dismiss(animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
                            
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            print("starting...")
            
            let publisher = URLSession.shared
                .dataTaskPublisher(for: URL(string: "https://picsum.photos/300/600")!)
                .map(\.data)
                .compactMap(UIImage.init)
                .eraseToAnyPublisher()
            
            publisher
                .receive(on: RunLoop.main)
                .sink { _ in
                    print("Image loading completed")
                } receiveValue: { image in
                    self.loopImgView.image = image
                }
                .store(in: &self.cancellables)
            
            publisher
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    print("Image loading completed")
                } receiveValue: { image in
                    self.queueImgView.image = image
                }
                .store(in: &self.cancellables)
        }
    }
}
