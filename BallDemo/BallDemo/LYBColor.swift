//
//  LYBColor.swift
//  ColorsByNameLite
//
//  Created by Yuan Zhang on 12/1/15.
//  Copyright © 2015 Yubo Liu. All rights reserved.
//

import UIKit


enum LYBColorError: ErrorType{
    
    case HexInvalid
    
    case RComponentInvalid
    case GComponentInvalid
    case BComponentInvalid
    case AComponentInvalid
    
    case HComponentInvalid
    case SComponentInvalid
    case LComponentInvalid
    case VComponentInvalid
    
    case CComponentInvalid
    case MComponentInvalid
    case YComponentInvalid
    case KComponentInvalid
    
    case ParameterInvalid
}


class LYBColor : CustomStringConvertible{
    
    // TODO: not quite sure use this method to control access is the best way
    //format: #aaaaaa
    private var _hex: String!
    var hex: String{ return self._hex.lowercaseString }
    
    //red: 0...255 ; green: 0...255 ; blue: 0...255
    private var uRed: UInt8!
    private var uGreen: UInt8!
    private var uBlue: UInt8!
    private var uAlpha: UInt8!
    
    //hue: 0.0..<1.0 ; saturation: 0.0...1.0 ; brightness: 0.0...1.0 = value
    private var fHue: Float!
    private var fSaturation: Float!
    private var fBrightness: Float!
    private var fValue: Float { return fBrightness }
    
    lazy var uiColor : UIColor = {
        return UIColor(red: CGFloat(self.uRed)/255.0, green: CGFloat(self.uGreen)/255.0 , blue: CGFloat(self.uBlue)/255.0 , alpha: CGFloat(self.uAlpha)/255.0 )
    }()
    
    
    // MARK: - init
    init?( hex: String ){

        do{
            let RGB = try LYBColor.convertHexToRGB(hex)
            
            self._hex = hex
            
            self.uRed = RGB.R
            self.uGreen = RGB.G
            self.uBlue = RGB.B
            self.uAlpha = 255
            
            let hsb = try! LYBColor.convertRGBToHSB(red: Int(RGB.R), green: Int(RGB.G), blue: Int(RGB.B) )
            self.fHue = hsb.H
            self.fSaturation = hsb.S
            self.fBrightness = hsb.B
        }
        catch{
            return nil
        }
    }
    
    
    init?( red: Int , green: Int , blue: Int , alpha: Int = 255 ){
        
        guard red   >= 0 && red   < 256  else{ return nil }
        guard green >= 0 && green < 256  else{ return nil }
        guard blue  >= 0 && blue  < 256  else{ return nil }
        guard alpha >= 0 && alpha < 256  else{ return nil }
        
        self.uRed = UInt8(red)
        self.uGreen = UInt8(green)
        self.uBlue = UInt8(blue)
        self.uAlpha = UInt8(alpha)
        
        self._hex = try! LYBColor.convertRGBToHex( red: red, green: green, blue: blue)
        
        let hsb = try! LYBColor.convertRGBToHSB(red: red, green: green, blue: blue )
        self.fHue = hsb.H
        self.fSaturation = hsb.S
        self.fBrightness = hsb.B
    }
    
    
    init?( hue: Float , saturation: Float , brightness: Float , alpha: Float = 1.0 ){
        
        guard hue >= 0.0        && hue < 1.0         else{ return nil }
        guard saturation >= 0.0 && saturation <= 1.0 else{ return nil }
        guard brightness >= 0.0 && brightness <= 1.0 else{ return nil }
        guard alpha >= 0.0      && alpha <= 1.0      else{ return nil }
    
        self.fHue = hue
        self.fSaturation = saturation
        self.fBrightness = brightness
        self.uAlpha = UInt8( round(alpha*255) )
        
        let theColor = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: CGFloat(alpha) )
        
        var red:CGFloat = 0.0
        var green:CGFloat = 0.0
        var blue:CGFloat = 0.0
        var t_alpha:CGFloat = 0.0
        theColor.getRed(&red, green: &green, blue: &blue, alpha: &t_alpha)
        
