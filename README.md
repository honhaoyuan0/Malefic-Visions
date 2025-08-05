## Getting Started

To run the app smoothly first start up the flask application backend 
1. cd malefic_visions/backend
2. Enter the venv:
   - **Mac/Linux**: `source .venv/bin/activate`
   - **Windows (Command Prompt)**: `.venv\Scripts\activate.bat`
   - **Windows (PowerShell)**: `.venv\Scripts\Activate.ps1`
3. Install dependencies: `pip install -r requirements.txt`
4. Run the Flask app in debug mode: `flask --app main run --debug`, by default the flask application will run on port 5000 @ localhost

You could skip it if you dont like the dynamic reminding texts on the reminder overlay and just proceed with the frontend session but first you will need to setup the environment for flutter and also android simulator.

Then you can just open up your simulator and do `flutter run` to fire up our app and do testing.