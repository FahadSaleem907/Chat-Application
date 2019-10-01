import UIKit

class RouteManager: NSObject {
    
    static var shared = RouteManager()
    
    private override init() {}
    
    var delegate:AppDelegate?{
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    var window:UIWindow?? {
        return UIApplication.shared.delegate?.window
    }
   
    func showHome(){
        let tabBar:UITabBarController = UIStoryboard(name: "ChatBody", bundle: nil).instantiateViewController(withIdentifier: "chatBodyTBC") as! UITabBarController
        window??.rootViewController = tabBar
    }
    
    func showLogin(){
        clear(window: window)
        let authNC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "")
        window??.rootViewController = authNC
        
    }
    
    func clear(window: UIWindow??) {
        window??.subviews.forEach { $0.removeFromSuperview() }
    }
    
}