        self.uRed = UInt8( round(red*255) )
        self.uGreen = UInt8( round(green*255) )
        self.uBlue = UInt8( round(blue*255) )
        
        self._hex = try! LYBColor.convertRGBToHex(red: Int(self.uRed), green: Int(self.uGreen), blue: Int(self.uBlue) )
    }
    
    
    convenience init( color: UIColor ){
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.init( red: Int(red*255) , green: Int(green*255) , blue: Int(blue*255) , alpha: Int(alpha*255) )!
    }
    
    
    // MARK: - lazy variables
    lazy var uint8RGBA: ( R: UInt8 , G: UInt8 , B: UInt8 , A: UInt8) = {
        return ( R: self.uRed! , G: self.uGreen! , B: self.uBlue! , A: self.uAlpha! )
    }()
    
    lazy var floatRGBAPercent: ( R: Float , G: Float , B: Float , A: Float) = {
        return ( R: Float(self.uRed)/255.0 , G: Float(self.uGreen)/255.0 , B: Float(self.uBlue)/255.0 , A: Float(self.uAlpha)/255.0 )
    }()
    
    lazy var uintCMYK: ( C: UInt , M: UInt , Y: UInt , K: UInt ) = {
        
        let cmyk = try! LYBColor.convertRGBToCMYK(red: Int(self.uRed), green: Int(self.uGreen), blue: Int(self.uBlue) )
        
        return ( C: UInt(round(cmyk.C*100)) , M: UInt(round(cmyk.M*100)) , Y: UInt(round(cmyk.Y*100)) , K: UInt(round(cmyk.K*100)) )
    }()
    
    lazy var floatCMYK: ( C: Float , M: Float , Y: Float , K: Float ) = {
        
        return try! LYBColor.convertRGBToCMYK( red: Int(self.uRed), green: Int(self.uGreen), blue: Int(self.uBlue) )
    }()
    
    lazy var floatHSB: ( H: Float , S: Float , B: Float ) = {
        return ( H: self.fHue! , S: self.fSaturation! , B: self.fBrightness! )
    }()
    
    lazy var floatHSV: ( H: Float , S: Float , V: Float ) = {
        return ( H: self.fHue! , S: self.fSaturation! , V: self.fBrightness! )
    }()
    
    lazy var floatHSL: ( H: Float , S: Float , L: Float ) = {
        
        return try! LYBColor.convertRGBToHSL(red: Int(self.uRed), green: Int(self.uGreen), blue: Int(self.uBlue) )
    }()
    
    lazy var webSafeColor:LYBColor? = {
        // TODO: implement web safe color
        return nil
    }()
    
    
    // MARK: - description
    var description: String{
        return self.hex
    }
    
    
    // MARK: - Custom functions
    func distanceSquareTo( anotherColor: LYBColor ) -> UInt{
        let anotherRGBA = anotherColor.uint8RGBA
        let rD:Int = Int(self.uRed) - Int(anotherRGBA.R)
        let rG:Int = Int(self.uGreen) - Int(anotherRGBA.G)
        let rB:Int = Int(self.uBlue) - Int(anotherRGBA.B)
        
        return UInt( rD*rD + rG*rG + rB*rB )
    }
    
    func distanceTo( anotherColor: LYBColor ) -> Float{
        
        let distanceSquare = Float( self.distanceSquareTo( anotherColor ) )
        return sqrt(distanceSquare)
    }
}


// MARK: - extension for class convert methods
extension LYBColor{
    
