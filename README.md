# ExceptionLogger
A lightweight exception logger that automatically stores any crashlogs in user defaults and returns when asked for.

If you do not want to wait for a crashlog to be exported and then re-symbolicated before you could analyze that during testing, use ExceptionLogger that would automatically store any crash that occurs in your app and you can pull out the crash details in next relaunch. Display in the app or send that over email.

## Installation
* To install via cocoapods, add below to your Podfile
```ruby
target 'ProjectName' do
    pod 'ExceptionLogger'
end
```
* Or you can copy paste the files from ExceptionLogger to your project. There are only two classes:
  * ELExceptionLogger
  * GTMStackTrace


## Usage
* In swift
```swift
import ExceptionLogger

//To install the exception logger
ELExceptionLogger.installExceptionLogger()

//To fetch last stored exception logger
ELExceptionLogger.lastExceptionDetails()
```

* In Objective-C
```objective-c
#import <ExceptionLogger/ExceptionLogger.h>

//To install the exception logger
[ELExceptionLogger installExceptionLogger];

//To fetch last stored exception logger
[ELExceptionLogger lastExceptionDetails]
```

## Note
ExceptionLogger uses GTMStackTrace from [here](https://github.com/google/google-toolbox-for-mac).

## License
ExceptionLogger is released under MIT License.