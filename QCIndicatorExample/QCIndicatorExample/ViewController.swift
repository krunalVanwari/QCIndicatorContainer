//
//  ViewController.swift
//  QCIndicatorExample
//
//  Created by Qurious Click on 03/05/22.
//

import UIKit

class ViewController: UIViewController {

    var ref:QCIndicatorContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let vu = createToastLabel()
        let ind = QCIndicatorContainer()
        ind.setUserInteractionEnabled(true)
        ind.showIndicator(for: self, indicatorView: vu, indicatorSize: vu.frame.size,animate: true, onTapAction:  {
            ind.hideIndicator()
        })
        ref = ind
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("ended touches")
    }


}

extension ViewController {
    
    func createActivityIndicatorView() -> UIView {
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        var headView = UIView()
        
        headView = UIActivityIndicatorView(style: .whiteLarge)
        (headView as! UIActivityIndicatorView).startAnimating()
        headView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(headView)
        
        mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .centerY, relatedBy: .equal, toItem: mainView, attribute: .centerY, multiplier: 1.0, constant: 0) )
        mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: 1.0, constant: 0) )
        mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36) )
        mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36) )
        
        mainView.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        
        return mainView
    }
     
    func createToastLabel() -> UIView {
        let toastLbl = UILabel()
        toastLbl.numberOfLines = 0
        toastLbl.text = "Example of a toast message"
        toastLbl.textAlignment = .center
        toastLbl.font = .systemFont(ofSize: 14)
        
        let textSize = toastLbl.intrinsicContentSize
        let labelHeight = ( textSize.width / view.frame.width ) * 30
        let labelWidth = min(textSize.width, view.frame.width - 40)
        let adjustedHeight = max(labelHeight, textSize.height + 20)
        
        toastLbl.frame = CGRect(x: 20, y: (view.frame.height - 90 ) - adjustedHeight, width: labelWidth + 20, height: adjustedHeight)
        toastLbl.layer.cornerRadius = 10
        toastLbl.backgroundColor = .lightGray.withAlphaComponent(0.5)
        toastLbl.layer.masksToBounds = true
        
        return toastLbl
    }

    func createImageWithText() -> UIView{
        let vu = UIView()
        vu.layer.cornerRadius = 10
        vu.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        let height:CGFloat = 50
        let width:CGFloat = 240
        
        let label = UILabel()
        label.text = "Example of a notification"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.frame = CGRect(x: 4 + height, y: 0, width: width - height - 4, height: height)
        
        vu.addSubview(label)
        
        let image = UIImageView()
        if #available(iOS 13.0, *) {
            image.image = .init(systemName: "phone")
        } else {
            image.backgroundColor = .systemRed.withAlphaComponent(0.5)
        }
        image.frame = CGRect(x: 0, y: 0, width: height, height: height)
        
        vu.addSubview(image)
        vu.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        
        return vu
        
    }
}