    static func isValidHex( hex: String ) ->Bool{
        
        let regex = try! NSRegularExpression(pattern: "^#[0-9A-Fa-f]{6}$", options: .CaseInsensitive)
        let matchRange = regex.rangeOfFirstMatchInString(hex, options: .ReportProgress, range: NSMakeRange(0, hex.characters.count))
        
        return matchRange.location != NSNotFound
    }
    
    
    static func convertRGBToHex( red red: Int , green: Int , blue: Int ) throws -> String{
        
        guard red   >= 0 && red   < 256  else{ throw LYBColorError.RComponentInvalid }
        guard green >= 0 && green < 256  else{ throw LYBColorError.GComponentInvalid }
        guard blue  >= 0 && blue  < 256  else{ throw LYBColorError.BComponentInvalid }
        
        var rPart = String( red , radix: 16)
        if rPart.characters.count == 1{ rPart = "0"+rPart }
        
        var gPart = String( green , radix: 16)
        if gPart.characters.count == 1{ gPart = "0"+gPart }
        
        var bPart = String( blue , radix: 16)
        if bPart.characters.count == 1{ bPart = "0"+bPart }
        
        return ( "#" + rPart + gPart + bPart ).lowercaseString
    }
    
    
    static func convertRGBToCMYK( red red: Int , green: Int , blue: Int ) throws -> (C: Float , M: Float , Y: Float , K: Float ){
        
        guard red   >= 0 && red   < 256  else{ throw LYBColorError.RComponentInvalid }
        guard green >= 0 && green < 256  else{ throw LYBColorError.GComponentInvalid }
        guard blue  >= 0 && blue  < 256  else{ throw LYBColorError.BComponentInvalid }
        
        let floatR = Float( red ) / 255
        let floatG = Float( green ) / 255
        let floatB = Float( blue ) / 255
        
        let resK:Float = 1 - max( floatR , floatG , floatB )
        
        let div = max( red , green , blue ) == 255 ? 1.0 : 1.0 - resK
        
        let resC = (1.0-floatR-resK)/div
        let resM = (1.0-floatG-resK)/div
        let resY = (1.0-floatB-resK)/div
        
        return ( C: resC , M: resM , Y: resY , K: resK )
        
    }
    
    
    static func convertRGBToHSB( red red: Int , green: Int , blue: Int ) throws -> (H: Float , S: Float , B: Float ){
    
        guard red   >= 0 && red   < 256  else{ throw LYBColorError.RComponentInvalid }
        guard green >= 0 && green < 256  else{ throw LYBColorError.GComponentInvalid }
        guard blue  >= 0 && blue  < 256  else{ throw LYBColorError.BComponentInvalid }
        
        var resH:CGFloat = 0.0
        var resS:CGFloat = 0.0
        var resB:CGFloat = 0.0
        var resA:CGFloat = 0.0
        let theColor = UIColor(intRed: red, intGreen: green, intBlue: blue)
        
        theColor!.getHue(&resH, saturation: &resS, brightness: &resB, alpha: &resA)
        
        return ( H: Float(resH) , S: Float(resS) , B: Float(resB) )
    }
    
    
    static func convertRGBToHSV( red red: Int , green: Int , blue: Int ) throws -> (H: Float , S: Float , V: Float ){
        
        do{
            let hsb = try LYBColor.convertRGBToHSB(red: red, green: green, blue: blue )
            return (H: hsb.H , S: hsb.S , V: hsb.B )
        }
        catch let error as LYBColorError{
            throw error
        }
    }
    
    
    static func convertRGBToHSL( red red: Int , green: Int , blue: Int ) throws -> (H: Float , S: Float , L: Float ){
    
        guard red   >= 0 && red   < 256  else{ throw LYBColorError.RComponentInvalid }
        guard green >= 0 && green < 256  else{ throw LYBColorError.GComponentInvalid }
        guard blue  >= 0 && blue  < 256  else{ throw LYBColorError.BComponentInvalid }
        
        var theH:CGFloat = 0.0
        var theS:CGFloat = 0.0
        var theB:CGFloat = 0.0
        var theA:CGFloat = 0.0
        let theColor = UIColor(intRed: red, intGreen: green, intBlue: blue)
        theColor!.getHue(&theH, saturation: &theS, brightness: &theB, alpha: &theA)
        
        let floatR = Float( red ) / 255
        let floatG = Float( green ) / 255
        let floatB = Float( blue ) / 255
        
        let Cmax = max( floatR , floatG , floatB )
        let Cmin = min( floatR , floatG , floatB )
        let delta = Cmax - Cmin
        
        let resL = (Cmax+Cmin)/2
        let resS:Float = max( red , green , blue ) == min( red , green , blue ) ? 0 : delta/(1-abs(2*resL-1))
        
        return ( H: Float(theH) , S: resS , L: resL )
    }
    
    
    static func convertHexToRGB( hex: String ) throws -> (R: UInt8 , G: UInt8 , B: UInt8 ){
        
        guard LYBColor.isValidHex(hex) else{
            throw LYBColorError.HexInvalid
        }
        
        let nshex = hex as NSString
        let start = 1
        let red = UInt8(nshex.substringWithRange(NSRange(location: start, length: 2)) , radix:16)
        let green = UInt8(nshex.substringWithRange(NSRange(location: start+2, length: 2)) , radix:16)
        let blue = UInt8(nshex.substringWithRange(NSRange(location: start+4, length: 2)) , radix:16)
        
        return (R: red! , G: green! , B: blue!)
    }
    
    
    static func convertCMYKToRGB( C C: Float , M: Float , Y: Float , K: Float ) throws -> ( R: UInt8 , G: UInt8 , B: UInt8 ){
        
        guard C >= 0.0 && C <= 1.0  else{ throw LYBColorError.CComponentInvalid }
        guard M >= 0.0 && M <= 1.0  else{ throw LYBColorError.MComponentInvalid }
        guard Y >= 0.0 && Y <= 1.0  else{ throw LYBColorError.YComponentInvalid }
        guard K >= 0.0 && K <= 1.0  else{ throw LYBColorError.KComponentInvalid }
        
        return ( R: UInt8(255*(1-C)*(1-K)) , G: UInt8(255*(1-M)*(1-K)) , B: UInt8(255*(1-Y)*(1-K)) )
    }
    
    
    static func convertHSBToRGB( hue hue: Float , saturation: Float , brightness: Float ) throws -> ( R: UInt8 , G: UInt8 , B: UInt8 ){
        
        guard hue        >= 0.0 && hue        < 1.0  else{ throw LYBColorError.HComponentInvalid }
        guard saturation >= 0.0 && saturation <= 1.0  else{ throw LYBColorError.SComponentInvalid }
        guard brightness >= 0.0 && brightness <= 1.0  else{ throw LYBColorError.VComponentInvalid }
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        let theColor = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
        
        theColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (R: UInt8(round(red*255)) , G: UInt8(round(green*255)) , B: UInt8(round(blue*255)) )
    }
    
    
    static func convertHSVToRGB( hue hue: Float , saturation: Float , value: Float ) throws -> ( R: UInt8 , G: UInt8 , B: UInt8 ){
        
        do{
            return try LYBColor.convertHSBToRGB(hue: hue, saturation: saturation, brightness: value)
        }
        catch let error as LYBColorError{
            throw error
        }
    }
    
    
    static func convertHSLToRGB( var hue hue: Float , S: Float , L: Float ) throws -> ( R: UInt8 , G: UInt8 , B: UInt8 ){
        
        guard hue >= 0.0 && hue < 1.0   else{ throw LYBColorError.HComponentInvalid }
        guard S   >= 0.0 && S   <= 1.0  else{ throw LYBColorError.SComponentInvalid }
        guard L   >= 0.0 && L   <= 1.0  else{ throw LYBColorError.LComponentInvalid }
        
        hue *= 360
        
        let C = ( 1 - abs(2*L-1) ) * S
        let X = C * ( 1 - abs( (hue/60.0) % 2.0 - 1 ) )
        let m = L - C/2
        
        var r: Float = 0.0
        var g: Float = 0.0
        var b: Float = 0.0
        switch( hue ){
        case hue where hue >= 0 && hue < 60:
            r = C
            g = X
        case hue where hue >= 60 && hue < 120:
            r = X
            g = C
        case hue where hue >= 120 && hue < 180:
            g = C
            b = X
        case hue where hue >= 180 && hue < 240:
            g = X
            b = C
        case hue where hue >= 240 && hue < 300:
            r = X
            b = C
        case hue where hue >= 300 && hue < 360:
            r = C
            b = X
        default:
            break
        }
        
        return ( R: UInt8((r+m)*255) , G: UInt8((g+m)*255) , B: UInt8((b+m)*255) )
    }
    
}


