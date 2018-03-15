//
//  CurrencyConverterViewController.swift
//  SodiumExamples
//
//  Created by Liang on 2018-02-11.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumCocoa
import SodiumSwift

class CurrencyConverterViewController: UIViewController {

    @IBOutlet weak var usdTextField: STextField!
    @IBOutlet weak var eurTextField: STextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup(self)
    }
}

func setup(_ vc: CurrencyConverterViewController) {
    let usd2eurExchangeRate = 0.82
    let eur2usdExchangeRate = 1.0 / usd2eurExchangeRate

    func exchange(_ x: String, _ exchangeRate: Double) -> String {
        let value = Double(x) ?? 0.0
        return String(value * exchangeRate)
    }

    func usd2eur(_ x: String) -> String {
        return exchange(x, usd2eurExchangeRate)
    }

    func eur2usd(_ x: String) -> String {
        return exchange(x, eur2usdExchangeRate)
    }

    func convert(_ textField: STextField, _ f: @escaping (String) -> String, _ initialValue: String) -> Cell<String> {
        return textField.csText.stream().map(f).hold(initialValue)
    }

    let usdAmount = "1.0"
    let eurAmount = usd2eur("1.0")
    vc.usdTextField.cText = convert(vc.eurTextField, eur2usd, usdAmount)
    vc.eurTextField.cText = convert(vc.usdTextField, usd2eur, eurAmount)
}
