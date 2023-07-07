import Foundation

protocol NetworkingService {
    
}

class DefaultNetworkingService: NetworkingService {
    
    private let session = URLSession(configuration: .default)

    private let baseURL = "https://beta.mrdekk.ru/todobackend"
    private let token = "azotobacterieae"
    private var requestTimeout = 3.0

    
    func getTodoListFromNetwork(completion: @escaping ([NetworkTodoItem]?, Error?) -> Void) {
        Task {
            do {
                guard let request = networkRequest(pathURL: "list") else {return}
                async let response =  try await session.dataTask(for: request)
                let data = try await response.0
                
                let decoder = JSONDecoder()
                let todoItemListResponce = try decoder.decode(TodoItemListResponce.self, from: data)
                completion(todoItemListResponce.list, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func updateTodoListNetwork(todoItemList: TodoItemListResponce ,completion: @escaping ([NetworkTodoItem]?, Error?) -> Void) {
        Task {
            do {
                guard var data = try? JSONEncoder().encode(todoItemList) else {
                    completion(nil, nil)
                    return
                }
                guard let request = self.networkRequest(pathURL: "list", httpMethod: "PATCH", revision: 0, httpBody: data) else {
                    completion(nil, nil)
                    return
                }
                
                async let response =  try await session.dataTask(for: request)
                data = try await response.0
                
                let decoder = JSONDecoder()
                let todoItemListResponce = try decoder.decode(TodoItemListResponce.self, from: data)
                completion(todoItemListResponce.list, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func getTodoItemFromNetwork(id: String ,completion: @escaping (NetworkTodoItem?, Error?) -> Void) {
        Task {
            do {
                guard let request = self.networkRequest(pathURL: "list/\(id)") else { return }
                async let response =  try await session.dataTask(for: request)
                let data = try await response.0
                
                let decoder = JSONDecoder()
                let singleTodoItemResponce = try decoder.decode(SingleTodoItemResponce.self, from: data)
                completion(singleTodoItemResponce.element, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func addTodoItemToNetwork(singleTodoItem: SingleTodoItemResponce ,completion: @escaping ([NetworkTodoItem]?, Error?) -> Void) {
        Task {
            do {
                guard var data = try? JSONEncoder().encode(singleTodoItem) else {return}
                guard let request = self.networkRequest(pathURL: "list", httpMethod: "POST", revision: 0, httpBody: data) else {return}
                async let response =  try await session.dataTask(for: request)
                data = try await response.0
                
                let decoder = JSONDecoder()
                let todoItemListResponce = try decoder.decode(TodoItemListResponce.self, from: data)
                completion(todoItemListResponce.list, nil)

            } catch {
                completion(nil, error)
            }
        }
    }
    
    func changeTodoItemNetwork(todoItem: SingleTodoItemResponce, completion: @escaping ([NetworkTodoItem]?, Error?) -> Void) {
        Task {
            do {
                let id = todoItem.element.id
                guard var data = try? JSONEncoder().encode(todoItem) else {return}
                guard let request = self.networkRequest(pathURL: "list/\(id)",
                                                        httpMethod: "PUT",
                                                        revision: 0,
                                                        httpBody: data) else {return}
                async let response =  try await session.dataTask(for: request)
                data = try await response.0
                
                let decoder = JSONDecoder()
                let todoItemListResponce = try decoder.decode(TodoItemListResponce.self, from: data)
                completion(todoItemListResponce.list, nil)

            } catch {
                completion(nil, error)
            }
        }
    }
    
    func deleteTodoItemFromNetwork(id: String ,completion: @escaping ([NetworkTodoItem]?, Error?) -> Void) {
        Task {
            do {
                guard let request = self.networkRequest(pathURL: "list/\(id)",
                                                        httpMethod: "DELETE",
                                                        revision: 0) else { return }
                async let response =  try await session.dataTask(for: request)
                let data = try await response.0
                
                let decoder = JSONDecoder()
                let todoItemListResponce = try decoder.decode(TodoItemListResponce.self, from: data)
                completion(todoItemListResponce.list, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    
    func networkRequest(pathURL: String, httpMethod: String = "GET", revision: Int? = nil, httpBody: Data? = nil) -> URLRequest? {
    
        guard let url = URL(string: baseURL + "/\(pathURL)") else {return nil}
        
        var request = URLRequest(url: url)
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        request.timeoutInterval = requestTimeout
        if let revision = revision {
            request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        }
        return request
    }
    

}
