//
//  BaseView.swift
//  Trendz Music
//
//  Created by Girira Stephy on 21/02/21.
//
import UIKit



class BaseView: UIView{
    
    
    var roundedShape = CAShapeLayer()
    var curvedPath: UIBezierPath!
    var shapeColor: UIColor!
    var circular: Bool!
    var shadow: Bool!
    var shadowLayer = CAShapeLayer()
    var borderColor: CGColor?
    var borderThickness: CGFloat?
    var image: UIImage?{
        didSet{
            imageView.image = image
        }
    }
    var imageView = UIImageView()
    
    convenience init(with backgroundTheme: UIColor, circular: Bool, shadow: Bool){
        self.init()
        shapeColor = backgroundTheme
        self.circular = circular
        self.shadow = shadow
    }
    
    
    convenience init(with backgroundTheme: UIColor, circular: Bool, shadow: Bool,borderColor: UIColor?,borderThickness: Int?){
        self.init()
        shapeColor = backgroundTheme
        self.circular = circular
        self.shadow = shadow
        self.borderThickness = CGFloat(borderThickness ?? 0)
        self.borderColor = borderColor?.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        imageView.layer.zPosition = .greatestFiniteMagnitude
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    
    func setColorToBaseView(color: UIColor){
        shapeColor = color
        layoutSubviews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
         imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
         imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
         imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)].forEach({$0.isActive = true})
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        if layer.sublayers?.contains(roundedShape) ?? false{
            roundedShape.removeFromSuperlayer()
        }
        if layer.sublayers?.contains(shadowLayer) ?? false{
            shadowLayer.removeFromSuperlayer()
        }

        curvedPath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.circular ? self.bounds.height / 2 : 15)
        roundedShape = CAShapeLayer()
        roundedShape.path = curvedPath.cgPath
        roundedShape.fillColor = shapeColor.cgColor
        self.layer.insertSublayer(roundedShape, at: 0)

        if let _ = self.borderColor, let _ = self.borderThickness{
            roundedShape.strokeColor = borderColor
            roundedShape.borderWidth = self.borderThickness!
        }


        if shadow{
            shadowLayer = CAShapeLayer()
            shadowLayer.fillColor = shapeColor.cgColor
            shadowLayer.shadowColor = UIColor(red: 0.64, green: 0.71, blue: 0.78, alpha: 1.00).cgColor
            shadowLayer.shadowRadius = 10
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowOffset = CGSize(width: 10, height: 10)
            shadowLayer.path = curvedPath.cgPath
            shadowLayer.fillColor = (backgroundColor ?? UIColor.white).cgColor
            layer.insertSublayer(shadowLayer, below: roundedShape)
        }
        
        imageView.layer.mask = roundedShape
    }
    
    
}

