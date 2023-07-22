import SwiftUI

struct MyView: View {
    @State private var isShowingPopover = false
    
    var body: some View {
            Button("Show Popover") {
                self.isShowingPopover = true
            }
            .popover(isPresented: $isShowingPopover) {
                Text("Popover Content")
                    .padding()
            }
        }
}

struct MyModalView: View {
  var body: some View {
    Text("This is a modal view")
          
  }
}

struct MyView_Previews: PreviewProvider {
  static var previews: some View {
    MyView()
  }
}
