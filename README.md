# linux-install-helper

A small Python CLI (and PyInstaller-friendly exe) that prepares the files needed to boot a Linux installer from Windows 10 on an NTFS partition using grub4dos.

## What it does
- Downloads a Linux ISO to a working directory on NTFS
- Generates a `menu.lst` suitable for loop-booting the ISO with grub4dos
- Generates a `install-grub4dos.bat` script that wires grub4dos into BCD (run it from an elevated Command Prompt)

## Quick start (on Windows)
You can produce a real `.exe` in a few minutes with only Python installed:

1. Install Python 3.10+ on Windows and ensure `python` is on your `PATH`.
2. Clone this repository and open an **elevated** PowerShell or Command Prompt in the checkout.
3. Build the exe using the helper batch file:
   ```bat
   build_exe.bat
   ```
   The resulting file will be at `dist\\install_helper.exe`.
4. Stage a working directory and download the ISO in one shot:
   ```bat
   dist\\install_helper.exe full-setup --workdir C:\\linux-helper
   ```
5. Copy `grldr` and `grldr.mbr` from the grub4dos project into `C:\linux-helper`.
6. Review `C:\linux-helper\menu.lst` and adjust kernel parameters if your distro needs them.
7. Run `C:\linux-helper\install-grub4dos.bat` from an **elevated** Command Prompt to add the boot entry.
8. Reboot and pick **Linux via grub4dos** in the Windows boot menu to start the installer.

## Manual usage
You can also run individual steps:
```powershell
python app/install_helper.py init --workdir C:\\linux-helper
python app/install_helper.py download-iso --url <ISO_URL> --iso-name linux.iso --workdir C:\\linux-helper
python app/install_helper.py generate-menu --iso-name linux.iso --workdir C:\\linux-helper
python app/install_helper.py generate-bcd --workdir C:\\linux-helper
```

## Notes
- The generated BCD script assumes `grldr.mbr` lives on the system drive or the drive you pass as `%1` to the `.bat` file.
- You still need to supply grub4dos binaries yourself; the helper only writes configuration and boot wiring scripts.
- Default ISO URL points at Debian; override it to use another distribution.
