# ✨ TaskMint | Premium To-Do & Expense Manager

TaskMint is a high-end, startup-grade Flutter application designed for modern productivity. It combines a powerful **To-Do List** with a robust **Expense Tracker**, all wrapped in a stunning **3D-inspired Glassmorphism UI**.

Developed with a focus on visual excellence and production-quality code, TaskMint delivers a premium experience that goes far beyond basic CRUD applications.

---

## 🌟 Visual Showcase

| Feature | Design Philosphy |
| :--- | :--- |
| **UI Style** | Neumorphism & Glassmorphism hybrid |
| **Depth** | Layered cards with deep, soft shadows |
| **Motion** | Fluid page transitions & spring animations |
| **Theming** | Expertly curated Dark & Light modes |

---

## 🚀 Key Features

### 📅 Advanced To-Do Module
- **Intuitive Management**: Add, edit, and organize daily tasks with ease.
- **Visual Context**: Attach images from your gallery to tasks (paths stored locally).
- **Date Tracking**: Set due dates and view them in a clean, professional layout.
- **Status Filtering**: Instantly filter between *All*, *Pending*, and *Completed* tasks.

### 💰 Smart Expense Tracker
- **Financial Control**: Track spending with specialized categories (Food, Transport, Bills, etc.).
- **Dashboard Analysis**: Real-time spending summaries and "Total Spent" analysis.
- **Detailed History**: Swipe-to-delete functionality for efficient record management.

### 🛠️ Core Infrastructure
- **Data Persistence**: Powered by `SharedPreferences` with high-performance JSON serialization.
- **State Management**: Clean and predictable state using the `Provider` pattern.
- **Dynamic Theming**: One-tap transition between a luxury Dark mode and a crisp Light mode.
- **Animated Navigation**: A unique, floating bottom navigation bar with micro-animations.

---

## 🏗️ Technical Architecture

TaskMint follows a strict modular architecture to ensure scalability and maintainability:

- **`lib/models`**: Strongly typed data classes for Task and Expense objects.
- **`lib/services`**: Centralized logic for local storage and global state management.
- **`lib/theme`**: Centralized design tokens (colors, typography, elevation).
- **`lib/widgets`**: Reusable premium components like the custom `GlassCard`.
- **`lib/screens`**: Logic-separated UI implementation for each app module.

---

## 🚦 Getting Started

### Prerequisites
- Flutter SDK (v3.10.8 or higher)
- Android Studio / VS Code
- A physical device or emulator

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/taskmint.git
   ```
2. Navigate to the project directory:
   ```bash
   cd taskmint
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

- `provider`: Reactive state management.
- `shared_preferences`: Local persistent storage.
- `google_fonts`: Premium typography (Outfit).
- `animations`: Material motion for smooth transitions.
- `intl`: Professional date and currency formatting.
- `image_picker`: Secure gallery access.
- `uuid`: Secure unique identifier generation.
- `flutter_launcher_icons`: Automated branding configuration.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

##  Contact

**TaskMint Team** - [Your Name/GitHub](https://github.com/yourusername)

Project Link: [https://github.com/yourusername/taskmint](https://github.com/yourusername/taskmint)

*Built with  using Flutter*
