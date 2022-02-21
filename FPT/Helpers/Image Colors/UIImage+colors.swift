//
//  UIImage+colors.swift
//  FPT
//
//  Created by Hans Rietmann on 10/02/2022.
//

import SwiftUI





extension UIImage {
    private func resizeForUIImageColors(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("UIImageColors.resizeForUIImageColors failed: UIGraphicsGetImageFromCurrentImageContext returned nil.")
        }
        
        return result
    }
    
    
    func colors(quality: ImageColorsQuality = .high) async -> ImageColors {
        await Task.detached { self.colors(quality: quality) }.value
    }
    
    var colors: ImageColors {
        get async { await colors() }
    }
    
    func colors(quality: ImageColorsQuality = .high) -> ImageColors {
        var scaleDownSize: CGSize = self.size
        if quality != .highest {
            if self.size.width < self.size.height {
                let ratio = self.size.height/self.size.width
                scaleDownSize = CGSize(width: quality.rawValue/ratio, height: quality.rawValue)
            } else {
                let ratio = self.size.width/self.size.height
                scaleDownSize = CGSize(width: quality.rawValue, height: quality.rawValue/ratio)
            }
        }
        
        let cgImage = self.resizeForUIImageColors(newSize: scaleDownSize).cgImage!
        let width: Int = cgImage.width
        let height: Int = cgImage.height
        
        let threshold = Int(CGFloat(height)*0.01)
        var proposed: [Double] = [-1,-1,-1,-1]
        
        guard let data = CFDataGetBytePtr(cgImage.dataProvider!.data) else {
            fatalError("UIImageColors.getColors failed: could not get cgImage data.")
        }
        
        let imageColors = NSCountedSet(capacity: width*height)
        for x in 0..<width {
            for y in 0..<height {
                let pixel: Int = ((width * y) + x) * 4
                if 127 <= data[pixel+3] {
                    imageColors.add((Double(data[pixel+2])*1000000)+(Double(data[pixel+1])*1000)+(Double(data[pixel])))
                }
            }
        }
        
        let sortedColorComparator: Comparator = { (main, other) -> ComparisonResult in
            let m = main as! ImageColorsCounter, o = other as! ImageColorsCounter
            if m.count < o.count {
                return .orderedDescending
            } else if m.count == o.count {
                return .orderedSame
            } else {
                return .orderedAscending
            }
        }
        
        var enumerator = imageColors.objectEnumerator()
        var sortedColors = NSMutableArray(capacity: imageColors.count)
        while let K = enumerator.nextObject() as? Double {
            let C = imageColors.count(for: K)
            if threshold < C {
                sortedColors.add(ImageColorsCounter(color: K, count: C))
            }
        }
        sortedColors.sort(comparator: sortedColorComparator)
        
        var proposedEdgeColor: ImageColorsCounter
        if 0 < sortedColors.count {
            proposedEdgeColor = sortedColors.object(at: 0) as! ImageColorsCounter
        } else {
            proposedEdgeColor = ImageColorsCounter(color: 0, count: 1)
        }
        
        if proposedEdgeColor.color.isBlackOrWhite && 0 < sortedColors.count {
            for i in 1..<sortedColors.count {
                let nextProposedEdgeColor = sortedColors.object(at: i) as! ImageColorsCounter
                if Double(nextProposedEdgeColor.count)/Double(proposedEdgeColor.count) > 0.3 {
                    if !nextProposedEdgeColor.color.isBlackOrWhite {
                        proposedEdgeColor = nextProposedEdgeColor
                        break
                    }
                } else {
                    break
                }
            }
        }
        proposed[0] = proposedEdgeColor.color
        
        enumerator = imageColors.objectEnumerator()
        sortedColors.removeAllObjects()
        sortedColors = NSMutableArray(capacity: imageColors.count)
        let findDarkTextColor = !proposed[0].isDarkColor
        
        while var K = enumerator.nextObject() as? Double {
            K = K.with(minSaturation: 0.15)
            if K.isDarkColor == findDarkTextColor {
                let C = imageColors.count(for: K)
                sortedColors.add(ImageColorsCounter(color: K, count: C))
            }
        }
        sortedColors.sort(comparator: sortedColorComparator)
        
        for color in sortedColors {
            let color = (color as! ImageColorsCounter).color
            
            if proposed[1] == -1 {
                if color.isContrasting(proposed[0]) {
                    proposed[1] = color
                }
            } else if proposed[2] == -1 {
                if !color.isContrasting(proposed[0]) || !proposed[1].isDistinct(color) {
                    continue
                }
                proposed[2] = color
            } else if proposed[3] == -1 {
                if !color.isContrasting(proposed[0]) || !proposed[2].isDistinct(color) || !proposed[1].isDistinct(color) {
                    continue
                }
                proposed[3] = color
                break
            }
        }
        
        let isDarkBackground = proposed[0].isDarkColor
        for i in 1...3 {
            if proposed[i] == -1 {
                proposed[i] = isDarkBackground ? 255255255:0
            }
        }
        
        return ImageColors(
            background: proposed[0].color,
            primary: proposed[1].color,
            secondary: proposed[2].color,
            detail: proposed[3].color
        )
    }
}


