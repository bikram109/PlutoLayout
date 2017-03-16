//
//  PlutoLayout.swift
//  Artup
//
//  Created by Octopus Baba on 3/16/17.
//  Copyright © 2017 Artisto Inc. All rights reserved.
//

import Foundation
import UIKit

protocol PlutoProtocolDelegate{
	func getImageSizeAtIndexPath(indexpath:IndexPath) -> CGSize
}

class PlutoLayout: NSObject{
	
	var maxImgHeight:CGFloat?
	var cellImageSize = CGSize()
	var lastIndexPath:IndexPath?
	var collectionViewWidth:CGFloat?
	var cellImageSizeArray = [CGSize]()
	var collectionView: UICollectionView!
	var imgSizeCache = [IndexPath:CGSize]()
	var plutoDelegate:PlutoProtocolDelegate?
	
	init(collectionView:UICollectionView , delegate:PlutoProtocolDelegate) {
		self.collectionView = collectionView
		self.plutoDelegate = delegate
		collectionViewWidth = self.collectionView.bounds.width
		maxImgHeight =  (self.collectionView.bounds.height) / 3
	}
	
	func getImageSize(atIndexpath:IndexPath) -> CGSize{
		if (imgSizeCache[atIndexpath] == nil){
			self.lastIndexPath = atIndexpath
			self.calculateImageSizeAt(indexPath: atIndexpath)
		}
		let size = imgSizeCache[atIndexpath]
		return size!
	}
	
	func calculateImageSizeAt(indexPath:IndexPath){
		cellImageSize = getOriginalSizeOfImage(atIndexpath: indexPath)
		cellImageSizeArray.append(cellImageSize)

		var rowImgHeight = maxImgHeight
		var aspectRatio:CGFloat = 0.0
		
		for imgSize in cellImageSizeArray{
			aspectRatio = aspectRatio + (imgSize.width / imgSize.height)
		}
		
		rowImgHeight = collectionViewWidth! / aspectRatio
		
		if CGFloat(rowImgHeight!) < maxImgHeight!  {
			
			var remainingSpace = collectionViewWidth
			for imgSize in cellImageSizeArray{
				
				var newWidth = floor((rowImgHeight! * imgSize.width)/imgSize.height)
				newWidth = min(remainingSpace!, newWidth)
				let ratio = getDeviceRatio()
				
				imgSizeCache[lastIndexPath!] = CGSize(width: newWidth * ratio , height: rowImgHeight! * ratio)
				
				remainingSpace = remainingSpace! - newWidth
				remainingSpace = remainingSpace! - 5
				
				self.lastIndexPath = NSIndexPath(row: (self.lastIndexPath?.item)! + 1, section: (self.lastIndexPath?.section)!) as IndexPath
			}
			self.cellImageSizeArray.removeAll()
		}else{
			self.calculateImageSizeAt(indexPath: NSIndexPath(row: (indexPath.item + 1), section: (indexPath.section)) as IndexPath)
		}
	}
	
	func getOriginalSizeOfImage(atIndexpath:IndexPath)->CGSize{
		if let size = plutoDelegate?.getImageSizeAtIndexPath(indexpath: atIndexpath){
			return size
		}else{
			return  CGSize(width:0.1, height: 0.1)
		}
	}
	
	//TODO: FIND THE SOLUTION FOR RATIO
	
	func getDeviceRatio ()->CGFloat{
		let collectionViewSize = self.collectionView.bounds.width
		if collectionViewSize == 320 {
			return 0.767
		}else if collectionViewSize == 414{
			return 1.02
		}else{
			return 344/375
		}
	}
	
	func clearSizeCache() {
		imgSizeCache.removeAll()
	}
	
}
