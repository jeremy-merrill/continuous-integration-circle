unit JSONUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.JSON.Serializers, System.JSON,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfrmJSONConverter = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmJSONConverter: TfrmJSONConverter;

implementation

{$R *.dfm}

uses Unit4;

procedure TfrmJSONConverter.FormCreate(Sender: TObject);
const
  JSONData = '''
  {
    "infoPaneControls": {
        "colorEnabled": true,
        "defaultColor": "clBtnFace",
        "imageIconEnabled": true,
        "panelTextAlignment": "alLeft",
        "processMouseClickWhenFloating": true,
        "showRefreshButton": true
    },
    "infoPanels": [
        {
            "abbreviatedDisplayText": "MEDS",
            "action": "actShowDetail",
            "callDetailRPCs": false,
            "color": "clLime",
            "createNote": false,
            "detailText": "Active Outpatient Medications (excluding Supplies):\r\n \r\nNo Medications Found\r\n \r\n",
            "disabled": false,
            "displayText": "Active Medications",
            "id": "1;1;1;3",
            "imageIcon": "59718;clWindowText;61799;clWindow",
            "name": "ACTIVE MEDS",
            "popOut": "showModal",
            "requiredData": [
                {
                    "dataName": "dataUserInformation",
                    "errorMessage": "User not defined.",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "optional"
                        },
                        {
                            "dataName": "name",
                            "required": "optional"
                        }
                    ]
                },
                {
                    "dataName": "dataEncounterProvider",
                    "errorMessage": "Encounter provider information not defined",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "optional"
                        },
                        {
                            "dataName": "name",
                            "required": "optional"
                        }
                    ]
                }
            ],
            "section": {
                "id": "1;1;1",
                "name": "ALL TAB CLINICAL"
            }
        },
        {
            "abbreviatedDisplayText": "COVID",
            "action": "actShowDetail",
            "callDetailRPCs": false,
            "color": "clYellow",
            "createNote": false,
            "detailText": " \r\nCheck the lab results or details below - the most recent testing may require\r\ninterpretation based on the clinical setting.\r\n \r\nTest results were entered for 4\/30\/2010@16:00.\r\n \r\n \r\nLAB RESULTS:\r\nDate                Test Name                           Result\r\n04\/30\/2010@16:00    WBC                                 5.5            \r\n11\/16\/2009@11:00    WBC                                 6.5            \r\n05\/21\/2008@16:00    WBC                                 6.3            \r\n \r\nDate                Test Name                           Result\r\n No Ab lab results \r\n \r\n \r\nOUTSIDE COVID-19 LABS:\r\nDate       Health Factor Name                      Comment      Location\r\n No outside labs recorded                                                      \r\n \r\nOTHER CLINICAL INFORMATION:\r\nDate
                    Health Factor Name\r\n No specific HFs recorded                                 \r\n \r\n \r\nCOVID-19 Problem List:\r\n None                                                               \r\n \r\nDate          Immunization                                     Series\r\n No prior COVID -19 immunization                                            \r\n\r\n",
            "disabled": false,
            "displayText": "COVID-19               Testing Completed - see details",
            "id": "1;1;1;1",
            "imageIcon": "59423;clWindowText;60046;clRed",
            "name": "COVID",
            "popOut": "showEmbedded",
            "section": {
                "id": "1;1;1",
                "name": "ALL TAB CLINICAL"
            }
        },
        {
            "abbreviatedDisplayText": "AGE",
            "action": "actShowDetail",
            "callDetailRPCs": false,
            "color": "clWhite",
            "createNote": false,
            "detailText": "  Computed Finding: VA-Patient Age\r\n   03\/27\/2024@13:37:43 value - 28\r\n\r\n",
            "disabled": false,
            "displayText": "Patient is less than 40",
            "id": "1;1;1;2",
            "imageIcon": "59718;clWindowText;61799;clWindow",
            "name": "PATIENT AGE",
            "popOut": "showEmbedded",
            "section": {
                "id": "1;1;1",
                "name": "ALL TAB CLINICAL"
            }
        },
        {
            "abbreviatedDisplayText": "\"?\"",
            "action": "actShowDetail",
            "callDetailRPCs": false,
            "color": "clWhite",
            "createNote": false,
            "detailText": "Evaluate Line 1\r\nEvaluate Line 2\r\nEvaluate Line 3\r\nEvaluate Line 4\r\nEvaluate Line 5\r\nDetail Line 1\r\nDetail Line 2\r\nDetail Line 3\r\n",
            "disabled": false,
            "displayText": "Applicable Display Text",
            "id": "1;1;1;4",
            "imageIcon": "010101EE000000424DEE0000000000000076000000280000000F0000000F000000010004000000000078000000000000000000000010000000000000000000000000008000008000000080800080000000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFF00000FFFFF0FFF007777700FFF0FF0778FFF8770FF0F077FFFCFFF770F0F07FCFFFFFCF70F0078FFFFFFFFF870007FFFFFFFFFFF70007F00009FFFCF70007FFFFFF0FFFF700078FFFFFF0FF8700F07FCFFFFFFF70F0F077FFFCFFF770F0FF0778FCF8770FF0FFF007777700FFF0FFFFF00000FFFFF0",
            "name": "AJB TEST EVALUATE",
            "popOut": "showModal",
            "section": {
                "id": "1;1;1",
                "name": "ALL TAB CLINICAL"
            }
        },
        {
            "abbreviatedDisplayText": "YES",
            "action": "actShowDetail",
            "callDetailRPCs": false,
            "color": "clWhite",
            "createNote": false,
            "detailText": "  Computed Finding: VA-Patient Age\r\n   03\/27\/2024@13:37:43 value - 28\r\n\r\n",
            "disabled": false,
            "displayText": ">18",
            "id": "1;1;1;5",
            "imageIcon": "59718;clWindowText;61799;clWindow",
            "name": "AJB TEST TERM",
            "popOut": "showNonModal",
            "section": {
                "id": "1;1;1",
                "name": "ALL TAB CLINICAL"
            }
        },
        {
            "abbreviatedDisplayText": "SEXOR",
            "action": "actShowEditor",
            "callDetailRPCs": true,
            "color": "clYellow",
            "createNote": true,
            "disabled": true,
            "displayText": "Reminder evaluation failure, status: ERROR",
            "id": "1;1;2;1",
            "imageIcon": "57604;clWindowText;32;clRed",
            "name": "SEX ORIENTATION EDITOR",
            "popOut": "showEmbedded",
            "requiredData": [
                {
                    "dataName": "dataVisitInformation",
                    "errorMessage": "Visit Information missing",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "optional"
                        },
                        {
                            "dataName": "locId",
                            "required": "required"
                        },
                        {
                            "dataName": "locName",
                            "required": "required"
                        },
                        {
                            "dataName": "visitDateTime",
                            "required": "required"
                        },
                        {
                            "dataName": "visitType",
                            "required": "required"
                        },
                        {
                            "dataName": "visitString",
                            "required": "optional"
                        }
                    ]
                },
                {
                    "dataName": "dataEncounterProvider",
                    "errorMessage": "Encounter provider information not defined",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "optional"
                        },
                        {
                            "dataName": "name",
                            "required": "optional"
                        }
                    ]
                },
                {
                    "dataName": "dataUserInformation",
                    "errorMessage": "User not defined.",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "optional"
                        },
                        {
                            "dataName": "name",
                            "required": "optional"
                        }
                    ]
                }
            ],
            "section": {
                "id": "1;1;2",
                "name": "ALL TAB ADMIN"
            }
        },
        {
            "abbreviatedDisplayText": "PPN",
            "action": "actShowEditor",
            "callDetailRPCs": true,
            "color": "clYellow",
            "createNote": true,
            "disabled": false,
            "displayText": "Pronoun They\/Them\/Theirs, She\/Her\/Hers, He\/Him\/His, , click to update",
            "id": "1;1;2;2",
            "imageIcon": "57604;clWindowText;32;clRed",
            "name": "PATIENT PRONOUN EDITOR",
            "popOut": "showEmbedded",
            "requiredData": [
                {
                    "dataName": "dataVisitInformation",
                    "errorMessage": "Visit Information missing",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "optional"
                        },
                        {
                            "dataName": "locId",
                            "required": "required"
                        },
                        {
                            "dataName": "locName",
                            "required": "required"
                        },
                        {
                            "dataName": "visitDateTime",
                            "required": "required"
                        },
                        {
                            "dataName": "visitType",
                            "required": "required"
                        },
                        {
                            "dataName": "visitString",
                            "required": "optional"
                        }
                    ]
                }
            ],
            "section": {
                "id": "1;1;2",
                "name": "ALL TAB ADMIN"
            }
        },
        {
            "abbreviatedDisplayText": "COVID",
            "action": "actShowDetail",
            "callDetailRPCs": false,
            "color": "clYellow",
            "createNote": false,
            "detailText": " \r\nCheck the lab results or details below - the most recent testing may require\r\ninterpretation based on the clinical setting.\r\n \r\nTest results were entered for 4\/30\/2010@16:00.\r\n \r\n \r\nLAB RESULTS:\r\nDate                Test Name                           Result\r\n04\/30\/2010@16:00    WBC                                 5.5            \r\n11\/16\/2009@11:00    WBC                                 6.5            \r\n05\/21\/2008@16:00    WBC                                 6.3            \r\n \r\nDate                Test Name                           Result\r\n No Ab lab results \r\n \r\n \r\nOUTSIDE COVID-19 LABS:\r\nDate       Health Factor Name                      Comment      Location\r\n No outside labs recorded                                                      \r\n \r\nOTHER CLINICAL INFORMATION:\r\nDate        Health Factor Name\r\n No specific HFs recorded                                 \r\n \r\n \r\nCOVID-19 Problem List:\r\n None                                                               \r\n \r\nDate          Immunization                                     Series\r\n No prior COVID -19 immunization                                            \r\n\r\n",
            "disabled": false,
            "displayText": "COVID-19               Testing Completed - see details",
            "id": "1;1;2;3",
            "imageIcon": "59423;clWindowText;60046;clRed",
            "name": "COVID",
            "popOut": "showEmbedded",
            "section": {
                "id": "1;1;2",
                "name": "ALL TAB ADMIN"
            }
        },
        {
            "abbreviatedDisplayText": "MEDS",
            "action": "actShowDetail",
            "callDetailRPCs": false,
            "color": "clLime",
            "createNote": false,
            "detailText": "Active Outpatient Medications (excluding Supplies):\r\n \r\nNo Medications Found\r\n \r\n",
            "disabled": false,
            "displayText": "Active Medications",
            "id": "1;1;3;1",
            "imageIcon": "59718;clWindowText;61799;clWindow",
            "name": "ACTIVE MEDS",
            "popOut": "showModal",
            "section": {
                "id": "1;1;3",
                "name": "MEDS"
            }
        },
        {
            "abbreviatedDisplayText": "AGE",
            "action": "actShowDetail",
            "callDetailRPCs": false,
            "color": "clWhite",
            "createNote": false,
            "detailText": "  Computed Finding: VA-Patient Age\r\n   03\/27\/2024@13:37:43 value - 28\r\n\r\n",
            "disabled": false,
            "displayText": "Patient is less than 40",
            "id": "1;1;4;1",
            "imageIcon": "59718;clWindowText;61799;clWindow",
            "name": "PATIENT AGE",
            "popOut": "showEmbedded",
            "section": {
                "id": "1;1;4",
                "name": "NOTES"
            }
        },
        {
            "abbreviatedDisplayText": "JEDIT",
            "action": "actShowEditor",
            "callDetailRPCs": true,
            "createNote": false,
            "disabled": false,
            "displayText": "JM Test Editor",
            "id": "2;1;1;2",
            "imageIcon": "010101F6060000424DF606000000000000360000002800000018000000180000000100180000000000C0060000C40E0000C40E00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF352C562D237C251B8A211890251BAB271E912F27823A315A3D352EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF30275C20197B1C13781A126F150E5619126C1A1270150E5920168A23199B2A208F342C653E353AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF362D6A20176E1C147B1E1580171164140D521E15851D147A0F0B362A2753322B821C156C1A1375231A9E2A20933B3150FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF352D5D1B13711E158020178D160F5E140D512118951D1580100B42393749B6B5C7B8B7C0C4C3CDC1C0D02F26A1241A9E261DA43A2F56FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF382F551F157E1E168520178C16105F181066231AA020168B120C4B1613319493A3E7E7F0FEFEFEE4E3EBA19EC92F25AC211791221897291FB03A3150FFFFFFFFFFFFFFFFFF39314C1E156E20178C1E1584140E5419126E261BA81E1687130C4C1A16379D9CA8C5C4D9FBFBFDFFFFFFEBEBF2746EC5231A8E1E1683211791251BA82A20903D3
            438FFFFFFFFFFFF28216F20178E211890140E561A1271281DB41E168317114F26233FAAA9B3AEADC6FEFEFEFFFFFFFFFFFFC8C6E1524B9D211A6C46408B21178F261CAD22199B352C66FFFFFF3B333E251B8B2219991811671D147D3329B44F4A8F4B47706B697AB7B6C4CCCADBF9F9FBFFFFFFFFFFFFFEFEFEA4A1CD5752869290B05751A323199E241A9F2118932C229EFFFFFF362C68241A9D1A126D1B1377281DB49490CEE5E5E8E5E5E6EBEBEEEEEEF4FCFCFDFFFFFFFFFFFFFEFEFEC2C2C9928FAE7E7B9FB0AEC9251C8F24199E20168921178F251BA53A305A3125941F17862621615A54A130298BDAD9EAFFFFFFFFFFFFFFFFFFFDFDFDF8F8F9E1E1E1B1B0BCACABBFBCBBC53F3C699694B28F8BC1241AA11F16861E158221179023199C2E25842A1FA22E2683ACA8DCF8F8FA595585E6E6EDFFFFFFFFFFFFFFFFFFE2E2E49E9DAA9491C07D7A9D4643562D294B676584BFBECF4D45B620178B1C147A1E158223199A2218992A20A0271BAA4D45B4B1AEDBF8F8F85C5797CBC9EBFFFFFFFFFFFFFFFFFFCCCCCE9290B18682B98685938E8E949D9CA6C0C0CAC3C1DC2821811A12701D147B1F168B261CAB20178F2A1FBD281DB85249C7B0ADCEFEFEFE7972D48680DEFEFEFFFFFFFFFFFFFFF0F0F5BDBCD0B9B9C1DFDFDFFDFDFDFFFFFFFFFFFF8B87AF1D166B1B13731E15
            83281DB420178B211892261DB42F23BA4238C1BEBDD1EEEEF3ACA9D7382FA3DAD9E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2F2F656518C19126C1C147D2419A02117911E168623199B2A1FA03227A1291FAFD1CFE6C9C8DEF3F3F7514D7E4C486EE7E6F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9591B5211A6E1B1375231A9D20178D1D157F20178C23199931268A362D75271CAD8B85D9CAC8DEFAFAFCECECED3C368E5C53D1D2D0E7F4F4F5FAFAFBFBFBFEF7F7F7E4E3E9716E9517105F1B1375251AA32118921C14781D1581241AA123199B392F613D344B2A1EB44035D9D6D4EBDEDEE6FEFEFED2D0E55A54A5231E5D5351678B87B9928FC16968753C395D57557B4B4680261C9620178F1A13721E157F241A9F2218972A1EA3FFFFFFFFFFFF3127A12F22D87D76DAC8C7D9EBEBF3FFFFFFECEBF0C6C6CD8C8A9A716DA66C6A88919096CDCCD3F5F5F7EAE9F0807DA71D16641C147A241AA0201890221897342B6FFFFFFFFFFFFF3B325D2F23CD382DC8BEBBE8B9B7D3E7E6EFFDFDFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFEBBBAC92C258A2017901F178D2B209E3D353DFFFFFFFFFFFFFFFFFF382D872E20CA4D43D7C0BDF3CBCADBDBDBE4EBEAF1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F0F3DCDBE
            2BAB9CB7873B020178E271CAA372E69FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF362C7C2F21D43B30DC7C75D9D8D7ECE0E0EAC4C3D0C4C4C8C7C7D9C6C6CDC5C4CDC5C4CED5D5DCB7B5D05B559D281F94271DA9362C62FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF382D863024D32F22D63F33D78A83E3D3D1EDF0EFF9F1F1F7F0F0F5ECECF6C9C6EE6E67B9231A7C231999291EA5392F58FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3B325F3429AC3022CD2E21CF2A1FB63F36C2453E943F39832F269B2318971F1685271D982F258A3A3250FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3D344D392F7A3327A62F24C22A1DB42A1EAE281F952E2483362C653C3442FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
            "name": "JM TEST EDITOR",
            "popOut": "showNonModal",
            "requiredData": [
                {
                    "dataName": "dataUserInformation",
                    "errorMessage": "User not defined.",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "optional"
                        },
                        {
                            "dataName": "name",
                            "required": "optional"
                        }
                    ]
                },
                {
                    "dataName": "dataEncounterProvider",
                    "errorMessage": "Encounter provider information not defined",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "optional"
                        },
                        {
                            "dataName": "name",
                            "required": "optional"
                        }
                    ]
                },
                {
                    "dataName": "dataVisitInformation",
                    "errorMessage": "Visit Information missing",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "optional"
                        },
                        {
                            "dataName": "locId",
                            "required": "required"
                        },
                        {
                            "dataName": "locName",
                            "required": "required"
                        },
                        {
                            "dataName": "visitDateTime",
                            "required": "required"
                        },
                        {
                            "dataName": "visitType",
                            "required": "required"
                        },
                        {
                            "dataName": "visitString",
                            "required": "optional"
                        }
                    ]
                }
            ],
            "section": {
                "id": "2;1;1",
                "name": "ALL TAB ADMIN"
            }
        },
        {
            "abbreviatedDisplayText": "WWWWW",
            "action": "actShowUrl",
            "callDetailRPCs": false,
            "createNote": false,
            "disabled": false,
            "displayText": "Google",
            "id": "2;1;1;1",
            "imageIcon": "60225;clWindowText;59963;clLime",
            "name": "GOOGLE",
            "popOut": "showNonModal",
            "section": {
                "id": "2;1;1",
                "name": "ALL TAB ADMIN"
            },
            "url": "http:\/\/WWW.GOOGLE.COM"
        },
        {
            "abbreviatedDisplayText": "MSG",
            "action": "actShowMessage",
            "callDetailRPCs": false,
            "createNote": false,
            "detailText": "This is another test message.\r\n",
            "disabled": false,
            "displayText": "MESSAGE",
            "id": "2;1;1;3",
            "imageIcon": "59581;clWindowText;32;clLime",
            "name": "MESSAGE",
            "section": {
                "id": "2;1;1",
                "name": "ALL TAB ADMIN"
            }
        },
        {
            "abbreviatedDisplayText": "Testy",
            "action": "actShowUrl",
            "callDetailRPCs": true,
            "color": "clSkyBlue",
            "createNote": false,
            "disabled": false,
            "displayText": "TESTING",
            "id": "2;1;1;4",
            "imageIcon": "60225;clWindowText;59963;clLime",
            "name": "TESTING",
            "popOut": "showEmbedded",
            "requiredData": [
                {
                    "dataName": "dataDivision",
                    "errorMessage": "Division information is missing",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "required"
                        },
                        {
                            "dataName": "name",
                            "required": "notRequired"
                        }
                    ]
                },
                {
                    "dataName": "dataPort",
                    "errorMessage": "Port number is missing",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "required"
                        }
                    ]
                },
                {
                    "dataName": "dataServer",
                    "errorMessage": "Server is missing",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "required"
                        }
                    ]
                },
                {
                    "dataName": "dataStationNumber",
                    "errorMessage": "Station number information is missing",
                    "required": true,
                    "returnData": [
                        {
                            "dataName": "id",
                            "required": "required"
                        }
                    ]
                }
            ],
            "section": {
                "id": "2;1;1",
                "name": "ALL TAB ADMIN"
            },
            "url": "http:\/\/www.googlex.com TEST DIVISION=%DIVISION SERVER=%SRV PORT=%PORT DFN=%DFN DUZ=%DUZ STATION=%STATION"
        }
    ],
    "sections": [
        {
            "abbreviatedDisplayText": "CI",
            "collapsible": false,
            "color": "clSkyBlue",
            "disabled": false,
            "displayText": "Clinical Information",
            "id": "1;1;1",
            "isNational": true,
            "name": "ALL TAB CLINICAL",
            "pageID": -1,
            "tab": "tabAll"
        },
        {
            "abbreviatedDisplayText": "NAF",
            "collapsible": true,
            "color": "clSkyBlue",
            "disabled": false,
            "displayText": "Admin Function",
            "id": "1;1;2",
            "isNational": true,
            "name": "ALL TAB ADMIN",
            "pageID": -1,
            "tab": "tabAll"
        },
        {
            "abbreviatedDisplayText": "MTD",
            "collapsible": true,
            "color": "clSilver",
            "disabled": false,
            "displayText": "Meds Tab Display",
            "id": "1;1;3",
            "isNational": true,
            "name": "MEDS",
            "pageID": 3,
            "tab": "tabMeds"
        },
        {
            "abbreviatedDisplayText": "NTS",
            "collapsible": true,
            "color": "clSilver",
            "disabled": false,
            "displayText": "NOTES TAB SECTION",
            "id": "1;1;4",
            "isNational": true,
            "name": "NOTES",
            "pageID": 6,
            "tab": "tabNotes"
        },
        {
            "abbreviatedDisplayText": "Local",
            "collapsible": true,
            "color": "clLime",
            "disabled": false,
            "displayText": "Local Section",
            "id": "2;1;1",
            "isNational": false,
            "name": "ALL TAB ADMIN",
            "pageID": -1,
            "tab": "tabAll"
        }
    ]
  }
  ''';
begin

end;

end.
