# sodium-swift
## Introduction
sodium-swift - Functional Reactive Programming (FRP) library.

This library is based on https://github.com/SodiumFRP/sodium-swift
The original sodium-swift only supports Swift 3, that's why I migrated sodium-swift to Swift 4 and created a new repo.

If you’re familiar with the idea of a domain-specific language (DSL), then you can understand FRP as a minimal complete DSL for stateful logic.

## Examples
### Counter
This is a counter app. To increase the value, tap plus button; to decrease the value, tap minus button. The magic is that you don't have to use a mutable variable to store the value.

<img width="540" alt="counter" src="https://user-images.githubusercontent.com/4646838/36064751-d8a00752-0e8f-11e8-81e9-13320a3b7234.png">

```swift
import UIKit
import SodiumCocoa
import SodiumSwift

class CounterViewController: UIViewController {
    @IBOutlet weak var counterLabel: NALabel!
    @IBOutlet weak var upButton: NAButton!
    @IBOutlet weak var downButton: NAButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.txt = count(upButton, downButton)
    }
}

func count(_ upButton: NAButton!, _ downButton: NAButton!) -> Cell<String> {
    let sUp          = upButton.clicked.mapTo(1)
    let sDown        = downButton.clicked.mapTo(-1)
    return sUp.orElse(sDown).accum(0, f: +).map({String($0)})
}
```

### Math Quiz
This is a math app. When you tap the next button, it will show a new math question and the previous question's answer.

<img src="https://user-images.githubusercontent.com/4646838/36061995-bd7bba2e-0e63-11e8-9bae-dcc525bfad99.png"  width="540">

Sodium-swift replaces listeners (also known as callbacks) in the widely used observer pattern, making your code cleaner, clearer, more robust, and more maintainable—in a word, simpler.

```swift
import UIKit
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

- SodiumSwift.framework
- SwiftCommon.framework
- SodiumCocoa.framework
- SwiftCommonIOS.framework


### Build universal sodium-swift frameworks for macOS
    $ ./buildMacOSFramworks.sh

**Add the frameworks to your macOS project**

- SodiumSwift.framework
- SwiftCommon.framework


