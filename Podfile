platform :ios, '11.0'

def common_pods
    pod 'SDWebImage', '~> 4.3'
    pod 'PureLayout', '~> 3.0'
    pod 'IHKeyboardAvoiding', '~> 4.2'
    pod 'FMDB', '~> 2.7'
    pod 'RealmSwift', '~> 3.1.1'
    pod 'FBSDKLoginKit'
end

target 'Pupperino-dev' do
    inherit! :search_paths
    
    use_frameworks!
    
    # Pods for Pupperino development target
    common_pods

    target 'PupperinoTests' do
        inherit! :search_paths
        # Pods for testing
    end
end

target 'Pupperino-prd' do
    use_frameworks!

    # Pods for Pupperino production target
    common_pods
end
