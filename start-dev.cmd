@echo off
echo Starting Ping Auto Driver App (Flutter Web Server)...
echo Application will be available at http://localhost:8080
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
