Open VS Code: Launch Visual Studio Code on your computer.
 
    Open Settings:
        On Windows/Linux: Press Ctrl + , (Control + comma).
        On macOS: Press Cmd + , (Command + comma).
 
    Open Settings JSON:
        In the Settings tab, click on the Open Settings (JSON) icon in the top-right corner. It looks like an open curly brace {}.
 
    Copy and Paste the Settings:
        Copy the JSON settings you provided.
        Paste them into the settings.json file that opens. If there are existing settings, make sure to merge them appropriately.
 
    Save the File:
        Save the settings.json file by pressing Ctrl + S (Windows/Linux) or Cmd + S (macOS).
 
```json
{
  "security.workspace.trust.untrustedFiles": "open",
  "workbench.colorCustomizations": {
    "terminal.background": "#00000000"
  },
  "workbench.settings.applyToAllProfiles": ["workbench.colorCustomizations"],
  "explorer.confirmDelete": false,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[cpp]": {
    "editor.defaultFormatter": "xaver.clang-format"
  },
  "[c]": {
    "editor.defaultFormatter": "xaver.clang-format"
  }
}
```