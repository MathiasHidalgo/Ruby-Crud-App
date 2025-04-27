# config/initializers/cors.rb

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Allow CORS requests from hostname + port.

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      # Replace 'http://localhost:3001' with the actual origin of your React app
      # If your React app is running on port 3000, use 'http://localhost:3000'
      # In production, this would be your frontend's domain (e.g., 'https://my-react-app.com')
      origins 'http://localhost:5173' # Example: Assuming your React app runs on port 3000
  
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end