// MARK: - extension for generative colors
extension LYBColor{
    
    func gradientColorsToUIColor( targetColor: UIColor , count: Int ) -> [LYBColor]{
        
        var rTo:CGFloat = 0.0
        var gTo:CGFloat = 0.0
        var bTo:CGFloat = 0.0
        var alpha:CGFloat = 0.0
        targetColor.getRed( &rTo, green: &gTo, blue: &bTo, alpha: &alpha )
        
        var rFrom:CGFloat = 0.0
        var gFrom:CGFloat = 0.0
        var bFrom:CGFloat = 0.0
        self.uiColor.getRed( &rFrom , green: &gFrom , blue: &bFrom , alpha: &alpha )
        
        let rStep:CGFloat = (rTo - rFrom) / CGFloat(count-1)
        let gStep:CGFloat = (gTo - gFrom) / CGFloat(count-1)
        let bStep:CGFloat = (bTo - bFrom) / CGFloat(count-1)
        
        var res:[LYBColor] = [self]
        for i in 1..<count{
            res.append(
                LYBColor( color: UIColor(   red: rFrom + rStep * CGFloat(i),
                    green: gFrom + gStep * CGFloat(i),
                    blue: bFrom + bStep * CGFloat(i),
                    alpha: 1.0 ) ) )
        }
        
        return res
    }
    
