//
//  ViewController.swift
//  iOSPractice
//
//  Created by 이태영 on 2023/05/02.
//

import UIKit

enum NetworkError: Error {
    case transferError
    case responseError
    case dataError
}

final class ImageData {
    let data: Data
    
    init(data: Data) {
        self.data = data
    }
}

final class ViewController: UIViewController {
    @IBOutlet private weak var firstImageView: UIImageView!
    @IBOutlet private weak var secondImageView: UIImageView!
    
    private let networkManager = NetworkManager()
    private let cache = NSCache<NSString, ImageData>()
}

// MARK: Life Cycle
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        firstImageView.contentMode = .scaleAspectFill
        secondImageView.contentMode = .scaleAspectFill
        URLCache.shared.removeAllCachedResponses()
    }
}

// MARK: IBAction
extension ViewController {
    @IBAction private func tapFetchFirstImageButton(_ sender: Any) {
        let url = URL(string: "https://wallpaperaccess.com/download/europe-4k-1369012")!
        
        guard let imageData = fetchImageInMemory(key: url.absoluteString) else {
            networkManager.fetchImage(endpoint: url) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.firstImageView.image = UIImage(data: data)
                    }
                    
                    self.saveImageInMemory(key: url.absoluteString, data: data)
                case .failure(let error):
                    print(error)
                }
            }
            
            return
        }
        
        firstImageView.image = UIImage(data: imageData)
    }
    
    @IBAction private func tapFetchSecondImageButton(_ sender: Any) {
        let url = URL(string: "https://wallpaperaccess.com/download/europe-4k-1369012")!

            networkManager.fetchImage(endpoint: url) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.secondImageView.image = UIImage(data: data)
                    }
                    
                    self.saveImageInMemory(key: url.absoluteString, data: data)
                case .failure(let error):
                    print(error)
                }
            }
        
    }
    
    @IBAction private func tapResetImageButton(_ sender: Any) {
        firstImageView.image = nil
        secondImageView.image = nil
    }
    
    @IBAction private func tapResetCacheButton(_ sender: Any) {
        cache.removeAllObjects()
    }
}

// MARK: Cache
extension ViewController {
    private func saveImageInMemory(key: String, data: Data) {
        let objectKey = NSString(string: key)
        cache.setObject(ImageData(data: data), forKey: objectKey)
    }
    
    private func fetchImageInMemory(key: String) -> Data? {
        let objectKey = NSString(string: key)
        let imageData = cache.object(forKey: objectKey)
        return imageData?.data
    }
}

final class NetworkManager {
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    func fetchImage(
        endpoint: URL,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        let request = URLRequest(url: endpoint)
        
        if let response = URLCache.shared.cachedResponse(for: request) {
            print(response)
            return
        }
        
        print(URLCache.shared.memoryCapacity)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.transferError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300) ~= httpResponse.statusCode
            else {
                completion(.failure(.responseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }

            let image = UIImage(data: data)!
            let imageData = image.resize(newWidth: 10)
            
            let cachedResponse = CachedURLResponse(
                response: httpResponse,
                data: data,
                storagePolicy: .allowedInMemoryOnly
            )
            
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
            completion(.success(data))
        }
        
        task.resume()
    }
}

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        print("화면 배율: \(UIScreen.main.scale)")// 배수
        print("origin: \(self), resize: \(renderImage)")
        
        return renderImage
    }
}