fileprivate struct ImageColorsCounter {
    let color: Double
    let count: Int
    init(color: Double, count: Int) {
        self.color = color
        self.count = count
    }
}

/*
 Extension on double that replicates UIColor methods. We DO NOT want these
 exposed outside of the library because they don't make sense outside of the
 context of UIImageColors.
 */
fileprivate extension Double {
    
    private var r: Double {
        return fmod(floor(self/1000000),1000000)
    }
    
    private var g: Double {
        return fmod(floor(self/1000),1000)
    }
    
    private var b: Double {
        return fmod(self,1000)
    }
    
    var isDarkColor: Bool {
        return (r*0.2126) + (g*0.7152) + (b*0.0722) < 127.5
    }
    
    var isBlackOrWhite: Bool {
        return (r > 232 && g > 232 && b > 232) || (r < 23 && g < 23 && b < 23)
    }
    
    func isDistinct(_ other: Double) -> Bool {
        let _r = self.r
        let _g = self.g
        let _b = self.b
        let o_r = other.r
        let o_g = other.g
        let o_b = other.b
        
        return (fabs(_r-o_r) > 63.75 || fabs(_g-o_g) > 63.75 || fabs(_b-o_b) > 63.75)
        && !(fabs(_r-_g) < 7.65 && fabs(_r-_b) < 7.65 && fabs(o_r-o_g) < 7.65 && fabs(o_r-o_b) < 7.65)
    }
    
    func with(minSaturation: Double) -> Double {
        // Ref: https://en.wikipedia.org/wiki/HSL_and_HSV
        
        // Convert RGB to HSV
        
        let _r = r/255
        let _g = g/255
        let _b = b/255
        var H, S, V: Double
        let M = fmax(_r,fmax(_g, _b))
        var C = M-fmin(_r,fmin(_g, _b))
        
        V = M
        S = V == 0 ? 0:C/V
        
        if minSaturation <= S {
            return self
        }
        
        if C == 0 {
            H = 0
        } else if _r == M {
            H = fmod((_g-_b)/C, 6)
        } else if _g == M {
            H = 2+((_b-_r)/C)
        } else {
            H = 4+((_r-_g)/C)
        }
        
        if H < 0 {
            H += 6
        }
        
        // Back to RGB
        
        C = V*minSaturation
        let X = C*(1-fabs(fmod(H,2)-1))
        var R, G, B: Double
        
        switch H {
        case 0...1:
            R = C
            G = X
            B = 0
        case 1...2:
            R = X
            G = C
            B = 0
        case 2...3:
            R = 0
            G = C
            B = X
        case 3...4:
            R = 0
            G = X
            B = C
        case 4...5:
            R = X
            G = 0
            B = C
        case 5..<6:
            R = C
            G = 0
            B = X
        default:
            R = 0
            G = 0
            B = 0
        }
        
        let m = V-C
        
        return (floor((R + m)*255)*1000000)+(floor((G + m)*255)*1000)+floor((B + m)*255)
    }
    
    func isContrasting(_ color: Double) -> Bool {
        let bgLum = (0.2126*r)+(0.7152*g)+(0.0722*b)+12.75
        let fgLum = (0.2126*color.r)+(0.7152*color.g)+(0.0722*color.b)+12.75
        if bgLum > fgLum {
            return 1.6 < bgLum/fgLum
        } else {
            return 1.6 < fgLum/bgLum
        }
    }
    
    var color: Color {
        Color(.displayP3, red: r/255, green: g/255, blue: b/255, opacity: 1)
        //        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
    
    var pretty: String {
        return "\(Int(self.r)), \(Int(self.g)), \(Int(self.b))"
    }
}