    func gradientColorsToRed( red: Int , green: Int , blue: Int , count: Int ) throws -> [LYBColor]{
        
        guard red   >= 0 && red   < 256  else{ throw LYBColorError.RComponentInvalid }
        guard green >= 0 && green < 256  else{ throw LYBColorError.GComponentInvalid }
        guard blue  >= 0 && blue  < 256  else{ throw LYBColorError.BComponentInvalid }
        guard count >  0                 else{ throw LYBColorError.ParameterInvalid  }
        
        return self.gradientColorsToUIColor( UIColor(intRed: red, intGreen: green, intBlue: blue)!, count: count)
    }
    
    func gradientColorsToLYBColor( targetColor: LYBColor , count: Int ) -> [LYBColor]{
        
        return self.gradientColorsToUIColor( targetColor.uiColor , count: count )
    }
    
    func gradientColorsToHex( targetHex: String , count: Int ) throws -> [LYBColor]{
        
        guard LYBColor.isValidHex( targetHex ) else { throw LYBColorError.ParameterInvalid }
        return self.gradientColorsToUIColor( UIColor(hex: targetHex)!, count: count )
    }
    
    
    func complementaryColor() -> [LYBColor]{
        
        let hsb = self.floatHSB
        let newH = ( hsb.H + 0.5 ) % 1.0
        return [ self ,
                 LYBColor(hue: newH, saturation: hsb.S, brightness: hsb.B)! ]
    }
    
    
    func nalogousColors() -> [LYBColor]{
        
        let hsb = self.floatHSB
        let newH1 = hsb.H - 1.0/12.0 < 0.0 ? hsb.H - 1.0/12.0 + 1.0 : hsb.H - 1.0/12.0
        let newH2 = ( hsb.H + 1.0/12.0 ) % 1.0
        return [LYBColor(hue: newH1 , saturation: hsb.S , brightness: hsb.B)!,
                self,
                LYBColor(hue: newH2 , saturation: hsb.S , brightness: hsb.B)!
                ]
    }
    
    
    func splitComplementaryColors() -> [LYBColor]{
        
        let hsb = self.floatHSB
        let newH1 = hsb.H - 5.0/12.0 < 0.0 ? hsb.H - 5.0/12.0 + 1.0 : hsb.H - 5.0/12.0
        let newH2 = ( hsb.H + 5.0/12.0 ) % 1.0
        return [LYBColor(hue: newH1 , saturation: hsb.S , brightness: hsb.B)!,
                self,
                LYBColor(hue: newH2 , saturation: hsb.S , brightness: hsb.B)!
                ]
    }
    
