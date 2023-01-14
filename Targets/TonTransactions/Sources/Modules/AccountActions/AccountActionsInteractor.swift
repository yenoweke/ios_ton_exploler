import Foundation

final class AccountActionsInteractor: AccountActionsInteractorInput {
    private weak var output: AccountActionsInteractorOutput?
    private let router: AccountActionsRouterInput
    private let watchlistStorage: WatchlistStorage
    private let accountSubsriptonManager: AccountSubsriptonManager
    private let pushManager: PushManager?
    private let address: String
    private var itemAlreadyInStorage: Bool?
    private var accountSubsriptonToggleInProcess = false
    private var isSubsribed = false

    init(
        output: AccountActionsInteractorOutput,
        router: AccountActionsRouterInput,
        watchlistStorage: WatchlistStorage,
        accountSubsriptonManager: AccountSubsriptonManager,
        pushManager: PushManager?,
        address: String
    ) {
        self.output = output
        self.router = router
        self.watchlistStorage = watchlistStorage
        self.pushManager = pushManager
        self.accountSubsriptonManager = accountSubsriptonManager
        self.address = address
    }

    func updateIfNeeded() {
        let inStorage = watchlistStorage.isAdded(self.address)
        
        if inStorage {
            self.output?.itemAdded()
        }
        else {
            self.output?.itemRemoved()
        }

        Task {
            await updateSubsribtionState()

            await MainActor.run {
                self.output?.didLoadInitial()
            }
        }
    }

    func toggleWatchlistForAddress() {
        if watchlistStorage.isAdded(self.address) {
            self.watchlistStorage.remove(self.address)
        }
        else {
            self.watchlistStorage.add(self.address)
        }
        self.updateIfNeeded()
    }
    
    func toggleAccountSubscription() {
        if self.isSubsribed == false {
            if let pushManager = self.pushManager, pushManager.status != .allowed  {
                self.requestPermission(onGranted: { [weak self] in self?.toggleAccountSubscription() })
                return
            }
        }

        if self.accountSubsriptonToggleInProcess { return }

        self.accountSubsriptonToggleInProcess = true
        Task {
            await self.updateSubsribtionState()
          
            do {
                if self.isSubsribed {
                    try await self.accountSubsriptonManager.unsubsribe(account: self.address)
                }
                else {
                    try await self.accountSubsriptonManager.subsribe(account: self.address)
                }
            } catch {
                // TODO: handle error
            }

            await self.updateSubsribtionState()
            
            self.accountSubsriptonToggleInProcess = false
        }
    }

    func needToEnablePushPermissions() {
        self.router.showSystemSettings()
    }
}

private extension AccountActionsInteractor {
    @MainActor
    func updateSubsribtionState() async {
        self.isSubsribed = (try? await self.accountSubsriptonManager.isSubsribed(account: self.address)) ?? false
        if self.isSubsribed {
            self.output?.subsribed()
        }
        else {
            self.output?.unsubsribed()
        }
    }
    
    func requestPermission(onGranted: @escaping () -> Void) {
        if self.pushManager?.status == .denied {
            self.output?.pushPermissionDinied()
        }
        else {
            self.pushManager?.requestPermissions { [weak self] in
                guard self?.pushManager?.status == .allowed else { return }
                onGranted()
            }
        }
    }
}
