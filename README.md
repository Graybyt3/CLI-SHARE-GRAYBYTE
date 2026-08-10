# 🔁 CLI-SHARE-GRAYBYTE

A secure command-line file sharing utility that compresses, encrypts, uploads, and shares files or directories through the rstream File Sharing service.

Files are encrypted locally before upload using AES-256-CTR. The decryption key is embedded in the URL fragment and is never transmitted to the server during normal download requests, providing end-to-end encrypted file sharing.
<br><br>
<p align="center">
  <img src="https://raw.githubusercontent.com/Graybyt3/CLI-SHARE-GRAYBYTE/refs/heads/main/file-sharing.png" alt="header banner" />
</p>
<br><br>
---

# Features

- AES-256-CTR client-side encryption
- SHA-256 integrity verification
- Automatic tar.gz compression
- End-to-end encrypted sharing
- Browser-based downloads
- One-command download and extraction
- Clipboard integration
- Upload history tracking
- Progress bars via `pv`
- Supports files and directories
- Automatic cleanup of temporary files
- Up to 1 GB encrypted uploads

---

# How It Works

1. Select a file or directory.
2. The data is compressed into a tar.gz archive.
3. A random encryption key and IV are generated.
4. The archive is encrypted locally using AES-256-CTR.
5. The encrypted archive is uploaded.
6. A download URL is generated.
7. The encryption key is stored in the URL fragment (`#KEY`).
8. Recipients can download and decrypt the file.

Because the encryption key remains client-side, the server does not need access to the plaintext contents of the file.

---

# Requirements

## Required

- POSIX Shell (`sh`)
- `curl`
- `openssl`
- `tar`

## Recommended

- `pv`
- `xclip`
- `xsel`
- `wl-copy`
- `pbcopy`

---

# Installation

Clone the repository:

```bash
git clone https://github.com/Graybyt3/CLI-SHARE-GRAYBYTE.git
cd CLI-SHARE-GRAYBYTE.
```

Make the script executable:

```bash
chmod +x cli-share-graybyte.sh
```

Run:

```bash
./cli-share-graybyte.sh
```

---

# Usage

Interactive mode:

```bash
./cli-share-graybyte.sh
```

Upload a file:

```bash
./cli-share-graybyte.sh /path/to/file
```

Upload a directory:

```bash
./cli-share-graybyte.sh /path/to/directory
```

---

# Example Output

```text
📦 COMPRESSING PLEASE WAIT.............
🔐 ENCRYPTING PLEASE WAIT.............
☁️ UPLOADING PLEASE WAIT.............

✅ UPLOAD COMPLETE

📋 AUTO DOWNLOAD COMMAND COPIED TO CLIPBOARD

🔗 BROWSER BASED DOWNLOAD URL :
https://example.com/tools/file-sharing/abc123#KEY

🚀 AUTOMATED DOWNLOAD + EXTRACTION :

ID="abc123" KEY="KEY" /usr/bin/env sh -c "$(curl -fsSL 'https://example.com/cli-share-graybyte.sh')" && tar -xzf archive.tar.gz

📥 AUTOMATED DOWNLOAD + EXTRACTION + DELETE ARCHIVE :

ID="abc123" KEY="KEY" /usr/bin/env sh -c "$(curl -fsSL 'https://example.com/cli-share-graybyte.sh')" && tar -xzf archive.tar.gz && rm -f archive.tar.gz
```

---

# Automated Download

Download and extract:

```bash
ID="FILE_ID" KEY="KEY" /usr/bin/env sh -c "$(curl -fsSL 'SCRIPT_URL')" && tar -xzf archive.tar.gz
```

Download, extract, and remove the archive:

```bash
ID="FILE_ID" KEY="KEY" /usr/bin/env sh -c "$(curl -fsSL 'SCRIPT_URL')" && tar -xzf archive.tar.gz && rm -f archive.tar.gz
```

---

# Encryption Details

| Setting | Value |
| Cipher | AES-256-CTR 
| Integrity | SHA-256 
| Compression | tar.gz 
| Key Length | 256-bit 
| IV Length | 128-bit 

---

# Upload Limits

| Item | Limit |
| Compressed Archive | ~1 GB 
| Encrypted Upload | 1 GB 

Files exceeding the limit are rejected before upload.

---

# History

Upload history is stored in:

```text
~/.file-sharing-history
```

Each entry contains:

- Original path
- File ID
- Download URL
- Timestamp

---

# Why This Exists

This script provides a fast and convenient way to securely share files directly from the command line without requiring recipients to install additional software.

It combines:

- Compression
- Encryption
- Upload
- Sharing
- Download automation

into a single workflow.

The goal is to make secure file sharing as simple as:

```bash
./cli-share-graybyte.sh myfile.iso
```

while still preserving privacy and strong encryption.

---

# Credits

## Original File Sharing Service

This script is built around the File Sharing service provided by rstream.

rstream is a networking and secure connectivity platform created by software engineer **uartnet**, focused on secure tunnels, remote systems, infrastructure tooling, and private connectivity.

Website:

https://rstream.io

File Sharing Service:

https://rstream.io/tools/file-sharing

The underlying file-sharing service, backend infrastructure, upload API, browser decryption workflow, and service architecture belong to the rstream project and its creator.

Special thanks to:

- uartnet
- The rstream project
- OpenSSL
- cURL
- pv (Pipe Viewer)

---
