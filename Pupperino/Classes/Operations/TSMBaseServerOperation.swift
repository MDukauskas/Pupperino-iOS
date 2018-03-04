//
//  TSMBaseServerOperation.swift
//
//  Is dependent on: `TSMBaseOperationOutput`, `TSMBaseOperation`
//
//  NOTES:
//  * operation has caching turned off
//

import UIKit

class TSMBaseServerOperation: TSMBaseOperation, URLSessionDelegate {
    
    // MARK: - Declarations
    private var urlSession: URLSession?
    private var sessionDataTask: URLSessionDataTask?
    
    // MARK: - Methods
    // MARK: - Overriding TSMBaseOperation
    
    override func cancel() {
        
        guard isCancelled == false else {
            return
        }
        
        sessionDataTask?.cancel()
        super.cancel()
    }
    
    override func startOperation() {
        
        // Generate request
        guard let url: URL = operationUrl() else {
            print("\(NSStringFromClass(type(of: self))) ERROR! Could not generate URL")
            finishOperation()
            return
        }
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url,
                                                               cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                                               timeoutInterval: Constants.Server.serverOperationTimeoutInterval)
        request.setValue(Constants.Server.headerContentType, forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = self.httpMethod()
        request.httpBody = self.httpBodyData()
        
        if let httpBody = request.httpBody {
            request.setValue(String(httpBody.count), forHTTPHeaderField: "Content-Length")
        }
        
        // Create session data task
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        sessionDataTask = urlSession?.dataTask(with: request as URLRequest,
                                               completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
                                                // NOTE: parsing must also properly update `output.isSuccessful`
                                                self?.parseRetrievedData(data, withResponse: response, withError: error)
                                                self?.finishOperation()
        })
        
