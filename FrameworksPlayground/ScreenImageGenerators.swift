//
//  ScreenImageGenerators.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/3/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

func snapImage(ofView: UIView, #size: CGSize, #offset: CGPoint) -> UIImage {
  UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
  ofView.drawViewHierarchyInRect(CGRect(origin: offset, size: size), afterScreenUpdates: true)
  let image = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  return image
}

func verticalSplits(view: UIView) -> (top: UIImage?, bottom: UIImage?) {
  let full = snapImage(view, size: CGSize(width: view.bounds.width, height: view.bounds.height), offset: CGPoint(x: 0, y: 0))
  let cgFull = full.CGImage
  let imageWidth = CGImageGetWidth(cgFull)
  let imageHeight = CGImageGetHeight(cgFull)
  let cgTop = CGRect(x: 0, y: 0, width: CGFloat(imageWidth), height: CGFloat(imageHeight)/2.0)
  let cgBottom = CGRect(x: 0, y: CGFloat(imageHeight)/2.0, width: CGFloat(imageWidth), height: CGFloat(imageHeight)/2.0)
  let topCGImage = CGImageCreateWithImageInRect(cgFull, cgTop)
  let bottomCGImage = CGImageCreateWithImageInRect(cgFull, cgBottom)
  let topImage = UIImage(CGImage: topCGImage, scale: full.scale, orientation: full.imageOrientation)
  let bottomImage = UIImage(CGImage: bottomCGImage, scale: full.scale, orientation: full.imageOrientation)
  let images = (top: topImage, bottom: bottomImage)
  return images
}

func horizontalSplits(view: UIView) -> (left: UIImage?, right: UIImage?) {
  let full = snapImage(view, size: CGSize(width: view.bounds.width, height: view.bounds.height), offset: CGPoint(x: 0, y: 0))
  let cgFull = full.CGImage
  let imageWidth = CGImageGetWidth(cgFull)
  let imageHeight = CGImageGetHeight(cgFull)
  let cgLeft = CGRect(x: 0, y: 0, width: CGFloat(imageWidth)/2.0, height: CGFloat(imageHeight))
  let cgRight = CGRect(x: CGFloat(imageWidth)/2.0, y: 0, width: CGFloat(imageWidth)/2.0, height: CGFloat(imageHeight))
  let leftCGImage = CGImageCreateWithImageInRect(cgFull, cgLeft)
  let rightCGImage = CGImageCreateWithImageInRect(cgFull, cgRight)
  let leftImage = UIImage(CGImage: leftCGImage, scale: full.scale, orientation: full.imageOrientation)
  let rightImage = UIImage(CGImage: rightCGImage, scale: full.scale, orientation: full.imageOrientation)
  let images = (left: leftImage, right: rightImage)
  return images
}
