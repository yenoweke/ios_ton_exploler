import SwiftUI
import TonTransactionsKit

enum LoadingViewState<ViewState> {
    case initial
    case loading
    case loaded(ViewState)
    case error(ErrorViewModel)
}

struct LoadingView<ViewState, PlaceholderView: View, ContentView: View, LoadingErrorView: View>: View {
    
    @Binding var state: LoadingViewState<ViewState>

    let startInitialLoading: VoidClosure
    let placeholderView: () -> PlaceholderView
    let loadedView: (ViewState) -> ContentView
    let errorView: (ErrorViewModel) -> LoadingErrorView

    @ViewBuilder
    var body: some View {
        switch state {
        case .initial:
            Color.clear
                    .onAppear(perform: self.startInitialLoading)
            
        case .loading:
            self.placeholderView()

        case .loaded(let viewState):
            self.loadedView(viewState)
            
        case .error(let viewModel):
            self.errorView(viewModel)

//            ErrorView(
//                title: title,
//                description: description,
//                retry: retry
//            )
        }
    }

    init(
            state: Binding<LoadingViewState<ViewState>>,
            startInitialLoading: @escaping VoidClosure,
            placeholderView: @escaping () -> PlaceholderView,
            loadedView: @escaping (ViewState) -> ContentView,
            errorView: @escaping (ErrorViewModel) -> LoadingErrorView
    ) {
        self._state = state
        self.startInitialLoading = startInitialLoading
        self.placeholderView = placeholderView
        self.loadedView = loadedView
        self.errorView = errorView
    }
}

//struct LoadingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingView(
//            state: Binding(get: { .initial }, set: { _ in }),
//            loadedView: { (text: String) in
//                Text(text)
//                    .bold()
//                    .padding()
//            }
//        )
//        .previewLayout(.sizeThatFits)
//        LoadingView(
//            state: Binding(get: { .loading }, set: { _ in }),
//            loadedView: { (text: String) in
//                Text(text)
//                    .bold()
//                    .padding()
//            }
//        )
//        .previewLayout(.sizeThatFits)
//
//        LoadingView(
//            state: Binding(get: { .loaded("Loaded") }, set: { _ in }),
//            loadedView: { (text: String) in
//                Text(text)
//                    .bold()
//                    .padding()
//            }
//        )
//        .previewLayout(.sizeThatFits)
//
//        LoadingView(
//            state: Binding(get: { .error(title: "Title", description: "description", retry: {} ) }, set: { _ in }),
//            loadedView: { (text: String) in
//                Text(text)
//                    .bold()
//                    .padding()
//            }
//        )
//        .previewLayout(.sizeThatFits)
//
//    }
//}
