# ForeFlightWeather
An iOS app that fetches and displays the weather report for a given airport from ForeFlight's QA server, this time with up to date SDKs!

TODO: insert photo/video

## How long was spent on the project
- Started around 9am on April 25th 2024.
- Took at break at 2pm on April 25th 2024 to run errands.
- Resumed work at 5pm on April 25th 2024.
- Stopped working for the day at 7pm on April 25th 2024.
- Worked breifly at midnight on April 26th 2024.
- Resumed work around 8:30am on April 26th 2024.

## Any notable design decisions you wish to highlight
- The JSON returned from https://qa.foreflight.com/weather/report never contained values for `weather` in my testing. Therefore, I focused the "Details View" on displaying the `text`, `dateIssued`, `lat`, `lon`, and `elevationFt` which was consistently provided.

## Any references consulted and/or third party libraries used
- TextField: https://developer.apple.com/documentation/swiftui/textfield
- List: https://developer.apple.com/documentation/swiftui/list
- Create dropdown editable TextField: https://stackoverflow.com/questions/73709938/how-to-create-dropdown-with-editable-textfield-in-swiftui
- Simple parsing JSON: https://gist.github.com/kobeumut/b06015646aa0d5f072bfe14e499690ef
- JSON Viewer: https://jsonviewer.stack.hu
- JSON Quicktype: https://app.quicktype.io
- Compiler Warning with ForEach: https://www.hackingwithswift.com/forums/swiftui/compiler-warning-non-constant-range-argument-must-be-an-integer-literal/14878
- Conditional compilation: https://www.swiftbysundell.com/articles/conditional-compilation-within-swift-expressions/
- Preserving your app’s model data across launches: https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches
- SwiftData Fatal error: failed to find a currently active container: https://forums.developer.apple.com/forums/thread/734212
- Reset iOS Simulator application data to run app for first time: https://stackoverflow.com/questions/16195859/reset-ios-simulator-application-data-to-run-app-for-first-time
- ModelContext: https://developer.apple.com/documentation/swiftdata/modelcontext
- Hashable: https://developer.apple.com/documentation/swift/hashable

## Known issues
- "weather" array from JSON response of https://qa.foreflight.com/weather/report/ is always empty.

## Any other notes that will help us understand your project
- This project is my second attempt using a 2024 Macbook Pro with iOS 17.4, Xcode 15.3, macOS 14.4, and Swift 5.10.

