//
//  HeaderTableViewCell.swift
//  MDBRealmPatient
//
//  Created by MaDHiVaNan on 4/22/22.
//

import UIKit
import SDWebImage

class HeaderTableViewCell: UITableViewHeaderFooterView {
    @IBOutlet weak var hospitalAddress      : UILabel!
    @IBOutlet weak var hospitalDescription  : UILabel!
    @IBOutlet weak var hospitalName         : UILabel!
    
    @IBOutlet weak var locationImage        : UIImageView! {
        didSet {
            self.locationImage.contentMode = .scaleAspectFit
            self.locationImage.isHidden = true
        }
    }
    @IBOutlet weak var aboutlbl        : UILabel! {
        didSet {
            self.aboutlbl.text = "About"
        }
    }
    @IBOutlet weak var doctorlbl        : UILabel! {
        didSet {
            self.doctorlbl.text = "Doctors"
        }
    }
    @IBOutlet weak var about        : UILabel!
    @IBOutlet weak var sliderCollectionView: UICollectionView! {
        didSet {
            //self.sliderCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        }
    }
    @IBOutlet weak var pageView: UIPageControl!
    var timer = Timer()
    var counter = 0
    var model:Organization?{
        didSet{
            self.hospitalName.text = self.model?.name?.capitalizingFirstLetter()
            self.hospitalAddress.text = self.model?.address.first?.city
            self.hospitalDescription.text = self.model?.type?.text
            self.about.text = self.model?.type?.text
            self.locationImage.image = UIImage(named: "location")
            self.locationImage.isHidden = false
            self.pageView.numberOfPages = self.model?.photo.count ?? 0
            self.pageView.currentPage = 0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.sliderCollectionView.delegate = self
        self.sliderCollectionView.dataSource = self
        self.sliderCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    @objc func changeImage() {
     
        if counter < self.model?.photo.count ?? 0 {
         let index = IndexPath.init(item: counter, section: 0)
         self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
         pageView.currentPage = counter
         counter += 1
     } else {
         counter = 0
         let index = IndexPath.init(item: counter, section: 0)
         self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
         pageView.currentPage = counter
         counter = 1
     }
         
     }
}
extension HeaderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.photo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if let urlStr =  self.model?.photo.first?.url {
            self.logoprofileImage(subImageUrl: urlStr, hospitalImage: cell.hospitalImage)
            cell.hospitalImage.contentMode = .scaleAspectFill
        } else {
            cell.hospitalImage.contentMode = .scaleAspectFit
            cell.hospitalImage.image = UIImage(named: "placeholder")
        }
        return cell
    }
    func logoprofileImage(subImageUrl: String, hospitalImage: UIImageView) {
        hospitalImage.sd_setImage(with: URL(string: subImageUrl), placeholderImage: UIImage(named: "placeholder"), options: .handleCookies, progress: .none, completed: {_,_,_,_ in
            
        })
    }
}

extension HeaderTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
