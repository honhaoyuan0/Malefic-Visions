from flask import Flask, request, jsonify
from flask_cors import CORS
from google import genai
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter app to call this API

# Initialize Gemini client
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY not found in environment variables")

client = genai.Client(api_key=GEMINI_API_KEY)

@app.route('/reminder', methods=['POST'])
def get_reminder():
    try:
        # Get timer value from request
        data = request.get_json()
        timer = data.get('timer', 30)  # Default to 30 minif not provided
        
        # Generate AI response
        response = client.models.generate_content(
            model="gemini-2.0-flash-exp",
            contents=f"Provide a short reminder in few words that the user should stop using the current app to prevent doom scrolling as it's already been {timer} seconds, which is the time they set for themselves. And maybe an advice on what they could be doing instead. I need a direct answer as your response is directed to my app display. Keep it under 50 words and motivational.",
        )
        
        return jsonify({
            'success': True,
            'message': response.text,
            'timer': timer
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'healthy',
        'message': 'Malefic Visions backend is running'
    })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)