    func triadicColors() -> [LYBColor]{
        
        let hsb = self.floatHSB
        let newH1 = hsb.H - 4.0/12.0 < 0.0 ? hsb.H - 4.0/12.0 + 1.0 : hsb.H - 4.0/12.0
        let newH2 = ( hsb.H + 4.0/12.0 ) % 1.0
        return [LYBColor(hue: newH1 , saturation: hsb.S , brightness: hsb.B)!,
            self,
            LYBColor(hue: newH2 , saturation: hsb.S , brightness: hsb.B)!
        ]
    }
    
    func tetradicColors() -> [LYBColor]{
        
        let hsb = self.floatHSB
        let newH1 = hsb.H - 2.0/12.0 < 0.0 ? hsb.H - 2.0/12.0 + 1.0 : hsb.H - 2.0/12.0
        let newH2 = ( hsb.H + 4.0/12.0 ) % 1.0
        let newH3 = ( hsb.H + 6.0/12.0 ) % 1.0
        return [LYBColor(hue: newH1 , saturation: hsb.S , brightness: hsb.B)!,
                self,
                LYBColor(hue: newH2 , saturation: hsb.S , brightness: hsb.B)!,
                LYBColor(hue: newH3 , saturation: hsb.S , brightness: hsb.B)!
                ]
    }
    
    func squareColors() -> [LYBColor]{
        
        let hsb = self.floatHSB
        let newH1 = hsb.H - 4.0/12.0 < 0.0 ? hsb.H - 4.0/12.0 + 1.0 : hsb.H - 4.0/12.0
        let newH2 = ( hsb.H + 4.0/12.0 ) % 1.0
        let newH3 = ( hsb.H + 8.0/12.0 ) % 1.0
        return [LYBColor(hue: newH1 , saturation: hsb.S , brightness: hsb.B)!,
            self,
            LYBColor(hue: newH2 , saturation: hsb.S , brightness: hsb.B)!,
            LYBColor(hue: newH3 , saturation: hsb.S , brightness: hsb.B)!
        ]
    }
    
    func monochromaticColors() -> [LYBColor]{
    
        let hsb = self.floatHSB
        
        let sUpDiff = (1.0-hsb.S)/2.5
        let sDownDiff = hsb.S/2.5
        
        let vUpDiff = (1.0-hsb.B)/2.0
        let vDownDiff = hsb.B/2.0
        
        return [LYBColor( hue: hsb.H ,
                          saturation: ( hsb.S + sUpDiff*3.0/3.0 )%1.0 ,
                          brightness: hsb.B - vDownDiff*3.0/3.0 < 0.0 ? hsb.B - vDownDiff*3.0/3.0 + 1.0 : hsb.B - vDownDiff*3.0/3.0 )!,
                LYBColor( hue: hsb.H ,
                          saturation: ( hsb.S + sUpDiff*2.0/3.0 )%1.0 ,
                          brightness: hsb.B - vDownDiff*2.0/3.0 < 0.0 ? hsb.B - vDownDiff*2.0/3.0 + 1.0 : hsb.B - vDownDiff*2.0/3.0 )!,
                LYBColor( hue: hsb.H ,
                          saturation: ( hsb.S + sUpDiff*1.0/3.0 )%1.0 ,
                          brightness: hsb.B - vDownDiff*1.0/3.0 < 0.0 ? hsb.B - vDownDiff*1.0/3.0 + 1.0 : hsb.B - vDownDiff*1.0/3.0 )!,
                self,
                LYBColor( hue: hsb.H ,
                          saturation: hsb.S - sDownDiff*1.0/3.0 < 0.0 ? hsb.S - sDownDiff*1.0/3.0 + 1.0 : hsb.S - sDownDiff*1.0/3.0 ,
                          brightness: ( hsb.B + vUpDiff*1.0/3.0 )%1.0 )!,
                LYBColor( hue: hsb.H ,
                          saturation: hsb.S - sDownDiff*2.0/3.0 < 0.0 ? hsb.S - sDownDiff*2.0/3.0 + 1.0 : hsb.S - sDownDiff*2.0/3.0 ,
                          brightness: ( hsb.B + vUpDiff*2.0/3.0 )%1.0 )!,
                LYBColor( hue: hsb.H ,
                          saturation: hsb.S - sDownDiff*3.0/3.0 < 0.0 ? hsb.S - sDownDiff*3.0/3.0 + 1.0 : hsb.S - sDownDiff*3.0/3.0 ,
                          brightness: ( hsb.B + vUpDiff*3.0/3.0 )%1.0 )!
                ]
    }
    
