//
//  ViewController.swift
//  TestWebSocket


import UIKit


class ViewController: UIViewController {
    
    var webSocketTask: URLSessionWebSocketTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebSocket()
    }

    func setWebSocket() {
        guard let url = URL(string: "ws://...") else {
            print("Error: can not create URL")
            return
        }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let request = URLRequest(url: url)
        webSocketTask = urlSession.webSocketTask(with: request)
        webSocketTask?.resume()
    }
    
    private func receive() {
        webSocketTask?.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received string: \(text)")
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }
            case .failure(let error):
                print(error)
            }
            self.receive()
        }
    }
    
    func sendMessage(message: String) {
        //也可以傳送data的資料
//        let data = URLSessionWebSocketTask.Message.data()
        
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
            print(error)
            }
        }
    }

    @IBAction func receiveAction(_ sender: UIButton) {
        receive()
    }
    
    
    

}

//MARK: - 相關URLSessionWebSocketDelegate代理方法
extension ViewController: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("URLSessionWebSocketTask is connected")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        if let reason = reason, let string = String(data: reason, encoding: .utf8) {
            print(string)
        } else {
            print("error")
        }
    }
}
