# Malefic Visions

A Screen Time intervention app with AI-powered personalized reminders to help users reduce excessive social media usage.

## Project Structure

- `backend/` - Flask API server with Google Gemini AI integration
- `frontend/` - Flutter mobile application with system overlay permissions

## Getting Started

### Backend Setup (Flask + AI)

The backend provides AI-generated motivational reminders based on user's timer settings. Follow these steps to set it up:

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Create Python virtual environment:**
   ```bash
   python3 -m venv venv
   ```

3. **Activate the virtual environment:**
   - **Mac/Linux**: `source venv/bin/activate`
   - **Windows (Command Prompt)**: `venv\Scripts\activate.bat`
   - **Windows (PowerShell)**: `venv\Scripts\Activate.ps1`

4. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

5. **Set up environment variables:**
   Create a `.env` file in the backend directory and add your Google Gemini API key:
   ```
   GEMINI_API_KEY=your_api_key_here
   ```

6. **Run the Flask server:**
   ```bash
   flask --app main run --debug
   ```
   The API will be available at `http://localhost:5000`

**Note:** The backend is optional but recommended. Without it, you'll get static reminder text instead of AI-generated personalized advice based on your timer settings.

### Frontend Setup (Flutter)

1. **Navigate to frontend directory:**
   ```bash
   cd frontend
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up Android emulator or connect physical device**

4. **Run the Flutter app:**
   ```bash
   flutter run
   ```

The app will connect to the backend API (if running) to fetch AI-generated reminders when you set timers.