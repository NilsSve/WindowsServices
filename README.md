# The Windows Services Manager Utility

The **WindowsServiceUtil** program assists you in setting up any application to run as a Windows Service.

Internally, the program utilizes the **NSSM** command line utility to create and manage Windows Services. Unlike Microsoft's own tool, **srvany**, and other service helpers, NSSM effectively handles failures when running a service. It actively monitors the service and will restart it if it crashes, which is crucial for maintaining service availability.

Additionally, NSSM logs its progress in the Windows Event Log, allowing you to diagnose any issues that may arise with the application.

The workspace also includes a template, **DFServiceProgram1**, to help you build your own DataFlex program that can function as a Windows Service. This is beneficial for both Windows Desktop applications and WebApp applications.

![This is how the WindowsServices.src program looks:](Bitmaps/WindowsServices.png)

## Setup after cloning

After cloning this repository, run **`setup.bat`** once from the repository root. It:

- downloads / updates the library submodules under `Libraries\` (DFAbout, DigitalCert, RDCToolsLib, vwin32fh) to the versions this workspace expects;
- configures this clone so a normal `git pull` keeps those libraries in sync automatically from then on;
- runs `skip-local-data.cmd` so your local `Data\` database changes stay on your machine and are never tracked or pushed.

Re-run `setup.bat` any time the `Libraries\` folders look empty or out of date, or when a new submodule is added.

The database tables ship directly in `Data\`, so the workspace runs out of the box after setup (`WinServiceData.zip` is just a spare copy of the same baseline).