    func toneColors( count: Int ) -> [LYBColor]{
    
        let hsl = self.floatHSL
        let S = hsl.S
        let step1 = 1.0/Float(count-1)
        
        var nearestIndex = 0
        var nearestSDistance = S
        for i in 1..<count{
            if abs( Float(i)*step1 - S ) < nearestSDistance{
                nearestSDistance = abs( Float(i)*step1 - S )
                nearestIndex = i
            }
        }
        
        let theIndex = nearestIndex
        //print("theIndex = \(theIndex) in toneColors")
        
        var frontPart:[LYBColor] = []
        if theIndex != 0{
            let frontPartStep = S / Float(theIndex)
            for i in 0..<theIndex{
                let RGBA = try! LYBColor.convertHSLToRGB(hue: hsl.H, S: S-Float(i+1)*frontPartStep, L: hsl.L)
                frontPart.append( LYBColor( red: Int(RGBA.R), green: Int(RGBA.G), blue: Int(RGBA.B) )! )
            }
        }
        //print("frontPart count = \(frontPart.count)")
        
        var endPart:[LYBColor] = []
        if theIndex != count - 1{
            let endPartStep = S / Float( count - 1 - theIndex )
            for i in (theIndex+1)..<count{
                let index = i - theIndex
                let RGBA = try! LYBColor.convertHSLToRGB(hue: hsl.H, S: S+Float(index)*endPartStep, L: hsl.L)
                endPart.append( LYBColor( red: Int(RGBA.R), green: Int(RGBA.G), blue: Int(RGBA.B) )! )
            }
        }
        //print("endPart count = \(endPart.count)")
        
        return  endPart.reverse() + [self] + frontPart
    }
    
}


// MARK: - extension for equatable
extension LYBColor: Equatable{}
func ==(lhs: LYBColor , rhs: LYBColor) -> Bool{
    return lhs.hex == rhs.hex
}


// MARK: - extension for UIColor
extension UIColor{
    
    convenience init?( hex:String ){
        
        do{
            let RGB = try LYBColor.convertHexToRGB(hex)
            self.init(red: CGFloat(RGB.R)/255.0, green: CGFloat(RGB.G)/255.0, blue: CGFloat(RGB.B)/255.0, alpha: 1.0)
        }
        catch{
            return nil
        }
    }
    
    convenience init?( intRed: Int , intGreen: Int , intBlue: Int , intAlpha: Int = 255 ){
        
        guard intRed   >= 0 && intRed   < 256  else{ return nil }
        guard intGreen >= 0 && intGreen < 256  else{ return nil }
        guard intBlue  >= 0 && intBlue  < 256  else{ return nil }
        guard intAlpha >= 0 && intAlpha < 256  else{ return nil }
        
        self.init(red: CGFloat(intRed)/255.0, green: CGFloat(intGreen)/255.0 , blue: CGFloat(intBlue)/255.0 , alpha: CGFloat(intAlpha)/255.0 )
    }
    
    var lybColor:LYBColor{
        
        var red:CGFloat = 0.0
        var green:CGFloat = 0.0
        var blue:CGFloat = 0.0
        var alpha:CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return LYBColor(red: Int(round(red*255)), green: Int(round(green*255)), blue: Int(round(blue*255)), alpha: Int(round(alpha*255)))!
    }
    
    var hex:String {

        return self.lybColor.hex
    }
    
}