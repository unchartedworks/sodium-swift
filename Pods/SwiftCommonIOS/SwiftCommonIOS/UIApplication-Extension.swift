/**
 # UIApplication-Extension.swift
## SwiftCommonIOS

 - Author: Andrew Bradnan
 - Date: 5/23/16
 - Copyright: © 2016 Belkin. All rights reserved.
*/

import SwiftCommon
#if TARGET_OS_IOS

extension UIApplication {

    public var splashImageName: String? { return self.splashImageNameForOrientation(self.deviceOrientation) }

    public var deviceOrientation : UIDeviceOrientation {
        get {
            switch self.statusBarOrientation {
            case .portrait:
                return .portraitUpsideDown
            case .landscapeLeft:
                return .landscapeRight
            case .landscapeRight:
                return .landscapeLeft
            default:
                return .portrait
            }
        }
    }
    
    internal func splashImageNameForOrientation(_ orientation: UIDeviceOrientation) -> String? {
        var viewSize = UIScreen.main.bounds.size
        
        let viewOrientation = orientation.isPortrait ? "Portrait" : "Landscape"
        if orientation.isLandscape {
            viewSize = viewSize.swap()
        }
        
        if let info = Bundle.main.infoDictionary {
            let i = info["UILaunchImages"]!
            let imagesDict = i as! [[String: String]]
            
            for dict in imagesDict {
                if let szImageSize = dict["UILaunchImageSize"] {
                    let imageSize = CGSizeFromString(szImageSize)
                    if (imageSize.equalTo(viewSize) && viewOrientation == dict["UILaunchImageOrientation"]) {
                        return dict["UILaunchImageName"]
                    }
                }
            }
        }
        return nil
    }
    
}
#endif
