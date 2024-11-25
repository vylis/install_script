# INSTALLATION GUIDE

## Step 1: Setup script
First, make the installation script executable:

```bash
chmod +x ./setup_xx.sh
```

Then, run the installation script:

```bash
./setup_xx.sh
```

## Step 2: VSCode extensions script
Next, make the VSCode extensions installation script executable:

```bash
chmod +x ./extensions_vscode.sh
```
Before running the installation script, make sure that the 'code' command is available in your PATH:

- Open VSCode
- Press ```Ctrl + Shift + P```
- Type ```Shell Command: Install 'code' command in PATH``` 

Then, run the installation script:

```bash
./extensions_vscode.sh
```

Then, go to settings, check the option ```Format on Save``` and set your defaut formatter.