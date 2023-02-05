import SwiftUI

public class HostingViewController<Content: View>: UIViewController {
    
    let hostingVC: UIHostingController<Content>
    
    var isNavigationBarHidden: Bool = false
    var isNavigationBarHiddenToRestore: Bool = false
    
    private var lifecycleObservers = NSHashTable<AnyObject>.weakObjects()

    public init(rootView: Content) {
        self.hostingVC = UIHostingController(rootView: rootView)
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        self.addChild(self.hostingVC)
        self.view.addSubview(self.hostingVC.view)
        self.hostingVC.didMove(toParent: self)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.hostingVC.view.frame = self.view.bounds
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        isNavigationBarHiddenToRestore = navigationController?.isNavigationBarHidden ?? isNavigationBarHiddenToRestore
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: true)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(isNavigationBarHiddenToRestore, animated: true)
    }
}
