//
//  Color+hex.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 18.03.2023.
//

import SwiftUI

extension Color {
    
    struct RGBA {
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        let a: CGFloat
    }
    
    var rgba: RGBA {

        #if canImport(UIKit)
        let ciColor = CIColor(color: UIColor(self))

        return RGBA(r: ciColor.red, g: ciColor.green, b: ciColor.blue, a: ciColor.alpha)
        #elseif canImport(AppKit)
        let native = NSColor(self)
        
        if let color = native.usingColorSpace(.deviceRGB) {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            return RGBA(r: r, g: g, b: b, a: a)
        }

        if let color = native.usingColorSpace(.deviceRGB) {
            var h: CGFloat = 0
            var s: CGFloat = 0
            var l: CGFloat = 0
            var a: CGFloat = 0
            color.getHue(&h, saturation: &s, brightness: &l, alpha: &a)
            
            return Color.toRGB(h: h, s: s, l: l, a: a)
        }

        return RGBA(r: 0, g: 0, b: 0, a: 0)

        #else
        return RGBA(r: 0, g: 0, b: 0, a: 0)
        #endif
    }

    func lerp(color: Color, fraction f: CGFloat) -> Color {
        guard f > 0 else {
            return self
        }
        let s = self.rgba
        let t = color.rgba
        
        let r = s.r + (t.r - s.r) * f
        let g = s.g + (t.g - s.g) * f
        let b = s.b + (t.b - s.b) * f
        let a = s.a + (t.a - s.a) * f
        
        return Color(red: r, green: g, blue: b, opacity: a)
    }
    
    
    private static func toRGB(h: CGFloat, s: CGFloat, l: CGFloat, a: CGFloat) -> RGBA {
        guard s != 0 else {
            return RGBA(r: s, g: s, b: s, a: a)
        }

        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q
        let r = hueToRgb(p: p, q: q, t: h + 1 / 3)
        let g = hueToRgb(p: p, q: q, t: h)
        let b = hueToRgb(p: p, q: q, t: h - 1 / 3)
        
        return RGBA(r: r, g: g, b: b, a: a)
    }

    private static func hueToRgb(p: CGFloat, q: CGFloat, t: CGFloat) -> CGFloat {
        var t = t
        
        if t < 0 {
            t += 1
        }
        
        if t > 1 {
            t -= 1
            
        }
        
        if t < 1 / 6 {
            return p + (q - p) * 6 * t
        }
        
        if t < 1 / 2 {
            return q
        }
            
        if t < 2 / 3 {
            return p + (q - p) * (2 / 3 - t) * 6
        }
            
        return p
    }
    
    init(r: UInt8, g: UInt8, b: UInt8) {
        let r = Double(r) / 255
        let g = Double(g) / 255
        let b = Double(b) / 255
        self.init(.displayP3, red: r, green: g, blue: b)
    }
    
    init(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255

                    self.init(.displayP3, red: r, green: g, blue: b)
                    return
                }
            }
        }
        
        self.init(.displayP3, red: 0, green: 0, blue: 0)
    }
}

