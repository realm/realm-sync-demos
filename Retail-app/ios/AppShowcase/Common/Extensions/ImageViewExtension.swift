//
//  ImageViewExtension.swift
//
//  Created by Brian on 08/09/20.
//  Copyright © 2020 WeKan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {
    
    /// sets  image from cache .if not available in cache, downloads to cache and sets the image from cache.
    /// - Parameter photoKey: path of the image in server
    func downloadAndSetImage(fromUrl url: String, forItem itemId: String)  {
        let filename = url.components(separatedBy: "/").last ?? "product\(itemId)".trimmed
        let fileManager = FileManager.default
        let cachesURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let fileURL = cachesURL.appendingPathComponent(filename)
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        // if file exists in path, load image from path
        if fileManager.fileExists(atPath: fileURL.path) {
            DispatchQueue.main.async {
                do {
                    // Remove any existing file
                    let imageData = try Data(contentsOf: fileURL)
                    let img = UIImage(data: imageData)
                    self.image = img
                } catch {
                    print("Not able to load image")
                    self.image = nil //UIImage(named: "userPlaceholder")
                }
            }
        }
        // download image to path and load image
        print(url)
        AF.download(url,
                    method: .get,
                    parameters: nil,
                    encoding: URLEncoding.default,
                    headers: nil,
                    interceptor: nil,
                    requestModifier: nil,
                    to: destination).response { response in
                        debugPrint(response)
                        if response.error == nil, let imagePathUrl = response.fileURL {
                            DispatchQueue.main.async {
                                do {
                                    let imageData = try Data(contentsOf: imagePathUrl)
                                    let img = UIImage(data: imageData)
                                    self.image = img
                                } catch {
                                    print("Not able to load image")
                                    self.image = nil // UIImage(named: "userPlaceholder")
                                }
                            }
                        }
                    }
    }
}
