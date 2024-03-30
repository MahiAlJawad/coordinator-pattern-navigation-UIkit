# Coordinator pattern navigation in UIKit Application

Demonstrates a cleaner programmatic navigation approach with Coordinator pattern in UIKit application with MVVM pattern(MVVM with Coordinator known as MVVM-C)

Organized navigation makes the overall code cleaner, more readable, and more organized.  Talk is cheap, so let's get into the code. 

This project manages the following view with a single Coordinator (AppCoordinator). In large-scale applications, multi-level Coordinators can be maintained like we maintained in a single Coordinator application.

**Demo simulation**: 

https://github.com/MahiAlJawad/coordinator-pattern-navigation-UIkit/assets/30589979/a872f540-4c3f-411c-8f70-5a2efcc9ec21


**The Coordinator protocol**

Let's build a basic Coordinator blue-print which maintains all basic navigation actions.

```swift
protocol Coordinator {
    associatedtype Destination
    
    var navigationController: UINavigationController { get }
    
    func pushViewController(_ viewController: UIViewController)
    
    func presentViewController(_ viewController: UIViewController)
    
    func showAlert(title: String, message: String)
    
    func dismiss()
    
    func popViewController()
    
    func start(with destination: Destination)
}

extension Coordinator {
    func pushViewController(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentViewController(_ viewController: UIViewController) {
        let presentedNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(presentedNavigationController, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(.init(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}

```

**AppCoordinator conforming to Coordinator**

```swift
class AppCoordinator: Coordinator {
    let navigationController = UINavigationController()
    
    // AppCoordinator deals with only single Coordinator started from `SceneDelegate`.
    // In complex applications if there are multilevel hierarchy of views
    // then Destination will deal with multiple destination cases.
    // From different places different `destination` might be started
    enum Destination {
        case rootView
    }
    
    func start(with destination: Destination = .rootView) {
        switch destination {
        case .rootView:
            pushViewController(mainViewController)
        }
    }
}
```

From the `SceneDelegate` which is the entry point we start the `AppCoordinator`

```swift
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = appCoordinator.navigationController
        window?.makeKeyAndVisible()
        
        appCoordinator.start() // ---> Here it is
    }
```

**AppCoordinator handles MainView navigation events**

Main View handles 3 navigation events
1. Push Child View
2. Present Child View
3. Present Alert (Yes, it is also a kind of navigation, because navigationController presents it)

```swift
// MARK: Handle MainView events

extension AppCoordinator {
    private func handleEvent(_ event: MainViewModel.Event) {
        switch event {
        case .pushChildViewTapped:
            pushViewController(childViewController(presentationType: .pushed))
        case .presentChildViewTapped:
            presentViewController(childViewController(presentationType: .presented))
        case .showAlertTapped:
            showAlert(title: "Dummy Alert", message: "Dummy message for alert")
        }
    }

    // Creates and returns MainViewController
    var mainViewController: MainViewController {
        .makeViewController(
            with: .init(handleEvent: handleEvent)
        )
    }
}

```

**AppCoordinator handles ChildView navigation events**

Our ChildView could be shown either as Pushed view or as Presented view. Based on this `presentatioType` there could be 3 possible navigation events.
1. Done button pressed (in Presented view)
2. Cancel button pressed (in Presented view)
3. Back button pressed (in Pushed view)

```swift
// MARK: Handle ChildView events

extension AppCoordinator {
    private func handleEvent(_ event: ChildViewModel.Event) {
        switch event {
        case .doneButtonTapped, .cancelButtonTapped:
            dismiss()
        case .backButtonTapped:
            popViewController()
        }
    }

    // Creates ChildViewController given the presentationType
    private func childViewController(presentationType: ChildViewModel.PresentationType) -> ChildViewController {
        .makeViewController(with: .init(
            presentationType: presentationType,
            handleEvent: handleEvent
        ))
    }
}
```

**Views and ViewModels**

