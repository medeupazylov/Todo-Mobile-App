//
//  SceneDelegate.swift
//  TodoApp
//
//  Created by Medeu Pazylov on 17.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let fileName = "todoList.json"
    var window: UIWindow?
    var fileCache: FileCache!
    var detailsNavigationContoller: UINavigationController!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: winScene)
        setupFileCache()

        window?.rootViewController = setupMainScreen()
//                window?.rootViewController = setupScreen()
        window?.makeKeyAndVisible()
    }
    
    private func setupFileCache() {
        fileCache = FileCache()
        fileCache.loadTodoItemsFromFile(fileName: fileName)
//        print(self.fileCache.todoItems)
        guard let application = (UIApplication.shared.delegate as? AppDelegate) else {return}
        application.saveFilesClosure = {
            self.fileCache.saveTodoItemsToFile(fileName: self.fileName)
//            print(self.fileCache.todoItems)
        }
    }
    
    private func setupMainScreen() -> UINavigationController {
        let mainPresenter = MainPresenter(fileCache: fileCache)
        let mainView = MainView(newMainPresenter: mainPresenter)
        mainPresenter.mainView = mainView
        let mainNavigationController = UINavigationController(rootViewController: mainView)
        return mainNavigationController
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

