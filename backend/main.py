from flask import Flask
from google import genai
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
print(GEMINI_API_KEY)
client = genai.Client(api_key=GEMINI_API_KEY)
timer = 30
response = client.models.generate_content(
    model="gemini-2.5-pro",
    contents=f"Provide a short reminder in few words that the users should stop using the current app to prevent doom scrolling as its already been {timer} which is the time they set for themselves. And maybe an advice on what they could use this time be doing. I need a direct answer as your response is directed to my app display",
)

print(response.text)

# app = Flask(__name__)

# @app.route("/")"
# def hello_world():
#     return "<p>Sup Dawg</p>"