Use DFClient.pkg
Use Windows.pkg
Use dfBitmap.pkg
Use dfLine.pkg
Use seq_chnl.pkg

Use cRDCHeaderDbGroup.pkg
Use cRDCHeaderGroup.pkg
Use cRDCDbFormOrDbSuggestionForm.pkg
Use cRDCDbForm.pkg
Use cRDCRichEditor.pkg
Use cRDCButton.pkg
Use cRDCTextbox.pkg
Use cRDCDbFormShadowTxt.pkg
Use cRDCGroup.pkg
Use cRDCDbGroup.pkg
Use cRDCBitmapContainer.pkg
Use cRDCGroup.pkg
Use cRDCTextbox.pkg
Use cWindowsServiceFunctions.pkg
Use cDigitalSoftwareCertificate.pkg
Use vWin32fh.pkg

Use AccountName.dg
Use cWinServiceDataDictionary.dd

Activate_View Activate_oWindowsServicesTest for oWindowsServicesTest
Object oWindowsServicesTest is a dbView
    Set Size to 231 402
    Set Location to 3 5
    Set Border_Style to Border_Thick
    Set View_Mode to Viewmode_Zoom
    Set Maximize_Icon to True

    // Set this property to True to use the iTune skins background
    // texture on all objects.
    Property Boolean pbUseThemeTexture False

    Object oWinService_DD is a cWinServiceDataDictionary
        Set Ordering to 1
        Procedure OnPostFind Integer eMessage Boolean bFound
            Send PostRefrehFind  of oDescription_fm
        End_Procedure
    End_Object

    Set phoMainDD of ghoApplication to oWinService_DD
    Set Main_DD to oWinService_DD
    Set Server to oWinService_DD

    Set Verify_Save_msg to (RefFunc(No_Confirmation))
    Set Auto_Clear_DEO_State to False
    Set Verify_Data_Loss_msg to (RefFunc(No_Confirmation))
    Set Verify_Exit_msg to (RefFunc(No_Confirmation))
    Set pbAutoActivate to True

    // Just a little trick to make the skin background visible.
    Procedure Page Integer iPageObject
        Forward Send Page iPageObject
        If (pbUseThemeTexture(Self)) Begin
            Send ComEnableThemeDialogTexture of ghoSkinFramework (Window_Handle(Self)) 6
        End
        Set Auto_Fill_State of oWinService_DD to True
        Send Request_Find of oWinService_DD GE WinService.File_Number 1
    End_Procedure

    // Function that fills & returns a tNSSMWinService struct parameters with values
    // from the Main DDO buffer.
    // It only populates the tNSSMWinService.sPw parameter if the passed bDecryptPw = True.
    Function Fill_NSSMWinService Boolean bDecryptPw Returns tNSSMWinService
        String sPw
        Handle hoCryptographer hoDD
        tNSSMWinService NSSMWinService

        Get Main_DD             to hoDD
        Get Field_Current_Value of hoDD Field WinService.Program_Path to NSSMWinService.sProgramPath
        Get Field_Current_Value of hoDD Field WinService.Program_Name to NSSMWinService.sProgramName
        Get Field_Current_Value of hoDD Field WinService.Service_Name to NSSMWinService.sServiceName
        Get Field_Current_Value of hoDD Field WinService.Description  to NSSMWinService.sDescription
        Get Field_Current_Value of hoDD Field WinService.AccountName  to NSSMWinService.sAccountName

        Get Field_Current_Value of hoDD Field WinService.CmdLineParam to NSSMWinService.sCmdLineParam

        If (bDecryptPw = True) Begin
            Get Create (RefClass(cCryptographer)) to hoCryptographer
            Set psProvider of hoCryptographer to MS_ENHANCED_PROV
            Get Field_Current_Value of hoDD Field WinService.Pw        to sPw
            Get Decrypt of hoCryptographer CS_WinServiceHashString sPw to sPw
            Move sPw                                                   to NSSMWinService.sPw
            Send Destroy of hoCryptographer
        End

        Function_Return NSSMWinService
    End_Function

    Object oDFServiceProgram is a cRDCHeaderDbGroup
        Set Size to 124 379
        Set Location to 9 12
        Set Label to "Software as a Service (SaaS)"
        Set Label to CS_WSUSaas
        Set psNote to "Specify the program that should run as a service"
        Set psNote to CS_WSUSaasNote
        Set psImage to "WindowsServices.ico"

        Object oProgramName_fm is a cRDCDbFormOrDbSuggestionForm
            Entry_Item WinService.Program_Name
            Set Size to 13 245
            Set Location to 28 63
            Set Label to "Program Name"
            Set Label to CS_WSUProgramName
            Set Status_Help to CS_WSUProgramNameStatusHelp
            Set psToolTip   to CS_WSUProgramNameStatusHelp
            Set peAnchors to anTopLeftRight

            Procedure OnChange
                Boolean bExists
                String sFileName sPath

                Get Field_Current_Value of (Main_DD(Self)) Field WinService.Program_Name to sFileName
                Get Field_Current_Value of (Main_DD(Self)) Field WinService.Program_Path to sPath
                Get vFolderFormat sPath to sPath
                Move (ToANSI(sPath + sFileName)) to sFileName
                Get vFilePathExists sFileName to bExists

                // If the file doesn't exist change the form text to red, to denote it is missing.
                If (bExists = False) Begin
                    Set TextColor to clRed
                End
                Else Begin
                    Set TextColor to clBlack
                End
            End_Procedure

        End_Object

        Object oBrowse_btn is a cRDCButton
            Set Size to 13 54
            Set Location to 28 315
            Set Label to C_$Browse
            Set Status_Help to CS_WSUSelectProgram
            Set psImage to "FolderOpen.ico"
            Set peAnchors to anTopRight

            Procedure OnClick
                String sProgramName sPath sValue sExt sServiceName

                Get Field_Current_Value of (Main_DD(Self)) Field WinService.Program_Path to sPath
                Get vSelect_File "Programs (*.exe)|*.exe|All Files (*.*)|*.*" "Please select a program" sPath to sValue

                If (sValue <> "") Begin
                    Get ParseFileName      sValue to sProgramName
                    Get ParseFolderName    sValue to sPath
                    Get ParseFileExtension sValue to sExt
                    Move (Replace(("." + sExt), sProgramName, "")) to sServiceName
                    // Note: The path must be set first, else the coloring of the
                    //       oProgramname_fm will not work.
                    Set Changed_Value of oProgramPath_fm  item 0 to sPath
                    Set Changed_Value of oProgramname_fm  item 0 to sProgramName
                    Set Changed_Value of oCmdLineParam_fm item 0 to "/Start"
                    Set Changed_Value of oServiceName_fm  item 0 to sServiceName
                    Set Changed_Value of oDescription_fm  item 0 to (sServiceName * "description")
                End
            End_Procedure

        End_Object

        Object oProgramPath_fm is a cRDCDbForm
            Entry_Item WinService.Program_Path
            Set Size to 13 245
            Set Location to 43 63
            Set Label to "Program Path"
            Set Label to CS_WSUProgramPath
            Set Status_Help to CS_WSUProgramPathStatusHelp
            Set Enabled_State to False
            Set peAnchors to anTopLeftRight

            Procedure OnChange
                Boolean bExists
                String sValue

                Get Value to sValue
                Get vFolderExists sValue to bExists

                // If the file doesn't exist change the form text to red, to denote it is missing.
                If (bExists = False) Begin
                    Set TextColor to clRed
                End
                Else Begin
                    Set TextColor to clBlack
                End
            End_Procedure

        End_Object

        Object oEditPath_btn is a cRDCButton
            Set Size to 13 54
            Set Location to 43 315
            Set Label to "Enable"
            Set Label to CS_WSUEnable
            Set psToolTip to CS_WSUEnableStatusHelp
            Set peAnchors to anTopRight
            Set Skip_State to True

            Procedure OnClick
                Boolean bEnabled
                Get Enabled_State of oProgramPath_fm to bEnabled
                Set Enabled_State of oProgramPath_fm to (not(bEnabled))
                Set Label to (If(bEnabled, CS_WSUEnable, CS_WSUDisable))
            End_Procedure
        End_Object

        Object oCmdLineParam_fm is a cRDCDbFormShadowTxt
            Entry_Item WinService.CmdLineParam
            Set Location to 58 63
            Set Size to 13 245
            Set Label to "Start Parameter"
            Set Label to CS_WSUStartParameter
            Set Status_Help to (CS_WSUStartParameterHelp * CS_DFTestProgram * "- cApplicationDFService.pkg")
            Set peAnchors to anTopLeftRight
            Set psShadowText to CS_WSUSCmdLineShadowText
        End_Object

        Object oServiceName_fm is a cRDCDbFormShadowTxt
            Entry_Item WinService.Service_Name
            Set Size to 13 245
            Set Location to 73 63
            Set Label to "Service Name"
            Set Label to CS_WSUServiceName
            Set psShadowText to CS_WSUServiceNameShadow
            Set Status_Help to CS_WSUServiceNameHelp
            Set peAnchors to anTopLeftRight
        End_Object

        Object oViewLog_btn is a cRDCButton
            Set Size to 13 54
            Set Location to 73 315
            Set Label to "View Log"
            Set Label to CS_WSUViewLog
            Set Status_Help to (CS_WSUViewLogHelp1 * CS_DFTestServiceName * CS_WSUViewLogHelp2)
            Set pbAutoEnable to True
            Set peAnchors to anTopRight
            Set psImage to "ViewLogBook.ico"

            Procedure OnClick
                String sPath sServiceName sFileName
                Boolean bExists

                Get Field_Current_Value of (Main_DD(Self)) Field WinService.Program_Path to sPath
                Get Field_Current_Value of (Main_DD(Self)) Field WinService.Service_Name to sServiceName
                Get ParseFolderName sPath to sPath

                Get vFolderFormat sPath to sPath
                Move (sPath + sServiceName + CS_ServiceLogFile) to sFileName
                Get vFilePathExists sFileName to bExists
                If (bExists = True) Begin
                    Send ActivateLogFileDialog of (Client_Id(ghoCommandBars)) sFileName
                End
                Else Begin
                    Send Info_Box (CS_WSUCantFindLogFile + String(sFileName))
                End
            End_Procedure

            Function IsEnabled Returns Boolean
                String sPath sServiceName sFileName
                Boolean bExists

                // Use the main DDO program path and convert to Data path:
                Get Field_Current_Value of (Main_DD(Self)) Field WinService.Program_Path to sPath
                Get Field_Current_Value of (Main_DD(Self)) Field WinService.Service_Name to sServiceName
                Get vFolderFormat sPath to sPath
                Move (sPath + sServiceName + CS_ServiceLogFile) to sFileName
                Get vFilePathExists sFileName to bExists
                Function_Return (bExists = True)
            End_Function

        End_Object

        Object oDescription_fm is a cRDCDbFormShadowTxt
            Entry_Item WinService.Description
            Set Size to 13 245
            Set Location to 88 63
            Set Label to "Description"
            Set Label to CS_WSUDescription2
            Set psShadowText to CS_WSUDesription2Shadow
            Set Status_Help to CS_WSUDescriptionHelp
            Set peAnchors to anTopLeftRight

            Procedure PostRefrehFind
                String sDescription sServiceDescription
                Integer iRetval
                tNSSMWinService NSSMWinService NSSMWinService2
                tNSSMReply NSSMReply

                Get Fill_NSSMWinService False to NSSMWinService
                If (NSSMWinService.sServiceName = "") Begin
                    Procedure_Return
                End
                Get IsServiceRunning of ghoWindowsServiceFunctions NSSMWinService to NSSMReply
                If (NSSMReply.iRetval = 1) Begin
                    Send Stop_Box NSSMReply.sRetval
                    Procedure_Return
                End
                Get QueryServiceFullStruct of ghoWindowsServiceFunctions NSSMWinService to NSSMWinService2
                If (NSSMReply.iRetval = 0) Begin
                    Move NSSMWinService2.sDescription to sServiceDescription
                    Get Field_Current_Value of oWinService_DD Field WinService.Description to sDescription
                    If (sDescription <> "" and sServiceDescription <> "" and Lowercase(Trim(sDescription)) <> Lowercase(Trim(sServiceDescription))) Begin
                        Get YesNo_Box (CS_WSUDescriptionMissMatch1 * sDescription + CS_WSUDescriptionMissMatch2 * sServiceDescription + CS_WSUDescriptionMissMatch3) to iRetval
                        If (iRetval = MBR_Yes) Begin
                            Reread WinService
                                Move sServiceDescription to WinService.Description
                                SaveRecord WinService
                            Unlock
                            Send Request_Assign of oWinService_DD
                        End
                    End
                End
            End_Procedure

        End_Object

        // An experiment using a descriptive background text in the form itself.
        // Much like what is getting more and more common on the WEB.
        Object oAccountName_fm is a cRDCDbFormShadowTxt
            Entry_Item WinService.AccountName
            Set Location to 103 63
            Set Size to 13 124
            Set Label to "Account Name"
            Set Label to CS_WSUAccountName2
            Set Status_Help to CS_WSUAccountNameHelp
            Set psShadowText to CS_WSUAccountNameShadow
            Set Prompt_Object to oAccountNames_dg
            Set peAnchors to anTopLeftRight

            Procedure Prompt_Callback Integer hPrompt
                Set peUpdateMode   of hPrompt to umPromptValue
                Set piUpdateColumn of hPrompt to 1
            End_Procedure

        End_Object

        Object oPw_fm is a cRDCDbForm
            Entry_Item WinService.Pw
            Set Location to 103 232
            Set Size to 13 76
            Set Label to "Password"
            Set Label to CS_WSUPassword
            Set Password_State to True
            Set peAnchors to anTopRight
            Set Status_Help to CS_WSUPasswordHelp
        End_Object

    End_Object

    Object oServicesFunctions_grp is a cRDCHeaderGroup
        Set Size to 78 379
        Set Location to 144 12
        Set Label to "Control Service"
        Set Label to CS_WSUServiceFunctionGroup
        Set psNote to CS_WSUServiceFunctionGroupN
        Set psImage to "ControlWindowsService.ico"

        Object oCreateService_btn is a cRDCButton
            Set Size to 14 54
            Set Location to 41 10
            Set Label to "Create"
            Set Label to CS_WSUCreateService
            Set Status_Help to CS_WSUCreateServiceHelp
            Set MultiLineState to True
            Set pbAutoEnable to True
            Set psImage to "ServiceCreate.ico"
            Set FontWeight to fw_Bold

            Procedure OnClick
                Integer iRetval
                String sProgramName
                tNSSMWinService NSSMWinService

                Get Field_Current_Value of (Main_DD(Self)) Field WinService.Program_Name to sProgramName
                Get IsProgramRunning of ghoWindowsServiceFunctions sProgramName to iRetval
                If (iRetval = CI_TasklistRunAsService) Begin
                    Send Stop_Box "No that won't work! The program is already installed and started under another Service Name. Check with the Windows Services Manager and see if you can find the other service name the program is run as."
                    Procedure_Return
                End

                Send Request_Save
                Get Fill_NSSMWinService True to NSSMWinService

                Send CreateService of ghoWindowsServiceFunctions NSSMWinService
            End_Procedure

             Function IsEnabled Returns Boolean
                tNSSMWinService NSSMWinService
                tNSSMReply NSSMReply
                Boolean bHasRecord

                Get Fill_NSSMWinService False to NSSMWinService

                Get IsServiceRunning of ghoWindowsServiceFunctions NSSMWinService to NSSMReply
                Get HasRecord of oWinService_DD to bHasRecord
                Function_Return (bHasRecord = True and NSSMReply.iRetval <> 0)
             End_Function

        End_Object

        Object oStartService_btn is a cRDCButton
            Set Size to 14 50
            Set Location to 24 72
            Set Label to "Start"
            Set Label to CS_WSUStartServcice
            Set Status_Help to CS_WSUStartServciceHelp
            Set pbAutoEnable to True
            Set psImage to "ServiceStart.ico"

            Procedure OnClick
                Integer iRetval
                String sProgramName
                tNSSMWinService NSSMWinService
                tNSSMReply NSSMReply

                Get Field_Current_Value of (Main_DD(Self)) Field WinService.Program_Name to sProgramName
                Get IsProgramRunning of ghoWindowsServiceFunctions sProgramName to iRetval
                If (iRetval = CI_TasklistRunAsService) Begin
                    Send Stop_Box CS_WSUStartServiceError
                    Procedure_Return
                End

                Get Fill_NSSMWinService False to NSSMWinService
                Send StartService of ghoWindowsServiceFunctions NSSMWinService
            End_Procedure

             Function IsEnabled Returns Boolean
                tNSSMWinService NSSMWinService
                tNSSMReply NSSMReply
                Boolean bIsInstalledAsService bHasRecord

                Get Fill_NSSMWinService False to NSSMWinService
                Get IsServiceRunning of ghoWindowsServiceFunctions NSSMWinService to NSSMReply
                Get IsProgramInstalledAsService of ghoWindowsServiceFunctions NSSMWinService.sProgramPath NSSMWinService.sProgramName to bIsInstalledAsService
                Get HasRecord of oWinService_DD to bHasRecord

                Function_Return (bHasRecord = True and bIsInstalledAsService = True and NSSMReply.sRetval <> CS_ServiceRunning)
             End_Function

        End_Object

        Object oStopService_btn is a cRDCButton
            Set Size to 14 50
            Set Location to 41 72
            Set Label to "Stop"
            Set Label to CS_WSUStopService
            Set Status_Help to CS_WSUStopServiceHelp
            Set pbAutoEnable to True
            Set psImage to "ServiceStop.ico"

            Procedure OnClick
                tNSSMWinService NSSMWinService
                tNSSMReply NSSMReply

                Get Fill_NSSMWinService False to NSSMWinService
                Send StopService of ghoWindowsServiceFunctions NSSMWinService
            End_Procedure

             Function IsEnabled Returns Boolean
                tNSSMWinService NSSMWinService
                tNSSMReply NSSMReply
                Boolean bIsInstalledAsService bHasRecord


                Get Fill_NSSMWinService False to NSSMWinService
                Get IsServiceRunning of ghoWindowsServiceFunctions NSSMWinService to NSSMReply
                Get IsProgramInstalledAsService of ghoWindowsServiceFunctions NSSMWinService.sProgramPath NSSMWinService.sProgramName to bIsInstalledAsService
                Get HasRecord of oWinService_DD to bHasRecord

                Function_Return (bHasRecord = True and NSSMReply.sRetval <> CS_ServiceStopped and bIsInstalledAsService = True)
             End_Function

        End_Object

        Object oReStartService_btn is a cRDCButton
            Set Size to 14 50
            Set Location to 57 72
            Set Label to "Restart"
            Set Label to CS_WSURestartService
            Set Status_Help to CS_WSURestartServiceHelp
            Set pbAutoEnable to True
            Set psImage to "ServiceRestart.ico"

            Procedure OnClick
                tNSSMWinService NSSMWinService
                tNSSMReply NSSMReply

                Get Fill_NSSMWinService False to NSSMWinService
                Send RestartService of ghoWindowsServiceFunctions NSSMWinService
            End_Procedure

             Function IsEnabled Returns Boolean
                tNSSMWinService NSSMWinService
                tNSSMReply NSSMReply
                Boolean bHasRecord

                Get Fill_NSSMWinService False to NSSMWinService
                Get IsServiceRunning of ghoWindowsServiceFunctions NSSMWinService to NSSMReply
                Get HasRecord of oWinService_DD to bHasRecord

                Function_Return (bHasRecord = True and NSSMReply.iRetval = 0)
             End_Function

        End_Object

        Object oRemoveService_btn is a cRDCButton
            Set Size to 14 54
            Set Location to 41 129
            Set Label to "Remove"
            Set Label to CS_WSURemoveService
            Set Status_Help to CS_WSURemoveServiceHelp
            Set pbAutoEnable to True
            Set MultiLineState to True
            Set psImage to "ServiceRemove.ico"

            Procedure OnClick
                tNSSMWinService NSSMWinService

                Get Fill_NSSMWinService False to NSSMWinService
                Send RemoveService of ghoWindowsServiceFunctions NSSMWinService
            End_Procedure

             Function IsEnabled Returns Boolean
                tNSSMWinService NSSMWinService
                tNSSMReply NSSMReply
                Boolean bHasRecord

                Get Fill_NSSMWinService False to NSSMWinService
                Get IsServiceRunning of ghoWindowsServiceFunctions NSSMWinService to NSSMReply
                Get HasRecord of oWinService_DD to bHasRecord

                Function_Return (bHasRecord = True and (NSSMReply.sRetval = CS_ServiceRunning or NSSMReply.sRetval = CS_ServiceStopped))
             End_Function

        End_Object

        Object oInfoService_btn is a cRDCButton
            Set Size to 14 54
            Set Location to 41 191
            Set Label to "Info"
            Set Label to CS_WSUServiceInfo
            Set Status_Help to CS_WSUServiceInfoHelp
            Set MultiLineState to True
            Set pbAutoEnable to True
            Set psImage to "ServiceInfo.ico"

            Procedure OnClick
                tNSSMWinService NSSMWinService

                Get Fill_NSSMWinService False to NSSMWinService
                Send QueryService of ghoWindowsServiceFunctions NSSMWinService
            End_Procedure

             Function IsEnabled Returns Boolean
                tNSSMWinService NSSMWinService
                tNSSMReply NSSMReply
                Boolean bIsInstalledAsService bHasRecord

                Get Fill_NSSMWinService False to NSSMWinService
                Get IsProgramInstalledAsService of ghoWindowsServiceFunctions NSSMWinService.sProgramPath NSSMWinService.sProgramName to bIsInstalledAsService
                Get IsServiceRunning of ghoWindowsServiceFunctions NSSMWinService to NSSMReply
                Get HasRecord of oWinService_DD to bHasRecord

                Function_Return (bHasRecord = True and bIsInstalledAsService = True and NSSMReply.iRetval = 0)
             End_Function

        End_Object

        Object oEditService_btn is a cRDCButton
            Set Location to 41 250
            Set Label to "Advanced"
            Set Label to CS_WSUAdvanced
            Set Status_Help to CS_WSUAdvancedHelp
            Set pbAutoEnable to True

            Procedure OnClick
                tNSSMWinService NSSMWinService

                Get Fill_NSSMWinService False to NSSMWinService
                Send EditService of ghoWindowsServiceFunctions NSSMWinService
            End_Procedure

             Function IsEnabled Returns Boolean
                tNSSMWinService NSSMWinService
                tNSSMReply NSSMReply

                Get Fill_NSSMWinService False to NSSMWinService
                Get IsServiceRunning of ghoWindowsServiceFunctions NSSMWinService to NSSMReply
                Function_Return (NSSMReply.iRetval = 0)
             End_Function

        End_Object

        Object oLineControl1 is a LineControl
            Set Size to 70 4
            Set Location to 4 307
            Set Horizontal_State to False
        End_Object

        Object oEventLog_btn is a cRDCButton
            Set Size to 30 54
            Set Location to 6 315
            Set Label to "Windows Event Viewer"
            Set Label to CS_WSUEventLog
            Set Status_Help to CS_WSUEventLogHelp
            Set pbAutoEnable to False
            Set MultiLineState to True
            Set psImage to "StartProgram.ico"
            Set piImageSize to 24

            Procedure OnClick
                Send StartWindowsEventViewer of ghoWindowsServiceFunctions
            End_Procedure

        End_Object

        Object oWindowsServiceManager_btn is a cRDCButton
            Set Size to 30 54
            Set Location to 41 316
            Set Label to "Windows Services Manager"
            Set Label to CS_WSUServiceManager
            Set Status_Help to CS_WSUServiceManagerHelp
            Set MultiLineState to True
            Set psImage to "StartProgram.ico"
            Set piImageSize to 24

            Procedure OnClick
                tNSSMWinService NSSMWinService
                tNSSMReply NSSMReply

                Get Fill_NSSMWinService False to NSSMWinService
                Get IsServiceRunning of ghoWindowsServiceFunctions NSSMWinService to NSSMReply
                If (NSSMReply.sRetval = CS_ServiceRunning or NSSMReply.sRetval = CS_ServiceStopped) Begin
                    Send Info_Box (CS_WSUServiceManagerInfo + NSSMWinService.sServiceName)
                End

                Send StartWindowsServiceManager of ghoWindowsServiceFunctions
            End_Procedure

        End_Object

    End_Object

    Procedure Close_Panel
    End_Procedure

    Procedure Activating
        Integer iRetval

        Forward Get msg_activating to iRetval

        Set Maximize_Icon to True
        Set Minimize_Icon to False
        Set Border_Style to Border_Thick
        Set View_Mode to Viewmode_Zoom

        // Note: The following line is essential for the resizing logic
        // to function properly when starting the program.
        Set Border_Style of (Client_Id(phoMainPanel(ghoApplication))) to Border_ClientEdge
    End_Procedure

    On_Key Key_Ctrl+Key_S Send Request_Save
    On_Key Key_Ctrl+Key_O Send KeyAction of oBrowse_btn
End_Object
