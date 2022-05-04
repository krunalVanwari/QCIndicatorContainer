
import UIKit

public typealias QCCompletedBlock = () -> Void

public final class QCIndicatorContainer:NSObject {
 
    // private variables
    internal var tempWindows = [UIWindow]()
    internal var accessNames = [String]()
    internal var vcRefrences = [UIViewController]()
    internal var timerSource: DispatchSourceTimer?
    internal var completionBlock:QCCompletedBlock?
    internal var animateView:Bool = true
    
    fileprivate(set) public var horizontalPosition:Horizontal = .center
    fileprivate(set) public var verticalPosition:Vertical = .center
    fileprivate(set) public var padding:UIEdgeInsets = .init(value: 0.0)
    fileprivate(set) public var shouldUseMargins:Bool = true
    fileprivate(set) public var animation:Animation = .slide
    fileprivate(set) public var animationDuration:CGFloat = 1.0
    
    let tempVC = UINavigationController(rootViewController: UIViewController())
    
    // initialisers
    public override init() {}
    
    // constants
    internal let viewID:String = "viewID"
    
    // public functions
    
    public func showIndicator(for vc:UIViewController,indicatorView view:UIView,indicatorSize size:CGSize,animate:Bool=true,timer:Double?=nil,completionHandler:QCCompletedBlock?=nil) {
        
        hideIndicator(animate: false)
        
        let indicatorWindow = UIWindow()
        indicatorWindow.backgroundColor = UIColor.clear
        
        
        observeOrientationChange()
        
        view.accessibilityLabel = viewID
        givePosition(to: view, for: size, margins: margins(vc))
        if animate {
            animateVu(view: view, hide: false,margins: animation == .slide ? margins(vc) : nil)
        }
        
        indicatorWindow.windowLevel = UIWindow.Level.alert - 1
        indicatorWindow.addSubview(view)
        indicatorWindow.rootViewController = tempVC
        indicatorWindow.center = giveScreenCenter()
        indicatorWindow.isHidden = false
        indicatorWindow.isUserInteractionEnabled = false
        
        let id = UUID().uuidString
        indicatorWindow.accessibilityLabel = id

        vcRefrences.append(vc)
        accessNames.append(id)
        tempWindows.append(indicatorWindow)
        
        completionBlock = completionHandler
        animateView = animate
        
        delayDismiss(timer)
        
        //MARK: - BUG: when delay method is not called the view is not showing
        
    }
    
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

    
}
