# RenFile – Windows Batch File Renamer

RenFile is a **simple Windows batch script** that helps you rename all files in a folder automatically.  
It comes with several rename modes, so you can organize your files exactly the way you want.  
No installation required – just run the `.bat` file and follow the menu.

## Features

- **Number mode** → Sequential numbers  
  Example: `001.jpg`, `002.png`, `003.mp4`

- **Alpha mode** → Alphabetical IDs  
  Example: `aaaa.jpg`, `aaab.png`, `aaac.mp3`

- **Crypt mode** → Random GUIDs (unique IDs)  
  Example: `08e94883-b463-4c2a-a7d2-fd3e77d9f7b1.png`

- **Date mode** → Last modified date + index  
  Example: `12_09_2025_001.png`, `12_09_2025_002.jpg`

- **Size mode** → File size in KB + index  
  Example: `234KB_001.mp3`, `789KB_002.mp4`

- **Custom mode** → Your own prefix + sequential number  
  Example: `MyFiles_001.jpg`, `MyFiles_002.png`

## How it works

1. **Start the script**  
   Double-click `RenFile.bat`.

2. **Choose a folder**  
   Enter the path of the folder that contains your files.  
   Example:  
C:\Users\YourName\Pictures

markdown
Copy code

3. **Select a mode**  
Choose one of the rename modes from the menu (number, alpha, crypt, date, size, custom).

4. **Renaming process**  
- All files will be renamed automatically.  
- A **progress bar** shows you how far the process is.  

5. **Done!**  

## Installation

1. Download or clone this repository:  
```bash
git clone https://github.com/woxcv/RenFile.git
