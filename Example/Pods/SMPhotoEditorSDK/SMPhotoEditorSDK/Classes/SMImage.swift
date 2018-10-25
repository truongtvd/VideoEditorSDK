//
//  SMImage.swift
//  Pods-SMImageEditorSDK_Example
//
//  Created by Nguyễn Đình Đông on 10/22/18.
//

//Phần này xử lý chuyên sâu về image, giá trị trả về là 1 CIImage

import Foundation
import CoreImage

open class SMImage : NSObject {
    
    let context = CIContext()
    
    private class func convert(cmage:CIImage) -> CIImage {
        return cmage
    }
    
    //MARK:- CICategoryBlur
    
    //CIBoxBlur
    public class func CIBoxBlur(_ inputImage:CIImage,
                                _ inputRadius:NSNumber = 10.00) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputRadius, forKey: kCIInputRadiusKey)
        
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIDiscBlur
    public class func CIDiscBlur(_ inputImage:CIImage,
                                 _ inputRadius:NSNumber = 8.00) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputRadius, forKey: kCIInputRadiusKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIGaussianBlur
    public class func CIGaussianBlur(_ inputImage:CIImage,
                                     _ inputRadius:NSNumber = 10.00) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputRadius, forKey: kCIInputRadiusKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIMaskedVariableBlur
    public class func CIMaskedVariableBlur(_ inputImage:CIImage,
                                           _ inputMask:CIImage,
                                           _ inputRadius:NSNumber = 10.00) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputMask, forKey: kCIInputMaskImageKey)
        filter?.setValue(inputRadius, forKey: kCIInputRadiusKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIMedianFilter
    public class func CIMedianFilter(_ inputImage:CIImage) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIMotionBlur
    public class func CIMotionBlur(_ inputImage:CIImage,
                                   _ inputRadius:NSNumber = 10.00,
                                   _ inputAngle:NSNumber = 0.00) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputRadius, forKey: kCIInputRadiusKey)
        filter?.setValue(inputAngle, forKey: kCIInputAngleKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CINoiseReduction
    public class func CINoiseReduction(_ inputImage:CIImage,
                                       _ inputNoiseLevel:NSNumber = 0.02,
                                       _ inputSharpness:NSNumber = 0.40) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputNoiseLevel, forKey: "inputNoiseLevel")
        filter?.setValue(inputSharpness, forKey: "inputSharpness")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIZoomBlur
    public class func CIZoomBlur(_ inputImage:CIImage,
                                 _ inputCenter:CIVector = CIVector(x: 150, y: 150),
                                 _ inputAmount:NSNumber = 20.00) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputAmount, forKey: "inputAmount")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //-[END CICategoryBlur]-
    
    
    //MARK:- CICategoryColorAdjustment
    //CIColorClamp
    public class func CIColorClamp(_ inputImage:CIImage,
                                   _ inputMinComponents:CIVector = CIVector.init(x: 0, y: 0, z: 0, w: 0),
                                   _ inputMaxComponents:CIVector = CIVector.init(x: 1, y: 1, z: 1, w: 1)) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputMinComponents, forKey:"inputMinComponents")
        filter?.setValue(inputMaxComponents, forKey: "inputMaxComponents")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIColorControls
    public class func CIColorControls(_ inputImage:CIImage,
                                      _ inputSaturation:NSNumber = 1.00,
                                      _ inputBrightness:NSNumber = 1.00,
                                      _ inputContrast:NSNumber = 1.00) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputSaturation, forKey: "inputSaturation")
        filter?.setValue(inputBrightness, forKey: "inputBrightness")
        filter?.setValue(inputContrast, forKey: "inputContrast")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIColorMatrix
    public class func CIColorMatrix(_ inputImage:CIImage,
                                    _ inputRVector:CIVector = CIVector.init(x: 1, y: 0, z: 0, w: 0),
                                    _ inputGVector:CIVector = CIVector.init(x: 0, y: 1, z: 0, w: 0),
                                    _ inputBVector:CIVector = CIVector.init(x: 0, y: 0, z: 1, w: 0),
                                    _ inputAVector:CIVector = CIVector.init(x: 0, y: 0, z: 0, w: 1),
                                    _ inputBiasVector:CIVector = CIVector.init(x: 0, y: 0, z: 0, w: 0)) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputRVector, forKey: "inputRVector")
        filter?.setValue(inputGVector, forKey: "inputGVector")
        filter?.setValue(inputBVector, forKey: "inputBVector")
        filter?.setValue(inputAVector, forKey: "inputAVector")
        filter?.setValue(inputBiasVector, forKey: "inputBiasVector")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIColorPolynomial
    public class func CIColorPolynomial(_ inputImage:CIImage,
                                        _ inputRedCoefficients:CIVector = CIVector.init(x: 1, y: 0, z: 0, w: 0),
                                        _ inputGreenCoefficients:CIVector = CIVector.init(x: 0, y: 1, z: 0, w: 0),
                                        _ inputBlueCoefficients:CIVector = CIVector.init(x: 0, y: 0, z: 1, w: 0),
                                        _ inputAlphaCoefficients:CIVector = CIVector.init(x: 0, y: 0, z: 0, w: 1)
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputRedCoefficients, forKey: "inputRedCoefficients")
        filter?.setValue(inputGreenCoefficients, forKey: "inputGreenCoefficients")
        filter?.setValue(inputBlueCoefficients, forKey: "inputBlueCoefficients")
        filter?.setValue(inputAlphaCoefficients, forKey: "inputAlphaCoefficients")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIExposureAdjust
    public class func CIExposureAdjust(_ inputImage:CIImage,
                                       _ inputEV:NSNumber = 0.50 ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputEV, forKey: "inputEV")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    
    //CIGammaAdjust
    public class func CIGammaAdjust(_ inputImage:CIImage,
                                    _ inputPower:NSNumber = 0.75 ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputPower, forKey: "inputPower")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIHueAdjust
    public class func CIHueAdjust(_ inputImage:CIImage,
                                  _ inputAngle:NSNumber = 0.00 ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputAngle, forKey: "inputAngle")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CILinearToSRGBToneCurve
    public class func CILinearToSRGBToneCurve(_ inputImage:CIImage) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CISRGBToneCurveToLinear
    public class func CISRGBToneCurveToLinear(_ inputImage:CIImage) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CITemperatureAndTint
    public class func CITemperatureAndTint(_ inputImage:CIImage,
                                           _ inputNeutral:CIVector = CIVector.init(x: 6500, y: 0),
                                           _ inputTargetNeutral:CIVector = CIVector.init(x: 6500, y: 0)
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputNeutral, forKey: "inputNeutral")
        filter?.setValue(inputTargetNeutral, forKey: "inputTargetNeutral")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIToneCurve
    public class func CIToneCurve(_ inputImage:CIImage,
                                  _ inputPoint0:CIVector = CIVector.init(x: 0, y: 0),
                                  _ inputPoint1:CIVector = CIVector.init(x: 0.25, y: 0.25),
                                  _ inputPoint2:CIVector = CIVector.init(x: 0.5, y: 0.5),
                                  _ inputPoint3:CIVector = CIVector.init(x: 0.75, y: 0.75),
                                  _ inputPoint4:CIVector = CIVector.init(x: 1, y: 1)
        
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputPoint0, forKey: "inputPoint0")
        filter?.setValue(inputPoint1, forKey: "inputPoint1")
        filter?.setValue(inputPoint2, forKey: "inputPoint2")
        filter?.setValue(inputPoint3, forKey: "inputPoint3")
        filter?.setValue(inputPoint4, forKey: "inputPoint4")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIVibrance
    public class func CIVibrance(_ inputImage:CIImage,
                                 _ inputAmount:NSNumber = 0.50 ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputAmount, forKey: "inputAmount")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIWhitePointAdjust
    public class func CIWhitePointAdjust(_ inputImage:CIImage,
                                         _ inputColor:CIColor ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputColor, forKey: "inputColor")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //END -[CICategoryColorAdjustment]-
    
    
    //MARK:- CICategoryColorEffect
    
    //CIColorCrossPolynomial
    public class func CIColorCrossPolynomial(_ inputImage:CIImage,
                                             _ inputRedCoefficients:CIVector,
                                             _ inputGreenCoefficients:CIVector,
                                             _ inputBlueCoefficients:CIVector
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputRedCoefficients, forKey: "inputRedCoefficients")
        filter?.setValue(inputGreenCoefficients, forKey: "inputGreenCoefficients")
        filter?.setValue(inputBlueCoefficients, forKey: "inputBlueCoefficients")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIColorCube
    public class func CIColorCube(_ inputImage:CIImage,
                                  _ inputCubeDimension:NSNumber = 2.00,
                                  _ inputCubeData:NSData
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCubeDimension, forKey: "inputCubeDimension")
        filter?.setValue(inputCubeData, forKey: "inputCubeData")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIColorCubeWithColorSpace
    public class func CIColorCubeWithColorSpace(_ inputImage:CIImage,
                                                _ inputCubeDimension:NSNumber = 2.00,
                                                _ inputCubeData:NSData,
                                                _ inputColorSpace:CGColorSpace
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCubeDimension, forKey: "inputCubeDimension")
        filter?.setValue(inputCubeData, forKey: "inputCubeData")
        filter?.setValue(inputColorSpace, forKey: "inputColorSpace")
        
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIColorInvert
    public class func CIColorInvert(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    
    //CIColorMap
    public class func CIColorMap(_ inputImage:CIImage,
                                 _ inputGradientImage:UIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let inputGradient = CIImage.init(image: inputGradientImage)
        
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputGradient, forKey: "inputGradientImage")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    
    //CIColorMonochrome
    public class func CIColorMonochrome(_ inputImage:CIImage,
                                        _ inputColor:CIColor,
                                        _ inputIntensity:NSNumber = 1.00
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputColor, forKey: "inputColor")
        filter?.setValue(inputIntensity, forKey: "inputIntensity")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIColorPosterize
    public class func CIColorPosterize(_ inputImage:CIImage,
                                       _ inputLevels:NSNumber = 6.00
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputLevels, forKey: "inputLevels")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIFalseColor
    public class func CIFalseColor(_ inputImage:CIImage,
                                   _ inputColor0:CIColor,
                                   _ inputColor1:CIColor
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputColor0, forKey: "inputColor0")
        filter?.setValue(inputColor1, forKey: "inputColor1")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    
    //CIMaskToAlpha
    public class func CIMaskToAlpha(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIMaximumComponent
    public class func CIMaximumComponent(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIMinimumComponent
    public class func CIMinimumComponent(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //Restro
    //CIPhotoEffectChrome
    public class func CIPhotoEffectChrome(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIPhotoEffectFade
    public class func CIPhotoEffectFade(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIPhotoEffectInstant
    public class func CIPhotoEffectInstant(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIPhotoEffectMono
    public class func CIPhotoEffectMono(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIPhotoEffectNoir
    public class func CIPhotoEffectNoir(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIPhotoEffectProcess
    public class func CIPhotoEffectProcess(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIPhotoEffectTonal
    public class func CIPhotoEffectTonal(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIPhotoEffectTransfer
    public class func CIPhotoEffectTransfer(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CISepiaTone
    public class func CISepiaTone(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIVignette
    public class func CIVignette(_ inputImage:CIImage
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIVignetteEffect
    public class func CIVignetteEffect(_ inputImage:CIImage,
                                       _ inputCenter:CIVector = CIVector.init(x: 150, y: 150),
                                       _ inputIntensity:NSNumber = 1.00,
                                       _ inputRadius:NSNumber = 0.00
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputIntensity, forKey: "inputIntensity")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    //END -[CICategoryColorAdjustment]-
    
    
    //MARK:- CICategoryCompositeOperation
    
    public enum BlendMode : String{
        
        case  CIAdditionCompositing
        case  CIColorBlendMode
        case  CIColorBurnBlendMode
        case  CIColorDodgeBlendMode
        case  CIDarkenBlendMode
        case  CIDifferenceBlendMode
        case  CIDivideBlendMode
        case  CIExclusionBlendMode
        case  CIHardLightBlendMode
        case  CIHueBlendMode
        case  CILightenBlendMode
        case  CILinearBurnBlendMode
        case  CILinearDodgeBlendMode
        case  CILuminosityBlendMode
        case  CIMaximumCompositing
        case  CIMinimumCompositing
        case  CIMultiplyBlendMode
        case  CIMultiplyCompositing
        case  CIOverlayBlendMode
        case  CIPinLightBlendMode
        case  CISaturationBlendMode
        case  CIScreenBlendMode
        case  CISoftLightBlendMode
        case  CISourceAtopCompositing
        case  CISourceInCompositing
        case  CISourceOutCompositing
        case  CISourceOverCompositing
        case  CISubtractBlendMode
        
        func stringValue() -> String {
            return self.rawValue
        }
    }
    
    //CIAdditionCompositing
    public class func CIBlendMode(_ inputImage:CIImage,
                                  _ inputBackgroundImage:UIImage,
                                  _ mode:BlendMode
        ) -> CIImage {
        
        let ciImage = inputImage
        let bgImage = CIImage.init(image: inputBackgroundImage)
        
        let filter = CIFilter.init(name: mode.stringValue())
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(bgImage, forKey: "inputBackgroundImage")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //MARK:- CICategoryDistortionEffect
    
    //CIBumpDistortion
    public class func CIBumpDistortion(_ inputImage:CIImage,
                                       _ inputCenter:CIVector = CIVector(x: 150, y: 150),
                                       _ inputRadius:NSNumber = 300.00,
                                       _ inputScale:NSNumber = 0.50
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        filter?.setValue(inputScale, forKey: "inputScale")
        
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIBumpDistortionLinear
    public class func CIBumpDistortionLinear(_ inputImage:CIImage,
                                             _ inputCenter:CIVector = CIVector(x: 300, y: 300),
                                             _ inputRadius:NSNumber = 300.00,
                                             _ inputAngle:NSNumber = 0.00,
                                             _ inputScale:NSNumber = 0.50
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        filter?.setValue(inputAngle, forKey: "inputAngle")
        filter?.setValue(inputScale, forKey: "inputScale")
        
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CICircleSplashDistortion
    public class func CICircleSplashDistortion(_ inputImage:CIImage,
                                               _ inputCenter:CIVector = CIVector(x: 150, y: 150),
                                               _ inputRadius:NSNumber = 150.00
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CICircularWrap
    public class func CICircularWrap(_ inputImage:CIImage,
                                     _ inputCenter:CIVector = CIVector(x: 150.00, y: 150.00),
                                     _ inputRadius:NSNumber = 150.00,
                                     _ inputAngle:NSNumber = 0.00
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        filter?.setValue(inputAngle, forKey: "inputAngle")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIDroste
    public class func CIDroste(_ inputImage:CIImage,
                               _ inputInsetPoint0:CIVector = CIVector(x: 200.0, y: 200.0),
                               _ inputInsetPoint1:CIVector = CIVector(x: 400.0, y: 400.0),
                               _ inputStrands:NSNumber = 0.00,
                               _ inputPeriodicity:NSNumber = 0.00,
                               _ inputRotation:NSNumber = 0.00,
                               _ inputZoom:NSNumber = 0.00
        
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputInsetPoint0, forKey: "inputInsetPoint0")
        filter?.setValue(inputInsetPoint1, forKey: "inputInsetPoint1")
        filter?.setValue(inputStrands, forKey: "inputStrands")
        filter?.setValue(inputPeriodicity, forKey: "inputPeriodicity")
        filter?.setValue(inputRotation, forKey: "inputRotation")
        filter?.setValue(inputZoom, forKey: "inputZoom")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIDisplacementDistortion
    public class func CIDisplacementDistortion(_ inputImage:CIImage,
                                               _ inputDisplacementImage:UIImage,
                                               _ inputScale:NSNumber = 50.00
        ) -> CIImage {
        
        let ciImage = inputImage
        let displacementImage = CIImage.init(image: inputDisplacementImage)
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(displacementImage, forKey: "inputDisplacementImage")
        filter?.setValue(inputScale, forKey: "inputScale")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIGlassDistortion
    public class func CIGlassDistortion(_ inputImage:CIImage,
                                        _ inputTexture:UIImage,
                                        _ inputCenter:CIVector = CIVector.init(x: 150.0, y: 150.0),
                                        _ inputScale:NSNumber = 200.0
        ) -> CIImage {
        
        let ciImage = inputImage
        let textureImage = CIImage.init(image: inputTexture)
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(textureImage, forKey: "inputTexture")
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputScale, forKey: "inputScale")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIGlassLozenge
    public class func CIGlassLozenge(_ inputImage:CIImage,
                                     _ inputPoint0:CIVector = CIVector.init(x: 150.0, y: 150.0),
                                     _ inputPoint1:CIVector = CIVector.init(x: 350.0, y: 150.0),
                                     _ inputRadius:NSNumber = 100.0,
                                     _ inputRefraction:NSNumber = 100.0
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputPoint0, forKey: "inputPoint0")
        filter?.setValue(inputPoint1, forKey: "inputPoint1")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        filter?.setValue(inputRefraction, forKey: "inputRefraction")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIHoleDistortion
    public class func CIHoleDistortion(_ inputImage:CIImage,
                                       _ inputCenter:CIVector = CIVector(x: 150, y: 150),
                                       _ inputRadius:NSNumber = 150.00
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CILightTunnel
    public class func CILightTunnel(_ inputImage:CIImage,
                                    _ inputCenter:CIVector = CIVector(x: 150, y: 150),
                                    _ inputRotation:NSNumber = 0.00,
                                    _ inputRadius:NSNumber = 0.00
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputRotation, forKey: "inputRotation")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIPinchDistortion
    public class func CIPinchDistortion(_ inputImage:CIImage,
                                        _ inputCenter:CIVector = CIVector(x: 150, y: 150),
                                        _ inputRadius:NSNumber = 300.0,
                                        _ inputScale:NSNumber = 0.50
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        filter?.setValue(inputScale, forKey: "inputScale")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIStretchCrop
    public class func CIStretchCrop(_ inputImage:CIImage,
                                    _ inputSize:CIVector = CIVector(x: 150, y: 150),
                                    _ inputCropAmount:NSNumber = 0.5,
                                    _ inputCenterStretchAmount:NSNumber = 0.5
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputSize, forKey: "inputSize")
        filter?.setValue(inputCropAmount, forKey: "inputCropAmount")
        filter?.setValue(inputCenterStretchAmount, forKey: "inputCenterStretchAmount")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CITorusLensDistortion
    
    public class func CITorusLensDistortion(_ inputImage:CIImage,
                                            _ inputCenter:CIVector = CIVector(x: 150, y: 150),
                                            _ inputRadius:NSNumber = 160.00,
                                            _ inputWidth:NSNumber = 80.00,
                                            _ inputRefraction:NSNumber = 1.70
        
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        filter?.setValue(inputWidth, forKey: "inputWidth")
        filter?.setValue(inputRefraction, forKey: "inputRefraction")
        
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CITwirlDistortion
    public class func CITwirlDistortion(_ inputImage:CIImage,
                                        _ inputCenter:CIVector = CIVector(x: 150, y: 150),
                                        _ inputRadius:NSNumber = 300.00,
                                        _ inputAngle:NSNumber = 3.14
        
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        filter?.setValue(inputAngle, forKey: "inputAngle")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    //CIVortexDistortion
    public class func CIVortexDistortion(_ inputImage:CIImage,
                                         _ inputCenter:CIVector = CIVector(x: 150, y: 150),
                                         _ inputRadius:NSNumber = 300.00,
                                         _ inputAngle:NSNumber = 56.55
        
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        filter?.setValue(inputAngle, forKey: "inputAngle")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    
    //MARK:- CICategoryGradient
    //CIGaussianGradient
    public class func CIGaussianGradient(_ inputImage:CIImage,
                                         _ inputCenter:CIVector = CIVector(x: 150, y: 150),
                                         _ inputRadius:NSNumber = 300.00,
                                         _ inputAngle:NSNumber = 56.55
        
        ) -> CIImage {
        
        let ciImage = inputImage
        let filter = CIFilter.init(name: "\(#function)")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        filter?.setValue(inputCenter, forKey: "inputCenter")
        filter?.setValue(inputRadius, forKey: "inputRadius")
        filter?.setValue(inputAngle, forKey: "inputAngle")
        
        let output = filter?.outputImage
        return SMImage.convert(cmage: output!)
    }
    
    
    
    
}
