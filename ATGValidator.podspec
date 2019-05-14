Pod::Spec.new do |s|

  s.name          = "ATGValidator"
  s.version       = "1.1.1"
  s.summary       = "iOS validation framework with form validation support"
  s.description   = <<-DESC
		iOS validation framework with form validation support written in swift. Rule based validation with in built support for UITextField and UITextView, and can be extended for custom UI components. Supports credit card validation and suggestions based on input.
                   DESC
  s.homepage      = "https://github.com/altayer-digital/ATGValidator"
  s.license       = { :type => "MIT", :file => "LICENSE.md" }
  s.author        = { "surajthomask" => "suthomas@altayer.com" }
  s.platform      = :ios, "8.0"
  s.swift_version = '4.2'
  s.source        = { :git => "https://github.com/altayer-digital/ATGValidator.git", :tag => "#{s.version}" }
  s.source_files  = "ATGValidator", "ATGValidator/**/*.swift"
  s.exclude_files = "ATGValidator/Info.plist"

end