Now the Views (ViewControllers) and ViewModels are created to cope up with the Coordinator with these thumb rule.
1. User interacts with the ViewController
2. ViewController notifies about the interaction to the ViewModel
3. ViewModel notifies the associated Coordinator to handle user interaction in case of navigation event with the `handleEvent(ViewModel.Event)` closure

**MainViewController**

```swift
class MainViewController: UIViewController {
    var viewModel: MainViewModel!
    
    static func makeViewController(with viewModel: MainViewModel) -> MainViewController {
        let viewController = UIStoryboard(name: "MainStoryboard",bundle: nil)
            .instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.navigationTitle
    }
    
    @IBAction func pushChildViewTapped(_ sender: Any) {
        viewModel.pushChildViewTapped()
    }
    
    @IBAction func presentChildViewTapped(_ sender: Any) {
        viewModel.presentChildViewTapped()
    }
    
    @IBAction func showAlertTapped(_ sender: Any) {
        viewModel.showAlertTapped()
    }
}

```

**MainViewModel**

```swift
class MainViewModel {
    enum Event {
        case pushChildViewTapped
        case presentChildViewTapped
        case showAlertTapped
    }
    
    let navigationTitle = "Main View"
    
    let handleEvent: (Event) -> Void // --> This closure is sent from the associated Coordinator during initialization
    
    init(handleEvent: @escaping (Event) -> Void) {
        self.handleEvent = handleEvent
    }
    
    func pushChildViewTapped() {
        handleEvent(.pushChildViewTapped)
    }
    
    func presentChildViewTapped() {
        handleEvent(.presentChildViewTapped)
    }
    
    func showAlertTapped() {
        handleEvent(.showAlertTapped)
    }
}

```

**ChildViewController**

```swift
class ChildViewController: UIViewController {
    var viewModel : ChildViewModel!
    @IBOutlet weak var label: UILabel!
    
    static func makeViewController(with viewModel: ChildViewModel) -> ChildViewController {
        let viewController = UIStoryboard(name: "ChildViewStoryboard",bundle: nil)
            .instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = viewModel.viewTitle
        setupNavigationItems()
    }
    
    private func setupNavigationItems() {
        navigationItem.title = viewModel.viewTitle
        
        switch viewModel.presentationType {
        case .pushed:
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonAction))
            navigationItem.leftBarButtonItem = backButton
        case .presented:
            // Contains Done button and Cancel button in presented view
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonAction))
            navigationItem.rightBarButtonItem = doneButton
            navigationItem.leftBarButtonItem = cancelButton
        }
    }
    
    @objc private func doneButtonAction() {
        viewModel.doneButtonTapped()
    }
    
    @objc private func cancelButtonAction() {
        viewModel.cancelButtonTapped()
    }
    
    @objc private func backButtonAction() {
        viewModel.backButtonTapped()
    }
}

```

**MainViewModel**

```swift
class ChildViewModel {
    enum PresentationType {
        case pushed
        case presented
    }
    
    enum Event {
        case doneButtonTapped
        case cancelButtonTapped
        case backButtonTapped
    }
    
    let viewTitle = "Child View"
    
    let handleEvent: (Event) -> Void // --> This closure is sent from the associated Coordinator during initialization
    let presentationType: PresentationType
    
    init(presentationType: PresentationType, handleEvent: @escaping (Event) -> Void) {
        self.handleEvent = handleEvent
        self.presentationType = presentationType
    }
    
    func doneButtonTapped() {
        handleEvent(.doneButtonTapped)
    }
    
    func cancelButtonTapped() {
        handleEvent(.cancelButtonTapped)
    }
    
    func backButtonTapped() {
        handleEvent(.backButtonTapped)
    }
}

```


**Conclusion**
A clean navigation management is a must for readable and testable code. This is a basic blueprint of Coordinator based programatic navigation in UIKit based iOS Application with MVVM design pattern, often named as MVVM-C. For larger view hierarchy multiple and multilevel Coordinators also can be joined with this. 

