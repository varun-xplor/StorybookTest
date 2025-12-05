# StorybookTest

A standalone iOS app showcasing a beautiful storybook UI with vertical scrolling.

## Features

- **Vertical Page Scrolling**: Swipe up/down to navigate through story pages
- **Interactive Controls**: Play/pause audio, favorite stories, and navigate with buttons
- **Beautiful Animations**: Gradient backgrounds, shimmer effects, and sound wave animations
- **5-Page Sample Story**: Luna the fox's adventure through the misty forest

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.0+

## How to Run

1. Open `StorybookTest.xcodeproj` in Xcode
2. Select a simulator (iPhone or iPad)
3. Press Cmd+R to build and run

## Architecture

- **StorybookView**: Main view with vertical TabView for page swiping
- **HeaderView**: Navigation header with controls
- **TextSection**: Displays story text for each page
- **ImageSection**: Shows story illustrations with animations
- **NavigationBar**: Bottom navigation with page indicators
- **StorybookViewModel**: Manages story state and data

## UI Components

- Custom gradient backgrounds
- Animated shimmer effects
- Sound wave animation for audio playback
- Page indicators with smooth transitions
- Responsive layouts for different screen sizes
