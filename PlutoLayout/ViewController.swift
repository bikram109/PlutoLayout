//
//  ViewController.swift
//  PlutoLayout
//
//  Created by Octopus Baba on 3/16/17.
//  Copyright © 2017 Octopus Baba. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PlutoProtocolDelegate {

	@IBOutlet weak var collectionView: UICollectionView!
	var plutoLayoutObj:PlutoLayout?
	var imgArray:[String] = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.delegate = self
		collectionView.dataSource = self
		plutoLayoutObj = PlutoLayout(collectionView: self.collectionView,delegate: self)

	}

	//MARK: PlutoLayout Delegate Method
	
	func getImageSizeAtIndexPath(indexpath:IndexPath) -> CGSize{
		let img = UIImage(named: "\(indexpath.row).jpg")
		
		return  CGSize(width:(img?.size.width)!, height: (img?.size.height)!)
	}
	
}
extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return imgArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plutocell", for: indexPath) 
		let imgview = cell.viewWithTag(100) as! UIImageView
		imgview.image = UIImage(named: "\(indexPath.row).jpg")
	
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return plutoLayoutObj!.getImageSize(atIndexpath:indexPath)
	}
	
}


