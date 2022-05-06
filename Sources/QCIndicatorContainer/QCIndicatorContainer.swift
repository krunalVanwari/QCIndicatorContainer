
import UIKit

public typealias QCVoidFunc = () -> Void

public final class QCIndicatorContainer:NSObject {
 
    // private variables
    internal var tempWindows = [UIWindow]()
    internal var accessNames = [String]()
    internal var vcRefrences = [UIViewController]()
    internal var timerSource: DispatchSourceTimer?
    internal var completionBlock:QCVoidFunc?
    internal var onTapAction:QCVoidFunc?
    internal var animateView:Bool = true
    
    // public get variables
    fileprivate(set) public var horizontalPosition:Horizontal = .center
    fileprivate(set) public var verticalPosition:Vertical = .center
    fileprivate(set) public var padding:UIEdgeInsets = .init(value: 0.0)
    fileprivate(set) public var shouldUseMargins:Bool = true
    fileprivate(set) public var animation:Animation = .slide
    fileprivate(set) public var animationDuration:CGFloat = 1.0
    fileprivate(set) public var isUserInteractionEnabled:Bool = false
        
    // initialisers
    public override init() {}
    
    // constants
    internal let viewID:String = "viewID"
    
    // public functions
    
    /// This method shows the given UIView to the user at the position which is set before calling this function. you must keep a strong refrence of QCIndicatorContainer instance otherwise the indicator will not be shown.
    /// - Parameters:
    ///   - vc: the ViewController on which the indicator is to be shown
    ///   - view: a UIView which will be shown as an indicator
    ///   - size: size of the indicator. very important for presenting indicator. without this the view will not be shown properly
    ///   - animate: a Bool value indicating whether or not you want to show animation. default is true
    ///   - timer: a Double value if given the indicator will be dismissed after given seconds. default is nil
    ///   - onTapAction: a type of closure, called when the user taps on given view. to use this you must set "isUserInteractionEnabled" to true
    ///   - completionHandler: a type of  closue, caled when the indicator is dismissed
    public func showIndicator(for vc:UIViewController,indicatorView view:UIView,indicatorSize size:CGSize,animate:Bool=true,timer:Double?=nil,onTapAction:QCVoidFunc?=nil,completionHandler:QCVoidFunc?=nil) {
        
        hideIndicator(animate: false)
        
        let indicatorWindow = UIWindow()
        indicatorWindow.backgroundColor = UIColor.clear
        
        view.accessibilityLabel = viewID
        givePosition(to: view, for: size, margins: margins(vc))
        if animate {
            animateVu(view: view, hide: false,margins: animation == .slide ? margins(vc) : nil)
        }
        
        indicatorWindow.windowLevel = UIWindow.Level.alert - 1
        
        
        let tempVC = UIViewController()
        indicatorWindow.rootViewController = tempVC
        
        indicatorWindow.addSubview(view)
        
        indicatorWindow.center = giveScreenCenter()
        indicatorWindow.isHidden = false
        indicatorWindow.isUserInteractionEnabled = isUserInteractionEnabled
        
        let id = UUID().uuidString
        indicatorWindow.accessibilityLabel = id

        vcRefrences.append(vc)
        accessNames.append(id)
        tempWindows.append(indicatorWindow)
        
        self.completionBlock = completionHandler
        self.animateView = animate
        self.onTapAction = onTapAction
        
        observeOrientationChange()
        if onTapAction != nil {
            //TODO: - only works when the property "isUserInteractionEnabled" is set "true"
            indicatorWindow.subviews.forEach{$0.isUserInteractionEnabled = false}
            view.isUserInteractionEnabled = true
            insertTapGesture(to: view)
        }
        
        delayDismiss(timer)
        
    }
    
    /// This method that hides the indicator  which was shown before.
    /// - Parameter animate: a Bool value indicating whether or not you want to perform dismiss animation. default vakue if the one for show animation
    public func hideIndicator(animate:Bool?=nil) {
        
        if let _ = timerSource {
            timerSource!.cancel()
            timerSource = nil
        }
                
        windowLoop:for window in tempWindows.enumerated() {
        
            if window.element.accessibilityLabel == accessNames[window.offset] {
                
                for view in window.element.subviews {
                    
                    if view.accessibilityLabel == viewID {
                        
                        if animate ?? animateView {
                            
                            animateVu(view: view, hide: true,margins: animation == .slide ? margins(vcRefrences[window.offset]) : nil) {
                                
                                self.removeIndicator(at: window.offset)
                                
                            }
                        } else {
                            self.removeIndicator(at: window.offset)
                        }
                        
                        break windowLoop
                    }
                }
            }
        }
        
        completionBlock?()
        
        if tempWindows.isEmpty {
            removeOrientationObserver()
        }
        
    }
    
    internal func delayDismiss(_ time: Double?) {
        guard let time = time else { return }
        guard time > 0 else { return }
        var timeout = time
        timerSource = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0),
                                               queue: DispatchQueue.main)// as! DispatchSource
        timerSource!.schedule(wallDeadline: .now(), repeating: .seconds(1))

        timerSource!.setEventHandler {
            if timeout <= 0 {
                DispatchQueue.main.async {
                    self.hideIndicator()
                }
            } else {
                timeout -= 1
            }
        }
        timerSource!.resume()
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
    @discardableResult
    public func setAnimation(_ type:Animation) -> QCIndicatorContainer {
        self.animation = type
        return self
    }
    @discardableResult
    public func setAnimationDuration(_ duration:CGFloat) -> QCIndicatorContainer {
        self.animationDuration = duration
        return self
    }
    @discardableResult
    public func setUserInteractionEnabled(_ bool:Bool) -> QCIndicatorContainer {
        self.isUserInteractionEnabled = bool
        return self
    }

    
}
