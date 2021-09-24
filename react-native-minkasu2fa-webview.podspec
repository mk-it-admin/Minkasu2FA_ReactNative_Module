require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-minkasu2fa-webview"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-minkasu2fa-webview
                   DESC
  s.homepage     = "https://github.com/mk-it-admin/react-native-minkasu2fa-webview"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Minkasu" => "npm@minkasu.com" }
  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/mk-it-admin/react-native-minkasu2fa-webview.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "react-native-webview"
  s.dependency "Minkasu2FA", "2.3.2"
  # ...
  # s.dependency "..."
end

