// WinService.sl
// Windows Service Lookup List

Use Windows.pkg
Use cRDCDbModalPanel.pkg
Use cDbCJGridPromptList.pkg
Use cRDCDbCJGridColumn.pkg
Use cRDCButton.pkg
Use WinServiceLanguageConstants.inc
Use cWinServiceDataDictionary.dd

Cd_Popup_Object WinService_sl is a cRDCDbModalPanel
    Set Location to 5 5
    Set Size to 134 446
    Set Label to "Windows Service Lookup List"
    Set Label to CS_WSUWinServiceLookup
    Set Icon to "WindowsServices.ico"

    Object oWinService_DD is a cWinServiceDataDictionary
    End_Object

    Set Main_DD To oWinService_DD
    Set Server  To oWinService_DD

    Object oSelList is a cDbCJGridPromptList
        Set Size to 105 436
        Set Location to 5 5
        Set peAnchors to anAll
        Set psLayoutSection to "WinService_sl_oSelList"
        Set Ordering to 1
        Set pbAutoServer to True
        Set pbGrayIfDisable to False
        Set pbShadeSortColumn to False
        Set pbShowRowFocus to True
        Set piHighlightBackColor to clAqua

        Object oWinService_Program_Name is a cRDCDbCJGridColumn
            Entry_Item WinService.Program_Name
            Set piWidth to 162
            Set psCaption to "Program Name"
            Set psCaption to CS_WSUProgramName
        End_Object

        Object oWinService_Program_Path is a cRDCDbCJGridColumn
            Entry_Item WinService.Program_Path
            Set piWidth to 506
            Set psCaption to "Program Path"
            Set psCaption to CS_WSUProgramPath
        End_Object

        Object oWinService_Service_Name is a cRDCDbCJGridColumn
            Entry_Item WinService.Service_Name
            Set piWidth to 204
            Set psCaption to "Service Name"
            Set psCaption to CS_WSUServiceName
        End_Object

    End_Object

    Object oOk_bn is a cRDCButton
        Set Label to C_$OK
        Set Location to 115 283
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send OK of oSelList
        End_Procedure

    End_Object

    Object oCancel_bn is a cRDCButton
        Set Label to C_$Cancel
        Set Location to 115 337
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send Cancel of oSelList
        End_Procedure

    End_Object

    Object oSearch_bn is a cRDCButton
        Set Label to C_$Search
        Set Location to 115 391
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send Search of oSelList
        End_Procedure

    End_Object

    On_Key Key_Alt+Key_O Send KeyAction of oOk_bn
    On_Key Key_Alt+Key_C Send KeyAction of oCancel_bn
    On_Key Key_Alt+Key_S Send KeyAction of oSearch_bn

Cd_End_Object
