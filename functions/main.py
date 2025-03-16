import os
from firebase_functions import https_fn
from flask import Flask, request, jsonify
import joblib  # For loading your saved model
import numpy as np

# Initialize the Flask app
app = Flask(__name__)

# Attempt to load the model with error handling
try:
    model = joblib.load('model.pkl')  # Replace with your model's path
except Exception as e:
    model = None
    print(f"Error loading model: {e}")

# Define the route to handle prediction
@app.route('/predict', methods=['POST'])
def predict():
    if model is None:
        return jsonify({'error': 'Model is not loaded properly.'}), 500

    try:
        # Get the JSON data from the request
        data = request.get_json(force=True)

        # Ensure 'features' key exists in the input data
        if 'features' not in data:
            return jsonify({'error': "'features' key is missing in input data."}), 400

        features = np.array(data['features']).reshape(1, -1)

        # Ensure the features are valid for the model
        if features.shape[1] != model.n_features_in_:
            return jsonify({'error': f"Incorrect number of features. Expected {model.n_features_in_}, got {features.shape[1]}."}), 400
        
        # Run prediction
        prediction = model.predict(features)
        probability = model.predict_proba(features)  # To get the probability for classification tasks

        return jsonify({
            'prediction': prediction.tolist(),
            'probability': probability.tolist()
        })

    except Exception as e:
        # Catch any other unexpected errors
        return jsonify({'error': f'Error during prediction: {str(e)}'}), 500

# if __name__ == '__main__':
#     app.run(debug=True)


# Define the Firebase function using the @https_fn.on_request decorator
@https_fn.on_request(max_instances=1)
def predict_function(req: https_fn.Request) -> https_fn.Response:  # Changed function name
    with app.request_context(req.environ):
        return app.full_dispatch_request()
