//
//  HostingViewController.swift
//  TonTransactions
//
//  Created by Dmitrii Chikovinskii on 10.08.2022.
//  Copyright © 2022 dmitri.space. All rights reserved.
//

import SwiftUI

class HostingViewController<Content: View>: UIViewController {
    
    let hostingVC: UIHostingController<Content>
    
    var isNavigationBarHidden: Bool = false
    var isNavigationBarHiddenToRestore: Bool = false
    
    private var lifecycleObservers = NSHashTable<AnyObject>.weakObjects()

    init(rootView: Content) {
        self.hostingVC = UIHostingController(rootView: rootView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        self.addChild(self.hostingVC)
        self.view.addSubview(self.hostingVC.view)
        self.hostingVC.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.hostingVC.view.frame = self.view.bounds
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        isNavigationBarHiddenToRestore = navigationController?.isNavigationBarHidden ?? isNavigationBarHiddenToRestore
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(isNavigationBarHiddenToRestore, animated: true)
    }
}

protocol ViewLifecycleObserver: AnyObject {
    func viewDidLoad()
}

//final class SetupViewController: ViewLifecycleObserver {
//    weak var viewController: UIViewController?
//    
//    func viewDidLoad() {
//        viewController?.title = "xx"
//    }
//}
