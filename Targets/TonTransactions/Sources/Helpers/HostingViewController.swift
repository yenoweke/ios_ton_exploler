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

//        self.hostingVC.view.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.hostingVC.view.frame = self.view.bounds
    }
}


