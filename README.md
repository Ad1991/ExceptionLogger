# ExceptionLogger
A lightweight exception logger that automatically stores any crashlogs in user defaults and returns when asked for

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

## License
ExceptionLogger is released under MIT License.