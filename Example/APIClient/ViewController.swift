//
//  ViewController.swift
//  APIClient
//
//  Created by John on 12/14/2017.
//  Copyright (c) 2017 John. All rights reserved.
//

import UIKit
import APIClientKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let requestArray: [(String, String, (ViewController)->Void)] = [
        ("GitHub", "Get Events", {vc in GitHubManager.shared.getEvents{vc.completion($0)}}),
        ("GitHub", "Search user", {vc in GitHubManager.shared.searchUser(searchField: vc.textField.text ?? ""){vc.completion($0)}}),
        ("httpbin", "Get IP", {vc in HttpbinManager.shared.getIPAddress{vc.completion($0)}}),
        ("httpbin", "Post Request", {vc in HttpbinManager.shared.post(something: vc.textField.text ?? ""){vc.completion($0)}})
    ]
    
    lazy var hostArray: [String] = {
        return self.requestArray.reduce([]) {$0.contains($1.0) ? $0 : $0 + [$1.0]}
    }()
    
    lazy var hostAction: [String: [(String, (ViewController)->Void)]] = {
        var hostAction: [String: [(String, (ViewController)->Void)]] = [:]
        for host in self.hostArray {
            hostAction[host] = self.requestArray.filter{$0.0==host}.map{($1,$2)}
        }
        return hostAction
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnDidPress(_ sender: UIButton) {
        self.label.text = ""
        let host = self.hostArray[self.pickerView.selectedRow(inComponent: 0)]
        self.hostAction[host]?[self.pickerView.selectedRow(inComponent: 1)].1(self)
    }
    
    func completion<T>(_ result: APIResult<T>) {
        var text = ""
        switch result {
        case let .success(model, _):
            text = """
            Success
            \(String(describing: model))
            """
        case let .error(error, _):
            text = """
            Error
            \(error)
            """
        }
        self.label.text = text
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return self.hostArray[row]
        case 1:
            let host = self.hostArray[self.pickerView.selectedRow(inComponent: 0)]
            return self.hostAction[host]?[row].0 ?? nil
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.label.text = ""
        pickerView.reloadComponent(1)
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return self.hostArray.count
        case 1:
            let host = self.hostArray[self.pickerView.selectedRow(inComponent: 0)]
            return self.hostAction[host]?.count ?? 0
        default: return 0
        }
    }
}
