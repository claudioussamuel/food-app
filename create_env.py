#!/usr/bin/env python3
"""
Simple script to create a .env file for the FooduApp project.
Run this script to create a template .env file with placeholder values.
"""

import os

def create_env_file():
    env_content = """# Google API Key for Maps and Places
# Get your API key from: https://console.cloud.google.com/
# Make sure to enable the following APIs:
# - Maps SDK for Android
# - Maps SDK for iOS  
# - Places API
# - Geocoding API
GOOGLE_API_KEY=your_google_api_key_here

# Firebase Configuration (if needed)
# FIREBASE_API_KEY=your_firebase_api_key
# FIREBASE_APP_ID=your_firebase_app_id
# FIREBASE_PROJECT_ID=your_firebase_project_id

# Other environment variables
# APP_NAME=FooduApp
# APP_VERSION=1.0.0
"""

    env_file_path = ".env"
    
    if os.path.exists(env_file_path):
        print(f"⚠️  {env_file_path} file already exists!")
        response = input("Do you want to overwrite it? (y/N): ")
        if response.lower() != 'y':
            print("❌ Operation cancelled.")
            return
    
    try:
        with open(env_file_path, 'w') as f:
            f.write(env_content)
        print(f"✅ {env_file_path} file created successfully!")
        print("\n📝 Next steps:")
        print("1. Get your Google API key from: https://console.cloud.google.com/")
        print("2. Replace 'your_google_api_key_here' with your actual API key")
        print("3. Enable the required APIs (Maps SDK, Places API, Geocoding API)")
        print("4. Restart your Flutter app")
        print("\n⚠️  Remember: Never commit the .env file to version control!")
        
    except Exception as e:
        print(f"❌ Error creating {env_file_path}: {e}")

if __name__ == "__main__":
    print("🚀 FooduApp Environment Setup")
    print("=" * 40)
    create_env_file()
