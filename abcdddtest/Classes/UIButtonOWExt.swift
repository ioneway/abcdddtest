//
//  LLButton.swift
//  RedEvelope
//
//  Created by 陈政宏 on 2018/9/22.
//  Copyright © 2018年 陈政宏. All rights reserved.
//

import UIKit


public enum ImageAlignment: NSInteger {
    case left
    case top
    case bottom
    case right
}


public typealias AlignmentSpace = (alignment:ImageAlignment? , space: CGFloat?)

extension UIButton {
    
   open var aligmentAndSpace:  AlignmentSpace{
        set {
            if let aligment = newValue.alignment {
                self.imageAlignment = aligment
            }
            if let space  = newValue.space {
                 self.spaceBetweenTitleAndImage = space
            }
            
            self.layoutImageAndTitle()
        }
        
        get {
            return (alignment: self.imageAlignment, space: self.spaceBetweenTitleAndImage)
        }
    }
    
    struct RuntimeKey {
        static let imageAlimentKey = UnsafeRawPointer.init(bitPattern: "imageAlimentKey".hashValue)
        static let spaceKey = UnsafeRawPointer.init(bitPattern: "spaceKey".hashValue)
    }
    struct RuntimeKey2 {
        
        static let imageAlimentPointer: UnsafeRawPointer = {
                var m_imageAliment: ImageAlignment = .right
                let m_imageAliment_pointer = UnsafeRawPointer(&m_imageAliment)
                return m_imageAliment_pointer
        }()
        
        static let spacePointer: UnsafeRawPointer = {
            var m_space: CGFloat = 5.0
            let m_space_pointer = UnsafeRawPointer(&m_space)
            return m_space_pointer
        }()
    }
    
    
    private var imageAlignment: ImageAlignment {
        set {
            objc_setAssociatedObject(self, RuntimeKey.imageAlimentKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, RuntimeKey.imageAlimentKey!) as?  ImageAlignment{
                return rs
            }
            return .left
        }
    }
    
    private var spaceBetweenTitleAndImage: CGFloat {
        set {
            objc_setAssociatedObject(self, RuntimeKey.spaceKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, RuntimeKey.spaceKey!) as? CGFloat {
                return rs
            }
            
            return 0.0
        }
    }
    
     func layoutImageAndTitle() {
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
        self.titleLabel?.sizeToFit()
        
        let space: CGFloat = self.spaceBetweenTitleAndImage
        
        let titleW: CGFloat = self.titleLabel?.bounds.width ?? 0
        let titleH: CGFloat = self.titleLabel?.bounds.height ?? 0
        
        let imageW: CGFloat = self.imageView?.bounds.width ?? 0
        let imageH: CGFloat = self.imageView?.bounds.height ?? 0
        
        let btnCenterX: CGFloat = self.bounds.width / 2
        let imageCenterX: CGFloat = btnCenterX - titleW / 2
        let titleCenterX = btnCenterX + imageW / 2
        
        
        switch self.imageAlignment {
        case .top:
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleH / 2 + space / 2), left: btnCenterX - imageCenterX, bottom: titleH / 2 + space / 2, right: -(btnCenterX - imageCenterX));
            self.titleEdgeInsets = UIEdgeInsets(top: imageH / 2 + space / 2, left: -(titleCenterX - btnCenterX), bottom: -(imageH/2 + space/2), right: titleCenterX-btnCenterX)
        case .left:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0,  right: -space / 2);
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2, bottom: 0, right: space);
        case .bottom:
            self.titleEdgeInsets = UIEdgeInsets(top: -(imageH / 2 + space / 2), left: -(titleCenterX - btnCenterX), bottom: imageH / 2 + space / 2, right: titleCenterX - btnCenterX);
            self.imageEdgeInsets = UIEdgeInsets(top: titleH / 2 + space / 2, left: btnCenterX - imageCenterX,bottom: -(titleH / 2 + space / 2), right: -(btnCenterX - imageCenterX));
        case .right:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageW + space / 2), bottom: 0, right: imageW + space / 2);
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleW + space / 2, bottom: 0, right: -(titleW + space / 2));
        }
        
        
    }
}
