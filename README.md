# The Windows Services Manager Utility

The **WindowsServiceUtil** program helps you set up any application to run as a Windows Service.

Internally, the program uses the **NSSM** command line utility to create and edit Windows Services. Compared to Microsoft's own tool **srvany** and other service helpers, NSSM handles failures when running a service. NSSM monitors the running service and will restart it if it dies, which is very important.

NSSM also logs its progress in the Windows Event Log, so you can get an idea of why an application isn't behaving as it should.

The workspace also includes a template **DFServiceProgram1** for building your own DataFlex program to run as a Windows Service, to help Windows Desktop applications as well as WebApp applications.

![This is how the WindowsServices.src program looks like:](Bitmaps/WindowsServices.png)
