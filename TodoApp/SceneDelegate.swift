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
    var navigationContoller: UINavigationController!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: winScene)
        fileCache = FileCache()
        fileCache.loadTodoItemsFromFile(fileName: fileName)
        print(self.fileCache.todoItems)
        navigationContoller = setupScreen()
        window?.rootViewController = navigationContoller
        window?.makeKeyAndVisible()
        guard let application = (UIApplication.shared.delegate as? AppDelegate) else {return}
        application.saveFilesClosure = {
            self.fileCache.saveTodoItemsToFile(fileName: self.fileName)
            print(self.fileCache.todoItems)
        }
        
    }
    
    private func setupScreen() -> UINavigationController{
        let vc = DetailsViewController()
        vc.saveActionClosure = { [weak self] newTodoItem in
            guard let fileCache = self?.fileCache else {return}
            fileCache.addNewTodoItem(todoItem: newTodoItem)
            for item in fileCache.todoItems {
                print(item.deadline)
            }
        }
        
        vc.deleteActionClosure = { [weak self] id in
            guard let fileCache = self?.fileCache else {return}
            fileCache.removeTodoItem(id: id)
            print(fileCache.todoItems.count)
        }
        
        let navigationController = UINavigationController(rootViewController: vc)
        return navigationController
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let vc = navigationContoller.viewControllers[0] as? DetailsViewController else {return}
        let todoItem = !fileCache.todoItems.isEmpty ? fileCache.todoItems[0] : nil
        vc.todoItem = todoItem
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

