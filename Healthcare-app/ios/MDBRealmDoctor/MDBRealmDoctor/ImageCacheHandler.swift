//
//  ImageCacheHandler.swift
//  MDBRealmDoctor
//
//  Created by Karthick TM on 06/05/22.
//

import Foundation
import UIKit

// Image downloader utility class. We are going to use the singleton instance to be able to download required images and store them into in-memory cache.
final class ImageDownloader {

    static let shared = ImageDownloader()

    private var cachedImages: [String: UIImage]
    private var imagesDownloadTasks: [String: URLSessionDataTask]

    // A serial queue to be able to write the non-thread-safe dictionary
    let serialQueueForImages = DispatchQueue(label: "images.queue", attributes: .concurrent)
    let serialQueueForDataTasks = DispatchQueue(label: "dataTasks.queue", attributes: .concurrent)

    // MARK: Private init
    private init() {
        cachedImages = [:]
        imagesDownloadTasks = [:]
    }

     /**
    Downloads and returns images through the completion closure to the caller
     - Parameter imageUrlString: The remote URL to download images from
     - Parameter completionHandler: A completion handler which returns two parameters. First one is an image which may or may
     not be cached and second one is a bool to indicate whether we returned the cached version or not
     - Parameter placeholderImage: Placeholder image to display as we're downloading them from the server
     */
    func downloadImage(with imageUrlString: String?,
                       completionHandler: @escaping (UIImage?, Bool) -> Void,
                       placeholderImage: UIImage?) {

        guard let imageUrlString = imageUrlString else {
            completionHandler(placeholderImage, true)
            return
        }

        if let image = getCachedImageFrom(urlString: imageUrlString) {
            completionHandler(image, true)
        } else {
            guard let url = URL(string: imageUrlString) else {
                completionHandler(placeholderImage, true)
                return
            }

            if let _ = getDataTaskFrom(urlString: imageUrlString) {
                return
            }

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

                guard let data = data else {
                    return
                }

                if let _ = error {
                    DispatchQueue.main.async {
                        completionHandler(placeholderImage, true)
                    }
                    return
                }

                let image = UIImage(data: data)
                self.serialQueueForImages.sync(flags: .barrier) {
                    self.cachedImages[imageUrlString] = image
                }

                _ = self.serialQueueForDataTasks.sync(flags: .barrier) {
                    self.imagesDownloadTasks.removeValue(forKey: imageUrlString)
                }

                DispatchQueue.main.async {
                    completionHandler(image, false)
                }
            }
            // We want to control the access to no-thread-safe dictionary in case it's being accessed by multiple threads at once
            self.serialQueueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks[imageUrlString] = task
            }

            task.resume()
        }
    }

    private func cancelPreviousTask(with urlString: String?) {
        if let urlString = urlString, let task = getDataTaskFrom(urlString: urlString) {
            task.cancel()
            // Since Swift dictionaries are not thread-safe, we have to explicitly set this barrier to avoid fatal error when it is accessed by multiple threads simultaneously
            _ = serialQueueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks.removeValue(forKey: urlString)
            }
        }
    }

    private func getCachedImageFrom(urlString: String) -> UIImage? {
        // Reading from the dictionary should happen in the thread-safe manner.
        serialQueueForImages.sync {
            return cachedImages[urlString]
        }
    }

    private func getDataTaskFrom(urlString: String) -> URLSessionTask? {

        // Reading from the dictionary should happen in the thread-safe manner.
        serialQueueForDataTasks.sync {
            return imagesDownloadTasks[urlString]
        }
    }
}
