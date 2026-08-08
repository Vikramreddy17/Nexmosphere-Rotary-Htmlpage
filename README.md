# Nexmosphere Rotary Encoder Showcase

A modern, highly responsive product showcase web application designed to run on a **BrightSign** media player integrated with a **Nexmosphere Rotary Encoder** sensor. 

The web page listens to incoming rotary encoder status messages through BrightSign's HTML5 `BSMessagePort` interface, updating the displayed product dynamically in real-time. It also includes an interactive local simulator panel for quick browser-based debugging without needing hardware.

---

## 📂 Project Structure

```text
Nexmosphere-Rotary-Htmlpage/
├── index.html       # Single-page showcase app with responsive CSS, JS & Simulator
├── README.md        # Documentation, hardware & deployment instructions
└── .gitignore       # Git exclusion file
```

---

## 🛠️ Hardware Integration Setup

To get this running on physical hardware, follow these setup guides:

### 1. Hardware Connections
1. Connect the **Nexmosphere Rotary Sensor** (typically model ER-series) to a **Nexmosphere Controller** (e.g., X-Range controller).
2. Connect the Nexmosphere Controller to the **BrightSign** player using a USB or serial RS-232 cable.
3. Note the serial port configuration of the controller (usually `9600` baud rate, 8 data bits, no parity, 1 stop bit).

### 2. BrightScript Autorun Configuration
To relay Nexmosphere serial commands to the HTML page, you must write a BrightScript `autorun.brs` script or configure it in BrightAuthor. The script reads from the serial port and posts the data to the HTML widget.

Example BrightScript snippet to forward serial events:
```brightscript
' Initialize serial port
serial = CreateObject("roSerialPort", 0, 9600) ' Port 0 or USB port number

' Initialize HTML widget
htmlWidget = CreateObject("roHtmlWidget", rect)
htmlWidget.SetUrl("file:///sd:/index.html")
htmlWidget.Show()

' Enable message port communication
port = CreateObject("roMessagePort")
serial.SetPort(port)
htmlWidget.SetPort(port)

' Message Loop
while true
    msg = wait(0, port)
    if type(msg) = "roSerialPortEvent" then
        dataStr = msg.GetString()
        ' Example serial data format: "X002B[Dr=4]"
        ' Send directly to the HTML JavaScript context
        htmlWidget.PostJSMessage({data: dataStr})
    end if
end while
```

### 3. Rotary Serial Protocol Details
The Nexmosphere rotary encoder generates serial packet strings indicating the current position:
- **Idle State:** `X002B[Dr=0]`
- **Product Positions:** `X002B[Dr=1]` up to `X002B[Dr=20]`
- When the position changes, the JavaScript `parseRotaryData(dataString)` parses the position integer and switches products accordingly.

---

## 🌐 Deploying to GitHub Pages

To host this project on GitHub Pages so it can be previewed or loaded directly onto internet-connected BrightSign players:

1. **Push the repository to GitHub:**
   - Commit and push all files to your GitHub repository: `https://github.com/Vikramreddy17/Nexmosphere-Rotary-Htmlpage.git`.
2. **Enable GitHub Pages:**
   - Go to your repository on GitHub.
   - Click on **Settings** (gear icon) -> **Pages** (in the left sidebar).
   - Under **Build and deployment**, select **Deploy from a branch**.
   - Under **Branch**, select `main` (or `master`) and `/root` directory, then click **Save**.
3. **Access your Showcase:**
   - After a few minutes, your site will be live at `https://vikramreddy17.github.io/Nexmosphere-Rotary-Htmlpage/`.

---

## 💻 Local Testing & Browser Preview

To simplify development, an elegant **Rotary Simulator** is embedded directly into the page. 
- **Auto-detection:** If the page runs in a standard browser (where `BSMessagePort` is undefined), the floating **Rotary Simulator Panel** will appear at the bottom-right corner automatically.
- **Controls:** You can drag the slider or click buttons `0` through `20` to instantly mock Nexmosphere serial events.
- **Minimizing:** Click "Minimize" to keep the simulator out of the way of the showcase preview.
- **Arrow Keys:** Left & Right arrow keys on your keyboard also allow manual browsing.
