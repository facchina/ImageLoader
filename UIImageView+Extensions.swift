//
//  UIImageView+Extensions.swift
//  ImageLoader
//
//  Created by Kaike Facchina on 18/03/22.
//

import Foundation
import UIKit

extension UIImageView {
  func loadImage(at url: URL) {
    UIImageLoader.loader.load(url, for: self)
  }

  func cancelImageLoad() {
    UIImageLoader.loader.cancel(for: self)
  }
}
