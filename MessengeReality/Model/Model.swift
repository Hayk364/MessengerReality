import Foundation
import UIKit
import CryptoKit

public final class Model{
    private init() {}
    private let baseURL = "http://localhost:3000/api/users"
    static let shared = Model()

    
    final func getDataBase(){
        guard let url = URL(string:baseURL) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { return }
            guard let users = data else { return }
            do {
                let users = try JSONDecoder().decode([User].self, from: users)
                for user in users {
                    print(user.name)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    final func testForMe(){
        guard let url = URL(string:"http://localhost:3000/api/users/send-message") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { return }
            guard let data = data else { return }
            do {
                print("Data Is Printed")
            } catch {
                print(error)
            }
        }
    }
    final func createUser(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        self.findUser(newUser: user) { result, isFind in
            if isFind {
                let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Username has been used"])
                completion(.failure(error))
            } else {
                guard let url = URL(string: self.baseURL) else { return }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                do {
                    let jsonData = try JSONEncoder().encode(user)
                    request.httpBody = jsonData
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        print("Network request completed")
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                            completion(.failure(error))
                            return
                        }
                        
                        guard let data = data else {
                            print("No data received")
                            return
                        }
                        
                        do {
                            let newUser = try JSONDecoder().decode(User.self, from: data)
                            completion(.success(newUser))
                        } catch {
                            print("Decoding error: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                    task.resume()
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }

    final func findUser(newUser: User, completion: @escaping (Result<User, Error>, Bool) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error), false)
                return
            }
            
            guard let data = data else { return }
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                for user in users {
                    if user.name == newUser.name {
                        if user.password == newUser.password{
                            completion(.success(user), true)
                            return
                        } else {
                            let passwordNotFoundError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Password is not correct"])
                            completion(.failure(passwordNotFoundError), false)
                            return
                        }
                    }
                }
                let userNotFoundError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
                completion(.failure(userNotFoundError), false)
            } catch {
                completion(.failure(error), false)
            }
        }
        task.resume()
    }
}

