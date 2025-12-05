import SwiftUI

// MARK: - Main Storybook View
struct StorybookView: View {
    @StateObject private var viewModel = StorybookViewModel()

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.49, blue: 0.92),
                    Color(red: 0.46, green: 0.29, blue: 0.64)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HeaderView(
                    isPlaying: $viewModel.isPlaying,
                    isFavorite: $viewModel.isFavorite,
                    onBack: { viewModel.goBack() }
                )

                // Vertical Paged Scrolling Content
                GeometryReader { geometry in
                    TabView(selection: $viewModel.currentPage) {
                        ForEach(1...viewModel.totalPages, id: \.self) { page in
                            VStack(spacing: 0) {
                                // Text Section
                                TextSection(
                                    pageNumber: page,
                                    totalPages: viewModel.totalPages,
                                    text: viewModel.getStoryText(for: page)
                                )

                                // Image Section
                                ImageSection(
                                    imageName: viewModel.getImageName(for: page),
                                    isPlaying: viewModel.isPlaying && viewModel.currentPage == page
                                )
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .tag(page)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }

                // Navigation
                NavigationBar(
                    currentPage: viewModel.currentPage,
                    totalPages: viewModel.totalPages,
                    onPrevious: { viewModel.previousPage() },
                    onNext: { viewModel.nextPage() }
                )
            }
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    @Binding var isPlaying: Bool
    @Binding var isFavorite: Bool
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            // Back Button
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.05))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                // Heart Button
                Button(action: { isFavorite.toggle() }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(isFavorite ? .white : .primary)
                        .frame(width: 40, height: 40)
                        .background(isFavorite ? Color.pink : Color.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                // Play/Pause Button
                Button(action: { isPlaying.toggle() }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.95),
                    Color.white.opacity(0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .background(.ultraThinMaterial)
        )
    }
}

// MARK: - Text Section
struct TextSection: View {
    let pageNumber: Int
    let totalPages: Int
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Page \(pageNumber) of \(totalPages)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
            
            Text(text)
                .font(.custom("Georgia", size: 18))
                .lineSpacing(6)
                .foregroundColor(Color(red: 0.17, green: 0.24, blue: 0.31))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(white: 0.996),
                    Color(white: 0.973)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Image Section
struct ImageSection: View {
    let imageName: String
    let isPlaying: Bool
    
    var body: some View {
        ZStack {
            Color(red: 0.941, green: 0.957, blue: 0.973)
            
            VStack {
                ZStack(alignment: .topTrailing) {
                    // Story Image Container
                    ZStack {
                        // Gradient background with shimmer effect
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 1.0, green: 0.839, blue: 0.91),
                                Color(red: 0.769, green: 0.894, blue: 1.0)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .overlay(
                            ShimmerView()
                        )
                        
                        // Placeholder illustration
                        Text(imageName)
                            .font(.system(size: 80))
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 350)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 8)
                    
                    // Playing Indicator
                    if isPlaying {
                        HStack(spacing: 4) {
                            SoundWaveView()
                            Text("Playing")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.9)
                        )
                        .cornerRadius(16)
                        .padding(8)
                    }
                }
            }
            .padding(16)
        }
        .frame(minHeight: 400)
    }
}

// MARK: - Shimmer Effect
struct ShimmerView: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.3),
                    Color.clear
                ]),
                center: .center,
                startRadius: 0,
                endRadius: geometry.size.width * 0.7
            )
            .offset(x: phase * geometry.size.width - geometry.size.width / 2,
                    y: phase * geometry.size.height - geometry.size.height / 2)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 3)
                        .repeatForever(autoreverses: true)
                ) {
                    phase = 1
                }
            }
        }
    }
}

// MARK: - Sound Wave Animation
struct SoundWaveView: View {
    @State private var animationPhases: [Bool] = [false, false, false]
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .frame(width: 2, height: animationPhases[index] ? 14 : 8)
                    .animation(
                        Animation.easeInOut(duration: 1)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: animationPhases[index]
                    )
            }
        }
        .onAppear {
            for index in 0..<3 {
                animationPhases[index] = true
            }
        }
    }
}

// MARK: - Navigation Bar
struct NavigationBar: View {
    let currentPage: Int
    let totalPages: Int
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        HStack {
            // Previous Button
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.gray)
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.05))
                    .clipShape(Circle())
            }
            .disabled(currentPage == 1)
            .opacity(currentPage == 1 ? 0.5 : 1)
            
            Spacer()
            
            // Page Indicators
            HStack(spacing: 6) {
                ForEach(1...totalPages, id: \.self) { page in
                    if page == currentPage {
                        Capsule()
                            .fill(Color(red: 0.4, green: 0.49, blue: 0.92))
                            .frame(width: 24, height: 8)
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
            }
            
            Spacer()
            
            // Next Button
            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.4, green: 0.49, blue: 0.92),
                                Color(red: 0.46, green: 0.29, blue: 0.64)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.3),
                            radius: 6, x: 0, y: 4)
            }
            .disabled(currentPage == totalPages)
            .opacity(currentPage == totalPages ? 0.5 : 1)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .padding(.bottom, 12)
        .background(Color.white)
    }
}

// MARK: - View Model
class StorybookViewModel: ObservableObject {
    @Published var currentPage: Int = 1
    @Published var isPlaying: Bool = false
    @Published var isFavorite: Bool = false
    
    let totalPages: Int = 5
    
    // Sample story data
    private let storyPages: [StoryPage] = [
        StoryPage(
            text: "Luna the little fox woke up to the sound of raindrops tapping on her den. Today felt different, magical even. She could feel an adventure calling to her from beyond the misty forest.",
            imageName: "🦊"
        ),
        StoryPage(
            text: "She ventured out into the rain, her fur glistening with droplets. The forest seemed to whisper secrets as she walked deeper into the mist.",
            imageName: "🌲"
        ),
        StoryPage(
            text: "Suddenly, she discovered a hidden path lined with glowing mushrooms. Each step forward lit up the way, guiding her to somewhere special.",
            imageName: "🍄"
        ),
        StoryPage(
            text: "At the end of the path, Luna found a beautiful clearing where all the forest animals had gathered for a celebration.",
            imageName: "🦋"
        ),
        StoryPage(
            text: "They welcomed Luna with open arms, and she realized that sometimes the best adventures are the ones you don't plan.",
            imageName: "✨"
        )
    ]
    
    var currentStoryText: String {
        getStoryText(for: currentPage)
    }

    var currentImageName: String {
        getImageName(for: currentPage)
    }

    func getStoryText(for page: Int) -> String {
        guard page > 0 && page <= storyPages.count else { return "" }
        return storyPages[page - 1].text
    }

    func getImageName(for page: Int) -> String {
        guard page > 0 && page <= storyPages.count else { return "" }
        return storyPages[page - 1].imageName
    }

    func nextPage() {
        if currentPage < totalPages {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        }
    }

    func previousPage() {
        if currentPage > 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage -= 1
            }
        }
    }

    func goBack() {
        // Handle back navigation
        print("Back button tapped")
    }
}

// MARK: - Story Page Model
struct StoryPage {
    let text: String
    let imageName: String
}

// MARK: - Preview
struct StorybookView_Previews: PreviewProvider {
    static var previews: some View {
        StorybookView()
    }
}
