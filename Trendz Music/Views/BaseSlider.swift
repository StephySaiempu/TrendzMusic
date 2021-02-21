//
//  BaseSlider.swift
//  Trendz Music
//
//  Created by Girira Stephy on 21/02/21.
//

import UIKit

class BaseSlider: UISlider {
    
    
    var values: [Float]?
    var customColor = UIColor(red: 1.00, green: 0.93, blue: 0.99, alpha: 1.00)
    var maximumTintColor = UIColor(red: 0.99, green: 0.96, blue: 0.95, alpha: 1.00)
    var numberOfTicks: CGFloat = 3
    var tickViews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.thumbTintColor = customColor
        self.tintColor = customColor
        self.minimumTrackTintColor = customColor
        self.maximumTrackTintColor = maximumTintColor
    }
    
    convenience init(ticks: Int) {
        self.init()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(values: [Float]) {
        self.init()
        self.thumbTintColor = customColor
        self.tintColor = customColor
        
    }
    
    

}
