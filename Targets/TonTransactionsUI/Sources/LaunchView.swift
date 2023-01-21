import SwiftUI

public struct LaunchView: View {
    
    public init() {}
    
    public var body: some View {
        ProgressView("Preparing App")
    }

}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
