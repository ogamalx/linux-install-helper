# linux-install-helper

A small Python CLI (and PyInstaller-friendly exe) that prepares the files needed to boot a Linux installer from Windows 10 on an NTFS partition using grub4dos.

## What it does
- Downloads a Linux ISO to a working directory on NTFS
- Generates a `menu.lst` suitable for loop-booting the ISO with grub4dos
- Generates a `install-grub4dos.bat` script that wires grub4dos into BCD (run it from an elevated Command Prompt)

## Quick start (on Windows)
1. Install Python 3.10+ and `pip install pyinstaller` if you want an `.exe`.
2. Clone this repository and open an **elevated** PowerShell in the checkout.
3. Run the helper in full-auto mode:
   ```powershell
   pyinstaller --onefile app/install_helper.py
   .\dist\install_helper.exe full-setup --workdir C:\\linux-helper
   ```
4. Copy `grldr` and `grldr.mbr` from the grub4dos project into `C:\linux-helper`.
5. Review `C:\linux-helper\menu.lst` and adjust kernel parameters if your distro needs them.
6. Run `C:\linux-helper\install-grub4dos.bat` from an **elevated** Command Prompt to add the boot entry.
7. Reboot and pick **Linux via grub4dos** in the Windows boot menu to start the installer.

## Manual usage
You can also run individual steps:
```powershell
python app/install_helper.py init --workdir C:\\linux-helper
python app/install_helper.py download-iso --url <ISO_URL> --iso-name linux.iso --workdir C:\\linux-helper
python app/install_helper.py generate-menu --iso-name linux.iso --workdir C:\\linux-helper
python app/install_helper.py generate-bcd --workdir C:\\linux-helper
python app/install_helper.py verify-iso --iso-name linux.iso --workdir C:\\linux-helper --expected-sha256 <HASH>
```

## Notes
- The generated BCD script assumes `grldr.mbr` lives on the system drive or the drive you pass as `%1` to the `.bat` file.
- You still need to supply grub4dos binaries yourself; the helper only writes configuration and boot wiring scripts.
- Default ISO URL points at Debian; override it to use another distribution. Provide `--expected-sha256` to ensure you are booting an official image instead of an unofficial or repackaged recovery (e.g., stray TWRP builds). Downloads whose name or URL looks like TWRP are blocked unless an expected hash is provided to avoid staging unsigned images, existing TWRP-named files must be replaced with a hashed download via `--force`, and `verify-iso` refuses to process a TWRP-named image unless you supply the vendor hash.
