import os
import time
import threading
import http.server
import socketserver
from playwright.sync_api import sync_playwright
from PIL import Image

PORT = 8099
DIRECTORY = os.path.join(os.path.dirname(__file__), "build", "web")

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
    def log_message(self, format, *args):
        pass # suppress logs

def run_server():
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()

def capture_all():
    server_thread = threading.Thread(target=run_server, daemon=True)
    server_thread.start()
    time.sleep(1.5)

    os.makedirs("screenshots", exist_ok=True)
    screens = [
        ("welcome", "screenshots/01_welcome_screen.png", "1. Welcome Screen"),
        ("home", "screenshots/02_home_dashboard.png", "2. Home Dashboard"),
        ("step1", "screenshots/03_assessment_step1_location.png", "3. Step 1: Location & Water Body"),
        ("step2", "screenshots/04_assessment_step2_appearance.png", "4. Step 2: Water Appearance"),
        ("step3", "screenshots/05_assessment_step3_environment.png", "5. Step 3: Environmental Factors"),
        ("step4", "screenshots/06_assessment_step4_notes.png", "6. Step 4: Field Notes & Disclaimer"),
        ("review", "screenshots/07_review_screen.png", "7. Review & Verification"),
        ("history", "screenshots/08_history_screen.png", "8. Observation History"),
        ("details", "screenshots/09_observation_detail.png", "9. Observation Details"),
    ]

    screenshot_paths = []

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            viewport={"width": 430, "height": 932},
            device_scale_factor=2
        )

        for screen_key, file_path, label in screens:
            print(f"Capturing {label} (/#/{screen_key})...")
            page = context.new_page()
            page.goto(f"http://127.0.0.1:{PORT}/#/{screen_key}")
            time.sleep(4.0)
            page.screenshot(path=file_path)
            size = os.path.getsize(file_path)
            print(f"  -> Saved {file_path} ({size} bytes)")
            screenshot_paths.append(file_path)
            page.close()

        browser.close()

    print(f"Captured all {len(screenshot_paths)} distinct screens.")
    print("Compiling AquaVerify_Screenshots.pdf...")
    images = [Image.open(p).convert("RGB") for p in screenshot_paths if os.path.exists(p)]
    if images:
        images[0].save(
            "AquaVerify_Screenshots.pdf",
            save_all=True,
            append_images=images[1:],
            resolution=150.0
        )
        print("SUCCESS! AquaVerify_Screenshots.pdf has been generated.")

if __name__ == "__main__":
    capture_all()
