# Nexmosphere Rotary Encoder Showcase

A modern, highly responsive product showcase web application designed to run on a **BrightSign** media player integrated with a **Nexmosphere Rotary Encoder** sensor. 

The web page listens to incoming rotary encoder status messages through BrightSign's HTML5 `BSMessagePort` interface (using the `onbsmessage` handler), updating the displayed product dynamically in real-time. It also includes an interactive local simulator panel for quick browser-based debugging without needing hardware.

---

## 📂 Project Structure

```text
Nexmosphere-Rotary-Htmlpage/
├── index.html               # Single-page showcase app with responsive CSS, JS & Simulator
├── nexmosphere_plugin.brs   # BrightSign presentation plug-in to route serial input
├── README.md                # Documentation, hardware & deployment instructions
└── .gitignore               # Git exclusion file
```

---

## 🛠️ Hardware & BrightSign Setup Guide

To connect the Nexmosphere rotary inputs to the HTML page, you must configure BrightSign to listen on the serial port and forward messages to the HTML widget. There are two ways to do this:

### Option A: Using the BrightScript Plugin (Recommended & Easiest)
We have provided a plug-in script (`nexmosphere_plugin.brs`) in this repository. It automatically handles the serial port connection and forwards all incoming messages to your HTML widget.

1. **Add the Plugin in BrightAuthor:**
   - In BrightAuthor, go to **Presentation Properties** -> **Autorun** tab.
   - Under **Selected Script Plugins**, click **Add** and upload `nexmosphere_plugin.brs`.
   - Set the plugin name to: `nexmosphere_plugin`.
2. **Done!** The plugin will run in the background, intercept all serial messages from the Nexmosphere controller, and send them to the HTML site automatically.

---

### Option B: Pure BrightAuthor UI Setup (No Code)
If you prefer not to use plugins and want to do it purely inside the BrightAuthor user interface:

1. **Set Up Serial Configuration:**
   - Go to **Presentation Properties** -> **Interactive** tab -> **Serial** tab.
   - Ensure the serial port baud rate is set to match the Nexmosphere controller (normally `9600` baud).
2. **Define a User Variable:**
   - Go to **Presentation Properties** -> **Variables** tab.
   - Add a new variable called `RotaryPosition`. Set its default value to `00`.
3. **Configure the HTML5 State and Serial Events:**
   - In your interactive presentation playlist, place your HTML5 state pointing to the URL of this page (GitHub Pages URL).
   - Click and drag a **Serial Input** event icon onto the HTML5 state. Point the transition line back to the HTML5 state itself (creating a self-loop).
   - In the **Serial Input** event properties:
     - Set the matching command string to: `X002B[Dr=<*>]` (using `<*>` as a wildcard).
     - Under the **Variables** tab in the event settings, assign the wildcard value to the `RotaryPosition` user variable.
4. **Trigger HTML5 Message Event:**
   - Under the **Advanced** tab of the Serial Input event properties:
     - Click **Add Action**.
     - Choose command category: **HTML5**.
     - Choose action command: **Send HTML5 Message** (or **Send Message to HTML Widget**).
     - For the parameter/payload value, type: `X002B[Dr=%%RotaryPosition%%]` (or use the wildcard expression directly to construct `X002B[Dr=<*>]` so it matches the format expected by the HTML javascript parser).
5. **Publish:** Publish your presentation to the player.

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
