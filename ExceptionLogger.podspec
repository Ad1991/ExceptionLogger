Pod::Spec.new do |s|

  s.name         = "ExceptionLogger"
  s.version      = "0.1.1"
  s.summary      = "A lightweight exception logger for iOS applications"
  s.description  = <<-DESC
  A lightweight exception logger that automatically stores any crashlogs in user defaults and returns when asked for.
                   DESC

  s.homepage     = "https://github.com/Ad1991/ExceptionLogger"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Adarsh Rai" => "adrai75@gmail.com" }

  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  # s.osx.deployment_target = "10.7"

  s.source       = { :git => "https://github.com/Ad1991/ExceptionLogger.git", :tag => "#{s.version}" }
  s.source_files = "Classes", "ExceptionLogger/**/*.{h,m}"
  s.public_header_files = [
  'ExceptionLogger/ExceptionLogger/ELExceptionLogger.h',
  'ExceptionLogger/ExceptionLogger/ExceptionLogger.h'
  ]

  s.requires_arc = true

end
