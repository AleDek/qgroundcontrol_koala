/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.12
import QtQuick.Controls         2.4
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12

import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1

import QGroundControl               1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

Item {
    id: _root

    // These should only be used by MainRootWindow
    property var planController:    _planController
    property var guidedController:  _guidedController

    PlanMasterController {
        id:                     _planController
        flyView:                true
        Component.onCompleted:  start()
    }

    property bool   _mainWindowIsMap:       mapControl.pipState.state === mapControl.pipState.fullState
    property bool   _isFullWindowItemDark:  _mainWindowIsMap ? mapControl.isSatelliteMap : true
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property var    _missionController:     _planController.missionController
    property var    _geoFenceController:    _planController.geoFenceController
    property var    _rallyPointController:  _planController.rallyPointController
    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property var    _guidedController:      guidedActionsController
    property var    _guidedActionList:      guidedActionList
    property var    _guidedValueSlider:     guidedValueSlider
    property var    _widgetLayer:           widgetLayer
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
    property rect   _centerViewport:        Qt.rect(0, 0, width, height)
    property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 30
    property var    _mapControl:            mapControl

    property real   _mydata:                _activeVehicle   ? _activeVehicle.mydata.rawValue : 0 //custom
    property string _gas_type:              _activeVehicle   ? _activeVehicle.gas_type.rawValue : "-" //custom
    property real   _gas_conc:              _activeVehicle   ? _activeVehicle.gas_conc.rawValue : 0 //custom
    property string _gas_err:               _activeVehicle   ? _activeVehicle.gas_err.rawValue : "-" //custom
    property bool   _concledState:          _activeVehicle   ? _activeVehicle.getConcLedState() : false  // custom

    property string _koala_state:           _activeVehicle   ? _activeVehicle.koala_state.rawValue : "Not connected" //custom
    property int   _koala_clamp_busy:       _activeVehicle   ? _activeVehicle.koala_clamp_busy.rawValue : 0 //custom
    property int   _koala_autonomous:       _activeVehicle   ? _activeVehicle.koala_autonomous.rawValue : 0 //custom
    property bool   _statusledState:        _activeVehicle   ? _activeVehicle.getStatusLedState() : false  // custom

    property bool   _autonomousledState:    _activeVehicle   ? _activeVehicle.getAutonomousLedState() : false  // custom


    property real   _fullItemZorder:    0
    property real   _pipItemZorder:     QGroundControl.zOrderWidgets

    function _calcCenterViewPort() {
        var newToolInset = Qt.rect(0, 0, width, height)
        toolstrip.adjustToolInset(newToolInset)
        if (QGroundControl.corePlugin.options.instrumentWidget) {
            flightDisplayViewWidgets.adjustToolInset(newToolInset)
        }
    }

    QGCToolInsets {
        id:                     _toolInsets
        leftEdgeBottomInset:    _pipOverlay.visible ? _pipOverlay.x + _pipOverlay.width : 0
        bottomEdgeLeftInset:    _pipOverlay.visible ? parent.height - _pipOverlay.y : 0
    }

    FlyViewWidgetLayer {
        id:                     widgetLayer
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.left:           parent.left
        anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
        z:                      _fullItemZorder + 1
        parentToolInsets:       _toolInsets
        mapControl:             _mapControl
        visible:                !QGroundControl.videoManager.fullScreen
    }


    FlyViewCustomLayer {
        id:                 customOverlay
        anchors.fill:       widgetLayer
        z:                  _fullItemZorder + 2
        parentToolInsets:   widgetLayer.totalToolInsets
        mapControl:         _mapControl
        visible:            !QGroundControl.videoManager.fullScreen
    }

    // Development tool for visualizing the insets for a paticular layer, enable if needed
    /*
    FlyViewInsetViewer {
        id:                     widgetLayerInsetViewer
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.left:           parent.left
        anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right

        z:                      widgetLayer.z + 1

        insetsToView:           customOverlay.totalToolInsets
    }*/

    GuidedActionsController {
        id:                 guidedActionsController
        missionController:  _missionController
        actionList:         _guidedActionList
        guidedValueSlider:     _guidedValueSlider
    }

    /*GuidedActionConfirm {
        id:                         guidedActionConfirm
        anchors.margins:            _margins
        anchors.bottom:             parent.bottom
        anchors.horizontalCenter:   parent.horizontalCenter
        z:                          QGroundControl.zOrderTopMost
        guidedController:           _guidedController
        guidedValueSlider:             _guidedValueSlider
    }*/

    GuidedActionList {
        id:                         guidedActionList
        anchors.margins:            _margins
        anchors.bottom:             parent.bottom
        anchors.horizontalCenter:   parent.horizontalCenter
        z:                          QGroundControl.zOrderTopMost
        guidedController:           _guidedController
    }

    //-- Guided value slider (e.g. altitude)
    GuidedValueSlider {
        id:                 guidedValueSlider
        anchors.margins:    _toolsMargin
        anchors.right:      parent.right
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        z:                  QGroundControl.zOrderTopMost
        radius:             ScreenTools.defaultFontPixelWidth / 2
        width:              ScreenTools.defaultFontPixelWidth * 10
        color:              qgcPal.window
        visible:            false
    }

    FlyViewMap {
        id:                     mapControl
        planMasterController:   _planController
        rightPanelWidth:        ScreenTools.defaultFontPixelHeight * 9
        pipMode:                !_mainWindowIsMap
        toolInsets:             customOverlay.totalToolInsets
        mapName:                "FlightDisplayView"
    }

    FlyViewVideo {
        id: videoControl
    }

    QGCPipOverlay {
        id:                     _pipOverlay
        // anchors.left:           parent.left
        anchors.right:           parent.right //custom
        anchors.bottom:         parent.bottom
        anchors.margins:        _toolsMargin
        item1IsFullSettingsKey: "MainFlyWindowIsMap"
        item1:                  mapControl
        item2:                  QGroundControl.videoManager.hasVideo ? videoControl : null
        fullZOrder:             _fullItemZorder
        pipZOrder:              _pipItemZorder
        show:                   !QGroundControl.videoManager.fullScreen &&
                                    (videoControl.pipState.state === videoControl.pipState.pipState || mapControl.pipState.state === mapControl.pipState.pipState)
    }

     //-----------------------------------------------------------> CUSTOM WIDGET - DEBUG VECT Viewer v1.0 (MAVROS)

    // Rectangle {  // Widget personalizzato
    //     width: 400 // larghezza
    //     height: 250 // altezza
    //     color: "white" // Colore del bordo
    //     opacity: 0.7  // Regola l'opacità del widget
    //     radius: 15 // Raggio più grande per angoli arrotondati
    //     // Allinea il widget a sinistra
    //     anchors.left: parent.left
    //     anchors.leftMargin: 5 // Aggiungi un margine sinistro all'intero Rectangle
    //     anchors.verticalCenter: parent.verticalCenter
    // }

    Rectangle {  
        width: 368 // Riduci la larghezza del rettangolo interno
        height: 268 // Riduci l'altezza del rettangolo interno
        // color: "black"
        color: Qt.rgba(106/255., 130/255., 152/255., 1)
        opacity: 1.0 //
        radius: 10
        // Allinea il rettangolo interno a sinistra
        anchors.left: parent.left
        anchors.leftMargin: 5 // Aggiungi un margine sinistro all'intero Rectangle
        // anchors.verticalCenter: parent.verticalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        Column{
            anchors.fill: parent
            spacing: 1

            Rectangle {
                width: parent.width
                height: 40
                color: "transparent"
                // opacity: 1.0 //

                Text {
                    anchors.top: parent.top
                    anchors.topMargin: 8

                    anchors.fill: parent

                    property string stringData: "KOALA DRONE STATUS"
                    text: stringData 
                    font.pixelSize: 24
                    color: "white"
                    verticalAlignment: Text.AlignTop // Allinea il testo verticalmente al centro
                    horizontalAlignment: Text.AlignHCenter // Centra il testo orizzontalmente
                    font.bold: true // Imposta il testo in grassetto
                    font.family: "Bahnschrift" //Imposta il tipo di font desiderato
                    // width: parent.width // Imposta la larghezza del testo come la larghezza del rettangolo
                }

            }

            Rectangle {
                anchors.top: parent.top
                anchors.topMargin: 40

                width: parent.width
                height: 108
                color: "transparent"
                // opacity: 1.0 //
                // anchors.fill: parent // Occupa tutto lo spazio disponibile nel rettangolo
                // anchors.topMargin: 6
                // spacing: 10 // Aggiunge uno spazio di 10 unità tra i due elementi

                
                
                Row{
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    spacing: 20
                    anchors.fill: parent

                    Column{
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        spacing: 10
                        // anchors.fill: parent

                        Text { //state text
                            // anchors.left: parent.left
                            anchors.leftMargin: 6 
                            property string stringData: " Current state:   "
                            text: stringData + _koala_state
                            font.pixelSize: 16
                            color: "azure"
                            verticalAlignment: Text.AlignVCenter // Allinea il testo verticalmente al centro
                            font.bold: true // Imposta il testo in grassetto
                            font.family: "Sans Serif" //Imposta il tipo di font desiderato
                        }

                        Text {
                            // anchors.left: parent.left
                            id: clamptext
                            anchors.leftMargin: 6 
                            property string stringDefault: " Clamping system:   "
                            property string stringValue: _koala_clamp_busy ? "moving" : "off" 
                            text: stringDefault +  stringValue;    
                            font.pixelSize: 16
                            color: "azure"
                            verticalAlignment: Text.AlignVCenter // Allinea il testo verticalmente al centro
                            font.bold: true // Imposta il testo in grassetto
                            font.family: "Sans Serif" //Imposta il tipo di font desiderato
                        }

                        Text {
                            // anchors.left: parent.left
                            anchors.leftMargin: 6 
                            property string stringDefault: " Autonomous operation:   "
                            property string stringValue: _koala_autonomous ? "ON" : "off" 
                            text: stringDefault +  stringValue;
                            font.pixelSize: 16
                            color: "azure"
                            verticalAlignment: Text.AlignVCenter // Allinea il testo verticalmente al centro
                            font.bold: true // Imposta il testo in grassetto
                            font.family: "Sans Serif" //Imposta il tipo di font desiderato
                        }
                    }

                    Column{
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        spacing: 14
                        // anchors.fill: parent
                        anchors.right: parent.right
                        anchors.rightMargin: 27 //47 // Aggiungi un margine sinistro all'intero Rectangle

                        Rectangle {  // Bordo LED Clamp Status
                            // anchors.right: parent.left
                            // anchors.rightMargin: 6 
                            width: 25
                            height: 14
                            color: "transparent"

                        }
                        Rectangle {  // Bordo LED Clamp Status
                            // anchors.right: parent.left
                            // anchors.rightMargin: 6 
                            width: 25
                            height: 25
                            radius: 15
                            color: "white"

                            Rectangle {      //LED Clamping Status
                                id: statusled
                                width: 23
                                height: 23
                                radius: 13
                                // color: _statusledState ? "yellow" : "red"
                                color: "white"

                            }
                        }

                        Rectangle {  // Bordo LED Clamp Status
                            width: 25
                            height: 25
                            radius: 15
                            color: "white"

                            Rectangle {      //LED Clamping Status
                                id: autonomousled
                                width: 23
                                height: 23
                                radius: 13
                                // color: _statusledState ? "yellow" : "red"
                                color: "white"

                            }
                        }
                    }
                }
            }    
        
            Rectangle {   //GAS section
                //dimensioni rettangolo interno più piccolo
                anchors.bottom: parent.bottom;
                width: parent.width // Larghezza uguale a quella del parent
                // height: parent.height / 1.8 // Altezza uguale a quella del parent : 1,5 
                height: 120// Altezza uguale a quella del parent : 1,5 
                color: "azure"
                opacity: 1.0
                radius: 10
                Row{
                    spacing: 60
                    anchors.fill: parent

                    Column {
                        spacing: 10
                        anchors.fill: parent

                        Rectangle {
                            width: 1  // Larghezza del separatore
                            height: 10 // Altezza del separatore
                            color: "transparent" // Colore trasparente
                        }  

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 6 
                            property string stringData: "Gas Type:  "
                            text: "<b>" + stringData + "</b>" + _gas_type //stampa testo; <b> Imposta il testo in grassetto
                            font.pixelSize: 16
                            color: "midnightblue"
                            verticalAlignment: Text.AlignVCenter // Allinea il testo verticalmente al centro
                            font.bold: true // Imposta il testo in grassetto
                            font.family: "Sans Serif" //Imposta il tipo di font desiderato
                        }
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 6 
                            property string stringData: "Concentration: "
                            property string stringUnit: " %LEL"
                            text: "<b>" + stringData + "</b>" + _gas_conc.toFixed(1)+ stringUnit //stampa testo; <b> Imposta il testo in grassetto
                            font.pixelSize: 16
                            color: "midnightblue"
                            verticalAlignment: Text.AlignVCenter // Allinea il testo verticalmente al centro
                            font.family: "Sans Serif" //Imposta il tipo di font desiderato
                        }
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 6 
                            property string stringData: "Status: "
                            text: "<b>" + stringData + "</b>" + _gas_err //stampa testo; <b> Imposta il testo in grassetto
                            font.pixelSize: 16
                            color: "midnightblue"
                            verticalAlignment: Text.AlignVCenter // Allinea il testo verticalmente al centro
                            font.family: "Sans Serif" //Imposta il tipo di font desiderato
                        }

                        // Row{
                        //     Rectangle {
                        //         width: 330  // Aggiunto spazio tra il bordo del widget e il LED Critical Concentration
                        //         height: 1
                        //         color: "transparent"
                        //     }
                        //     Rectangle {                // Bordo LED Critical Concentration
                        //         width: 40
                        //         height: 40
                        //         radius: 30
                        //         color: "white"

                        //         Rectangle {                //LED Critical Concentration
                        //             width: 38
                        //             height: 38
                        //             radius: 28
                        //             color: _concledState ? "red" : "azure"
                        //         }
                        //     }
                        // }
                    }

                    Rectangle {                // Bordo LED Critical Concentration
                        width:  60
                        height: 60
                        radius: 30
                        color: "white"
                        anchors.right: parent.right
                        anchors.rightMargin: 10 //30 // Aggiungi un margine sinistro all'intero Rectangle
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {                //LED Critical Concentration
                            id: concled
                            width:  56
                            height: 56
                            radius: 28
                            color: "white"
                            Behavior on color {
                                enabled: _concledState
                                SequentialAnimation {
                                    loops: 4
                                    ColorAnimation { from: "white"; to: "red"; duration: 250 }
                                    ColorAnimation { from: "red"; to: "white";  duration: 250 }
                                }
                            }
                        }
                    }
                }
            }
        }
          
    }
   
    Connections {
        target: _activeVehicle
        onStatusLedStateChanged: {
            // Aggiorna la variabile in QML quando cambia lo stato
            _statusledState = _activeVehicle.getStatusLedState();
            // Aggiorna il testo e il colore in base allo stato
            // statusText.text = _statusledState ? "online_msgreceived" : "offline_msgnotreceived"; //change text
            // statusText.color = _statusledState ? "yellow" : "red";
            statusled.color = _statusledState ? "red" : "green";
        }
        onConcLedStateChanged: {
            // Aggiorna la variabile in QML quando cambia lo stato
            _concledState = _activeVehicle.getConcLedState();
            concled.color = _concledState ? "red" : "green";
        }

        onAutonomousLedStateChanged: {
            // Aggiorna la variabile in QML quando cambia lo stato
            _autonomousledState = _activeVehicle.getAutonomousLedState();
            autonomousled.color = _autonomousledState ? "red" : "green";
        }

    }
}
