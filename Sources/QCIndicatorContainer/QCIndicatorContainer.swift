
import UIKit

public final class QCIndicatorContainer {
 
    // private variables
    internal var tempWindows = [UIWindow]()
    internal var accessNames = [String]()
    internal var vcRefrences = [UIViewController]()
    
    fileprivate(set) public var horizontalPosition:Horizontal = .center
    fileprivate(set) public var verticalPosition:Vertical = .center
    fileprivate(set) public var padding:UIEdgeInsets = .init(value: 0.0)
    fileprivate(set) public var shouldUseMargins:Bool = true
    
    
    // initialisers
    public init() {}
    public static let shared = QCIndicatorContainer()
    
    
    // constants
    internal let viewID:String = "viewID"
    
    
    // public functions
    
    public func showIndicator(for vc:UIViewController,indicatorView view:UIView,indicatorSize size:CGSize) {
        
        let indicatorWindow = UIWindow()
        indicatorWindow.backgroundColor = UIColor.clear
        indicatorWindow.addSubview(view)
        
        observeOrientationChange()
        
        view.accessibilityLabel = viewID
        givePosition(to: view, for: size, margins: margins(vc))
        
        indicatorWindow.windowLevel = UIWindow.Level.alert
        indicatorWindow.rootViewController = UIViewController()
        indicatorWindow.center = giveScreenCenter()
        indicatorWindow.isHidden = false
        
        let id = UUID().uuidString
        indicatorWindow.accessibilityLabel = id
        
        vcRefrences.append(vc)
        accessNames.append(id)
        tempWindows.append(indicatorWindow)
    }
    
    public func hideIndicator() {
        
        for window in tempWindows.enumerated() {
            
            if window.element.accessibilityLabel == accessNames[window.offset] {
                
                tempWindows.remove(at: window.offset)
                accessNames.remove(at: window.offset)
                vcRefrences.remove(at: window.offset)
                
                break
            }
        }
        
        if tempWindows.isEmpty {
            removeOrientationObserver()
        }
    }
    
    
    // setter functions
    @discardableResult
    public func setHorizontalPosition(_ position:Horizontal) -> QCIndicatorContainer {
        self.horizontalPosition = position
        return self
    }
    @discardableResult
    public func setVerticalPosition(_ position:Vertical) -> QCIndicatorContainer {
        self.verticalPosition = position
        return self
    }
    @discardableResult
    public func setPadding(_ value:CGFloat) -> QCIndicatorContainer {
        self.padding = .init(value: value)
        return self
    }
    @discardableResult
    public func setShouldUseMargins(_ bool:Bool) -> QCIndicatorContainer {
        self.shouldUseMargins = bool
        return self
    }

}
