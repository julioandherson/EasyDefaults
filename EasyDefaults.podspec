Pod::Spec.new do |spec|
  spec.name         = "EasyDefaults"
  spec.version      = "1.0.0"
  spec.summary      = "A simplified access to UserDefaults, supporting type inference for common types and Codable objects."
  spec.description  = "EasyDefaults provides a property wrapper and helper for UserDefaults with type inference and Codable support."
  spec.homepage     = "https://github.com/julioandherson/EasyDefaults"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Júlio Andherson" => "julioandherson1@gmail.com" }
  spec.platform     = :ios, "15.6"
  spec.source       = { :git => "https://github.com/julioandherson/EasyDefaults.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources/*.{swift}"
end