Pod::Spec.new do |s|

  s.name         = "ExceptionLogger"
  s.version      = "0.1.0"
  s.summary      = "A lightweight exception logger that automatically stores any crashlogs in user defaults and returns when asked for."
  s.description  = <<-DESC
  A lightweight exception logger that automatically stores any crashlogs in user defaults and returns when asked for.
                   DESC

  s.homepage     = "https://github.com/Ad1991/ExceptionLogger"
  s.license      = "Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)"
  s.authors            = { "Adarsh Rai" => "adrai75@gmail.com" }

  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  # s.osx.deployment_target = "10.7"

  s.source       = { :git => "https://github.com/Ad1991/ExceptionLogger.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "ExceptionLogger/**/*.{h,m}"
  s.public_header_files = "ExceptionLogger/ELExceptionLogger.h"

  s.requires_arc = true

end
