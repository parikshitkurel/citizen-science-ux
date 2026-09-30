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
    with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()

def capture_all():
    # Start local HTTP server in background thread
    server_thread = threading.Thread(target=run_server, daemon=True)
    server_thread.start()
    time.sleep(1)

    os.makedirs("screenshots", exist_ok=True)
    screenshot_paths = []

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            viewport={"width": 430, "height": 932},
            device_scale_factor=2
        )

        page = context.new_page()
        print("1. Capturing Welcome Screen...")
        page.goto(f"http://127.0.0.1:{PORT}")
        time.sleep(5)
        p1 = "screenshots/01_welcome_screen.png"
        page.screenshot(path=p1)
        screenshot_paths.append(p1)

        print("2. Capturing Home Dashboard...")
        page.mouse.click(215, 810) # Click 'Get Started'
        time.sleep(2.5)
        p2 = "screenshots/02_home_dashboard.png"
        page.screenshot(path=p2)
        screenshot_paths.append(p2)

        print("3. Capturing Assessment Step 1 (Location & Water Body)...")
        page.mouse.click(215, 315) # Click 'Start New Assessment'
        time.sleep(2.5)
        p3 = "screenshots/03_assessment_step1_location.png"
        page.screenshot(path=p3)
        screenshot_paths.append(p3)

        print("4. Capturing Assessment Step 2 (Water Appearance)...")
        page.mouse.click(215, 894) # Click 'Next Step'
        time.sleep(2.5)
        p4 = "screenshots/04_assessment_step2_appearance.png"
        page.screenshot(path=p4)
        screenshot_paths.append(p4)

        print("5. Capturing Assessment Step 3 (Environmental Factors)...")
        page.mouse.click(310, 894) # Click 'Next Step'
        time.sleep(2.5)
        p5 = "screenshots/05_assessment_step3_environment.png"
        page.screenshot(path=p5)
        screenshot_paths.append(p5)

        print("6. Capturing Assessment Step 4 (Field Notes & Disclaimer)...")
        page.mouse.click(310, 894) # Click 'Next Step'
        time.sleep(2.5)
        p6 = "screenshots/06_assessment_step4_notes.png"
        page.screenshot(path=p6)
        screenshot_paths.append(p6)

        print("7. Capturing Review & Verification Screen...")
        page.mouse.click(310, 894) # Click 'Review Summary'
        time.sleep(2.5)
        p7 = "screenshots/07_review_screen.png"
        page.screenshot(path=p7)
        screenshot_paths.append(p7)
        page.close()

        # History & Details flow
        page2 = context.new_page()
        print("8. Capturing History Screen...")
        page2.goto(f"http://127.0.0.1:{PORT}")
        time.sleep(4)
        page2.mouse.click(215, 866) # Click 'View My Observations'
        time.sleep(2.5)
        p8 = "screenshots/08_history_screen.png"
        page2.screenshot(path=p8)
        screenshot_paths.append(p8)

        print("9. Capturing Observation Details Screen...")
        page2.mouse.click(215, 310) # Click first observation card
        time.sleep(2.5)
        p9 = "screenshots/09_observation_detail.png"
        page2.screenshot(path=p9)
        screenshot_paths.append(p9)
        page2.close()

        browser.close()

    print(f"Captured all {len(screenshot_paths)} screens.")
    print("Compiling AquaVerify_Screenshots.pdf...")
    images = [Image.open(p).convert("RGB") for p in screenshot_paths if os.path.exists(p)]
    if images:
        images[0].save(
            "AquaVerify_Screenshots.pdf",
            save_all=True,
            append_images=images[1:],
            resolution=150.0
        )
        print("Successfully generated AquaVerify_Screenshots.pdf!")

if __name__ == "__main__":
    capture_all()
