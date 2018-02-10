# sodium-swift
## Introduction
sodium-swift - Functional Reactive Programming (FRP) library.

This library is based on https://github.com/SodiumFRP/sodium-swift
The original sodium-swift only supports Swift 3, that's why I migrated sodium-swift to Swift 4 and created a new repo.

If you’re familiar with the idea of a domain-specific language (DSL), then you can understand FRP as a minimal complete DSL for stateful logic.

## Example
This is a math app. When you tap the next button, it will show a new math question and the previous question's answer.

<img src="https://user-images.githubusercontent.com/4646838/36061995-bd7bba2e-0e63-11e8-9bae-dcc525bfad99.png"  width="540"/>

Sodium-swift replaces listeners (also known as callbacks) in the widely used observer pattern, making your code cleaner, clearer, more robust, and more maintainable—in a word, simpler.

```import UIKit
import SodiumSwift
import SodiumCocoa

class QuestionViewController: UIViewController {
    @IBOutlet weak var questionLabel: NALabel!
    @IBOutlet weak var answerLabel: NALabel!
    @IBOutlet weak var nextButton: NAButton!

    var count: Int64 = loadCount()

    let sViewDidLoad = StreamSink<SUnit>()
    let sNextButton  = StreamSink<SUnit>()

    @IBAction func next(_ sender: AnyObject) {
        sNextButton.send(SUnit.value)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sViewDidLoad.send(SUnit.value)
        setupQuiz()
    }

    func setupQuiz() {
        let sArithmeticExpression = sViewDidLoad.orElse(sNextButton).map(createQuestion)
        questionLabel.txt         = createQuestionEndPoint(sArithmeticExpression)
        answerLabel.txt           = createAnswerEndPoint(sArithmeticExpression)
    }
}
```

## Prerequisites
- Xcode Command Line Tools
   
   ```$ xcode-select --install```
  
- universalbuild
  
  https://github.com/unchartedworks/universalbuild/releases

## Build
### Build universal sodium-swift frameworks for iOS
      $ ./buildIOSFrameworks.sh
        
**Add the frameworks to your iOS project**
SodiumSwift.framework
SwiftCommon.framework
SodiumCocoa.framework
SwiftCommonIOS.framework


### Build universal sodium-swift frameworks for macOS
    $ ./buildMacOSFramworks.sh

**Add the frameworks to your macOS project**
SodiumSwift.framework
SwiftCommon.framework

