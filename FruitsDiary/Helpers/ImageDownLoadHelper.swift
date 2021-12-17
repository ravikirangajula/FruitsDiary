//
//  UIImageView+Extension.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 17/12/2021.
//

import Foundation
import UIKit

class ImageDownLoadHelper: NSObject {
    static var cache = NSCache<NSString, UIImage>()

     static func downloaded(from urlString: String, completionHandler: @escaping (UIImage) -> ())  {
        guard let url = URL(string: String(urlString)) else { return }
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completionHandler(cachedImage)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            self.cache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }.resume()
    }
    
}
