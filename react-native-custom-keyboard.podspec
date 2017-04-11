require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name     = "react-native-custom-keyboard"
  s.version  = package['version']
  s.summary  = package['description']
  s.homepage = "https://github.com/reactnativecn/react-native-custom-keyboard.git"
  s.license  = package['license']
  s.author   = package['author']
  s.source   = { :git => "https://github.com/reactnativecn/react-native-custom-keyboard.git", :tag => "v#{s.version}" }

  s.platform = :ios, "8.0"

  s.preserve_paths = 'README.md', 'LICENSE', 'package.json', 'index.js'
  s.source_files   = "ios/*.{h,m}"

  s.dependency 'React'
end
