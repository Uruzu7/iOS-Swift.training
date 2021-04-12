import UIKit
import CloudKit

/*:
 ### Table of Contents

 */

//                                      URL SESSION
// URLSession is responsible for sending and receiving requests created via URLSessionConfiguration which can be done in 3 ways:

//                                  URLSessionConfiguration
//default: Creates a default configuration object that uses the disk-persisted global cache, credential and cookie storage objects.

//ephemeral: Similar to the default configuration, except that you store all of the session-related data in memory. Think of this as a “private” session.

//background: Lets the session perform upload or download tasks in the background. Transfers continue even when the app itself is suspended or terminated by the system.

//                                  URLSessionTask
//URLSessionTask is an abstract class that denotes a task object. A session creates one or more tasks to do the actual work of fetching data and downloading or uploading files.


//                                    URLSessionTask Types
//URLSessionDataTask: Use this task for GET requests to retrieve data from servers to memory.

//URLSessionUploadTask: Use this task to upload a file from disk to a web service via a POST or PUT method.

//URLSessionDownloadTask: Use this task to download a file from a remote service to a temporary file location. You can also suspend, resume and cancel tasks. URLSessionDownloadTask has the extra ability to pause for future resumption.

// How to create a URL Session
class networkHandler {
// 1. Create the URLSession refference and instantiate it
let defaultSession = URLSession(configuration: .default)
// 2. Create the URLSessionDataTask.
var dataTask: URLSessionDataTask?

    func request(searchTerm: String, completion: @escaping NetworkingResult) {
        // 3. Cancel any dataTasks that already exist when creting another task
        dataTask?.cancel()
        // 4. Add the components
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            //5. Optionally add a query string to ensure that the search string uses escaped characters.
            urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
            //6. Unwrapping the url components.
            guard let url = urlComponents.url else {
                return
            }

            //7. We initialize the data task with the url we just created
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                //8. Catch possible errors
                if let error = error {
                    errorMessage = error.localizedDescription
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    //9. We know now that we have the data, we could call the completion
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
            }
            //9. Resume the data task in order for it to start working.
            dataTask?.resume()
        }
    }

}
// What we've done so far: Created a URLSession and initialized it with a default session configuration.
//Declared URLSessionDataTask, which you’ll use to make a GET request to the iTunes Search web service when the user performs a search. The data task will be re-initialized each time the user enters a new search string.

/*:
### Overview

 This is an playground for quick refference into URL Session.
 */

//: [Next Topic](@next)
