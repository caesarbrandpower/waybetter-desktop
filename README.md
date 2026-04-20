# Waybetter Desktop

A lightweight macOS menu bar app for capturing and transcribing audio, saving both the recording and transcript as local files.

Press a hotkey, speak your thoughts, and get a timestamped audio file and transcript in a folder of your choice. If you put that folder in Google Drive, Dropbox, or iCloud, your OS syncs everything automatically.

---

## Features

- **Global hotkey recording** - default Cmd+Shift+Space, configurable
- **Multiple transcription engines** - local WhisperKit (offline, no API key needed), OpenAI Whisper, Google Gemini, Parakeet-MLX
- **File-first output** - every recording produces a `.m4a` audio file and a `_transcript.txt` file
- **Choose your folder** - Settings let you pick any local folder; cloud sync happens via your OS
- **Recent recordings** - the menu bar dropdown shows your last 5 recordings with quick Finder access
- **Transcription history** - optional searchable history dashboard
- **Smart paste** - optional auto-paste into the active app via Accessibility permission
- **Secure** - API keys stored in macOS Keychain; local modes keep audio on-device

---

## Requirements

- macOS 14.0 (Sonoma) or later
- Apple Silicon recommended (required for Parakeet-MLX and local MLX semantic correction)
- No API key needed when using local WhisperKit

---

## Installation (from source)

```bash
git clone https://github.com/caesarbrandpower/waybetter-desktop.git
cd waybetter-desktop
make build
open WaybetterDesktop.app
```

After first launch, grant microphone permission when prompted.

---

## How it works

1. Press the hotkey (default Cmd+Shift+Space)
2. A small recording window appears - click the button or press Space to start recording
3. Click again or press Return to stop
4. Your audio is transcribed and two files are saved:
   - `2026-04-20_14-30-00.m4a` - the audio recording
   - `2026-04-20_14-30-00_transcript.txt` - the transcript

---

## Choosing your storage folder

Open the menu bar icon, then Dashboard -> Preferences -> Storage Location.

Default: `~/Documents/Waybetter/`

Selecting a folder inside Google Drive, Dropbox, or iCloud Drive lets your OS automatically sync all recordings to the cloud. Waybetter Desktop does not handle cloud sync directly.

---

## Transcription providers

| Provider | Requires | Offline |
|----------|----------|---------|
| Local WhisperKit | Nothing | Yes |
| OpenAI Whisper | API key | No |
| Google Gemini | API key | No |
| Parakeet-MLX | Apple Silicon | Yes |

Configure in Dashboard -> Providers.

---

## Credits

Waybetter Desktop is built on [AudioWhisper](https://github.com/mazdak/AudioWhisper) by Mazdak Farrokhzad, licensed under the MIT License. We thank the AudioWhisper contributors for the solid foundation this project is built on.
