
Pod::Spec.new do |s|

  s.name         = "LNSelectPhotos"
  s.version      = "0.0.9"
  s.summary      = "照片选择"
  s.description  = <<-DESC
照片选择，多选，单选，预览
                   DESC

  s.homepage     = "https://github.com/LenaMay/LNSelectPhotos.git"
  s.license      = { :type => "MIT" }

  s.author             = { "Lina" => "17701031767@163.com" }

  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/LenaMay/LNSelectPhotos.git",  :tag  => s.version }



  s.source_files  = "selectPhoto/**/*.{h,m}"
  s.resources = "selectPhoto/source/*.png"
  s.frameworks = "Foundation", "Photos", "UIKit"

  s.dependency 'Masonry', '~>1.1.0'
end