        if let sessionDataTask = sessionDataTask {
            sessionDataTask.resume()
        } else {
            print("WARING! Could not create sessionDataTask")
            finishOperation()
        }
    }
    
    // MARK: - Methods for overriding
    
    func urlMethodName() -> String {
        // Overriding method should provide "method name" which will be added at the end of serverUrl
        
        print("\(NSStringFromClass(type(of: self))) WARNING! not overriden method - \(#function)")
        return ""
    }
    
    func httpMethod() -> String {
        // Overriding class should provide httpMethod (GET, POST, etc.)
        
        print("\(NSStringFromClass(type(of: self))) WARNING! not overriden method - \(#function)")
        return ""
    }
    
    func additionalUrlParametersDictionary() -> [String: String]? {
        // will be used in url, as "key=value&key2=value2"
        return nil
    }
    
    func additionalBodyDictionary() -> [NSString: Any]? {
        // Overriding class should provide additional values passed with request
        return nil
    }
    
    func isSuccessfulOnEmptyResponse() -> Bool {
        //
        // Override to return `true`, if operation may be considered successful, when http is [200-299]
        // and response data is nil (0 bytes).
        //
        // This is used to identify cases, when operation is considered successful only if there is data to parse.
        //
        return false
    }
    
    func parseResponseDictionary(_ responseDictionary: [String: Any]) {
        // Overriding class is responsible to:
        // * implement any kind of parsing
        // * UPDATING `output.isSuccessful` to proper state
        
        output.isSuccessful = true
    }
    
    func parseErrorData(_ data: Data?, withFailedResponse response: HTTPURLResponse) {
        //
        // Is called when http status code does not belong to 200-299 range.
        //
        // Overriding class, may implement any specific/error `data` parsing in case
        // server provides data with error codes.
        //
        // NOTE: usually it is error JSON parsing (when status code is: 400-499) which is identical in whole app.
        //       So implementation could be provided here, as long as this class is not intended to be reused
        //       in other projects.
        //
        // By default: does nothing
        //
    }
    
    // MARK: - URLSessionDelegate
    
    public func urlSession(_ session: URLSession,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        completionHandler(.performDefaultHandling, nil)
    }
    
    // MARK: - Helpers
    
    private func operationUrl() -> URL? {
        //
        // Combines:
        // * server url
        // * method name
        // * additional GET parameters (version, language, etc.)
        //
        
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Server.serverScheme
        urlComponents.host = Constants.Server.serverHost
        urlComponents.path = Constants.Server.serverCommonPathStart + urlMethodName()
        urlComponents.queryItems = urlParametersQueryItemsList()
        
        // url parameters
        return urlComponents.url
    }
    
    private func urlParametersQueryItemsList() -> [URLQueryItem] {
        //
        // Returns full list of parameters to be used in URL query
        // Is made out of 2 parts:
        // 1. common
        // 2. custom - provided by overriding operation
        //
        
        var parametersDictionary: [String: String] = [:]
        
        // 1. Common values
        let commonDictionary = commonUrlParametersDictionary()
        
        if let commonDictionary = commonDictionary {
            for (key, value) in commonDictionary {
                parametersDictionary.updateValue(value, forKey: key as String)
            }
        }
        
        // 2. Additional values
        let additionalDictionary = additionalUrlParametersDictionary()
        
        if let additionalDictionary = additionalDictionary {
            // add or replace values (in case keys are duplicate)
            for (key, value) in additionalDictionary {
                parametersDictionary.updateValue(value, forKey: key as String)
            }
        }
        
        // 3. Generate list of URLQueryItems
        if parametersDictionary.isEmpty {
            return []
        }
        
        var queryItemsList: [URLQueryItem] = []
        for (key, value) in parametersDictionary {
            queryItemsList.append(URLQueryItem(name: key, value: value))
        }
        
        return queryItemsList
    }
    
    private func commonUrlParametersDictionary() -> [String: String]? {
        //  SAMPLE:
        //
        //  var commonDictionary: [String: String] = [:]
        //
        //  commonDictionary["v"] = String(kServerAPIVersion)
        //  commonDictionary["lang"] = GenericTools.usedLanguageCode()
        //
        //  return commonDictionary

        return nil
    }
    
    private func httpBodyData() -> Data? {
        //
        // Body data is generated form 2 parts:
        // 1. Common values - provided by BaseOperation
        // 2. Values provided by overriding class
        //
        
        var bodyDictionary: [String: Any] = [:]
        
        // 1. Common values
        let commonDictionary = commonBodyDictionary()
        
        if let commonDictionary = commonDictionary {
            for (key, value) in commonDictionary {
                bodyDictionary.updateValue(value, forKey: key as String)
            }
        }
        
        // 2. Additional values
        let additionalDictionary = additionalBodyDictionary()
        
        if let additionalDictionary = additionalDictionary {
            // add or replace values
            for (key, value) in additionalDictionary {
                bodyDictionary.updateValue(value, forKey: key as String)
            }
        }
        
        guard bodyDictionary.isEmpty == false else {
            return nil
        }
        
        // 3. Generate NSData
        let jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: bodyDictionary, options: [])
        } catch {
            print("\(NSStringFromClass(type(of: self))) WARNING! could not generate jsonData \(error.localizedDescription) from dictionary: \(bodyDictionary)")
            return nil
        }
        
        return jsonData
    }
    
    private func commonBodyDictionary() -> [String: String]? {
        //
        // Returns values, which are expected to be common for all requests.
        //
        return nil
    }
    
    private func parseRetrievedData(_ data: Data?, withResponse response: URLResponse?, withError error: Error?) {
        //
        // Do:
        // * check error
        // * check http status code
        // * convert into Dictionary (JSDON data)
        // * check JSON for error
        // * provide JSON for parsing
        //
        
        if let error = error {
            print("\(NSStringFromClass(type(of: self))) ERROR! operation failed with error: \(error)")
            output.isSuccessful = false
            return
        }
        
        guard let response = response else {
            print("\(NSStringFromClass(type(of: self))) ERROR! response is nil")
            output.isSuccessful = false
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("\(NSStringFromClass(type(of: self))) ERROR! unexpected response \(response)")
            output.isSuccessful = false
            return
        }
        
        guard (httpResponse.statusCode >= 200) && (httpResponse.statusCode < 300) else {
            print("\(NSStringFromClass(type(of: self))) ERROR! unexpected status code \(httpResponse.statusCode)")
            parseErrorData(data, withFailedResponse: httpResponse)
            output?.isSuccessful = false
            return
        }
        
        //
        // If reached this line - http status code is ok (in 2xx range)
        // Check data for parsing.
        //
        guard let data = data, data.isEmpty == false else {
            if isSuccessfulOnEmptyResponse() {
                output.isSuccessful = true
            } else {
                output.isSuccessful = false
            }
            return
        }
        
        var dictionaryToParse: [String: Any]!
        do {
            guard let responseDictionary: [String: Any] = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]  else {
                print("\(NSStringFromClass(type(of: self))) ERROR! retrieved unexpected jsonDictionary structure: \(String(describing: String(data: data, encoding: .utf8)))")
                output.isSuccessful = false
                return
            }
            
            dictionaryToParse = responseDictionary
        } catch {
            print("\(NSStringFromClass(type(of: self))) ERROR! \(error) - could not make jsonObject from data \(String(describing: String(data: data, encoding: .utf8)))")
            output.isSuccessful = false
            return
        }
        
        //
        // If reached this line, we have proper `dictionaryToParse` ([String: Any])
        // Might implement any additional steps, e.g. to check for generic error cases,
        // before stepping into successful response data parsing
        //
        
        // Trigger actual parsing (overriding class is responsible to implement it)
        parseResponseDictionary(dictionaryToParse)
    }
}
