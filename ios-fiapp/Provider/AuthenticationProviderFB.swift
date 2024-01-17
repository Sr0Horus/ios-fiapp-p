import Foundation
import FirebaseAuth

protocol AuthenticationProvidable {
    func loginUser(withEmail email: String, andPassword password: String, completion: @escaping (Error?, User?) -> Void)
    func registerUser(withEmail email: String, andPassword password: String, completion: @escaping (Error?, User?) -> Void)
    func isUserLoggedIn() -> Bool
}

final class AuthenticationProviderFB: AuthenticationProvidable {
   
    func loginUser(withEmail email: String, andPassword password: String, completion: @escaping (Error?, User?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(error, nil)
                return
            }
                        
            let user = User(name: result.user.displayName ?? "", email: result.user.email ?? "", password: "*")
            completion(error, user)
        }
    }
    
    func registerUser(withEmail email: String, andPassword password: String, completion: @escaping (Error?, User?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(error, nil)
                return
            }
            
            let user = User(name: result.user.displayName ?? "", email: result.user.email ?? "", password: "*")
            completion(error, user)
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
}
