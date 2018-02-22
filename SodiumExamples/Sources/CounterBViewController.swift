//
//  CounterViewController.swift
//
//  Created by Liang on 10/02/2018.

import UIKit
import SodiumCocoa
import SodiumSwift

class CounterBViewController: UIViewController {
    @IBOutlet weak var counterLabel: SLabel!
    @IBOutlet weak var upButton: SButton!
    @IBOutlet weak var downButton: SButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup(self)
    }
}

func setup(_ vc: CounterBViewController) {
    func count(_ upButton: SButton!, _ downButton: SButton!) -> Cell<String> {
        let sUp          = upButton.tap.mapTo(1)
        let sDown        = downButton.tap.mapTo(-1)
        return sUp.orElse(sDown).accum(0, f: +).map({String($0)})
    }

    func enabledButtonState(_ counterLabel: SLabel!, _ f: @escaping (String) -> Bool, _ initialValue: Bool) -> AnyCell<Bool> {
        return counterLabel.cText.stream().map(f).holdLazy({initialValue})
    }

    func upButtonEnabledState(_ counterLabel: SLabel!) -> AnyCell<Bool> {
        let f = { (x: String) in Int(x) == nil || Int(x)! < 5}
        return enabledButtonState(counterLabel, f, true)
    }

    func downButtonEnabledState(_ counterLabel: SLabel!) -> AnyCell<Bool> {
        let f = { (x: String) in Int(x) == nil || Int(x)! > 0}
        return enabledButtonState(counterLabel, f, false)
    }

    vc.counterLabel.cText       = count(vc.upButton, vc.downButton)
    vc.upButton.cEnabledState   = upButtonEnabledState(vc.counterLabel)
    vc.downButton.cEnabledState = downButtonEnabledState(vc.counterLabel)
}



