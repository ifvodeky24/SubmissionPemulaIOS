//
//  ImageDownloader.swift
//  SubmissionPemulaIOS
//
//  Created by Ifvo Deky Wirawan on 11/06/23.
//

import Foundation
import UIKit

class ImageDownloader: Operation {
    func downloadImage(url: URL) async throws -> UIImage {
        async let imageData: Data = try Data(contentsOf: url)
        return UIImage(data: try await imageData)!
    }
}
