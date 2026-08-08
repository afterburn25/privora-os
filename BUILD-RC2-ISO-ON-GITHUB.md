# Build the Privora 4.0 RC2 installer ISO without a Debian PC

1. Create a private GitHub repository.
2. Extract this archive into the repository root.
3. Commit and push all files.
4. On GitHub, open **Actions**.
5. Choose **Build Privora 4.0 RC2 Installer ISO**.
6. Click **Run workflow**.
7. Wait for the job to finish successfully.
8. Download the artifact named **Privora-4.0-RC2-Installer-Plasma-Standard-amd64**.
9. Extract it. The `.iso` is the image to write to your USB flash drive.

The job builds the installer-first ISO, includes the offline Privora desktop/profile repository,
performs BIOS and UEFI smoke boots in QEMU, runs the disposable installer-core certification,
and publishes the ISO only if those automated gates succeed.

## What the USB does

The default boot path is the Privora installer. The normal Live, persistence, safe graphics,
accessibility, and recovery entries remain available from the boot menu.
