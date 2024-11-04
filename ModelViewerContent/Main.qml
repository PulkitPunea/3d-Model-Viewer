import QtQuick

import QtQuick.Layouts

import QtQuick.Controls
import QtQuick.Controls.Material 2.12

import "components"

import Qt.labs.platform //File Diaog

Item {
    id: mainRoot
    width: 1280
    height: 720

    property Item loadedItem;
    property string viewMode: "view mode : Perspective View"

    FileDialog {
        id: selectDialogBox
        title: "Select a 3D Model File"
        nameFilters: ["3D Model Files (*.obj *.dae *.fbx *.stl *.ply *.gltf *.glb)"]
        onAccepted: {
            console.log("CurrentFile :", selectDialogBox.currentFile)
            console.log("Folder :", selectDialogBox.folder)
            _modelName.text = selectDialogBox.file
            modelManager.processModel(selectDialogBox.currentFile, selectDialogBox.folder);
        }
        onRejected: {
            console.log("No file selected")
        }
    }

    Connections {
        target: modelManager
        onModelProcessed: function(filePath) {
            console.log("Signal: onModelProcessed", filePath);

            var fileUrl = Qt.resolvedUrl(filePath); // Convert to QUrl format if necessary
            console.log("Resolved file URL:", fileUrl);

            if (fileUrl) {
                if(loadedItem) {
                    console.log("Loading model from:", fileUrl);
                    loadedItem.loadModelSignal(fileUrl);
                } else {
                    console.log("fileUrl is not defined !");
                }
                // Clear paths after processing
                modelManager.setInputFilePathC("");
                modelManager.setoutputDirectoryC("");
            }
        }
    }

    ColumnLayout {
        id: appLayout
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: header
            height: 50
            color: "#333333"
            border.color: "#444444"
            Layout.fillHeight: false
            Layout.fillWidth: true

            Text {
                text: "© 3D Model Viewer"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 35
                color: "#f5f5f5"
                font.bold: true
                font.pixelSize: 20
            }
        }

        RowLayout {
            id: mainViewLayout
            spacing: 0
            width: parent.width
            Layout.fillHeight: true

            Rectangle {
                id: optionsPanel
                Layout.preferredWidth: parent.width * 0.2
                Layout.fillHeight: true
                color: "#444444"
                border.color: "#555555"

                ScrollView {
                    id: scrollView
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 5
                    anchors.topMargin: 5
                    anchors.bottomMargin: 5

                    ColumnLayout {
                        id: propertieLayout
                        anchors.fill: parent
                        spacing: 0
                        Material.theme: Material.Dark

                        // "Show" Section
                        Text {
                            id: _show
                            color: "#f5f5f5"
                            text: qsTr("Show")
                            font.pixelSize: 20
                            verticalAlignment: Text.AlignVCenter
                        }

                        RowLayout {
                            id:_3dGridLayout
                            spacing: 0
                            Layout.fillWidth: true

                            CheckBox {
                                id: _3dGridChBx
                                width: 30;
                                height: 30;
                                Layout.fillHeight: false
                                Layout.fillWidth: false
                                Material.accent: Material.LightBlue
                                onCheckedChanged: {
                                    loadedItem.showGrid(checked)
                                }
                            }
                            Text {
                                id: _3dGridText
                                text: qsTr("3D Grid")
                                color: "#f5f5f5"
                                font.letterSpacing: 0.1
                                verticalAlignment: Text.AlignVCenter
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                font.pointSize: 12

                            }
                        }

                        RowLayout {
                            id:_3dAxisLayout
                            spacing: 0
                            Layout.fillWidth: true

                            CheckBox {
                                id: _3dAxisChBx
                                width: 30;
                                height: 30;
                                Material.accent: Material.LightBlue
                                onCheckedChanged: {
                                    loadedItem.showAxis(checked);
                                }

                            }
                            Text {
                                id: _3dAxisText
                                text: qsTr("3D Axis")
                                color: "#f5f5f5"
                                font.letterSpacing: 0.1
                                verticalAlignment: Text.AlignVCenter
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                font.pointSize: 12
                            }
                        }

                        RowLayout {
                            id: _SkyBoxRowLayout
                            spacing: 0
                            CheckBox {
                                id: _SkyBoxChBx
                                width: 30
                                height: 30
                                Material.accent: Material.LightBlue
                                onCheckedChanged: {
                                    loadedItem.showSkybox(checked)
                                }
                            }

                            Text {
                                id: _SkyBoxText
                                color: "#f5f5f5"
                                text: qsTr("SkyBox")
                                font.letterSpacing: 0.1
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Layout.fillWidth: true
                        }

                        RowLayout {
                            id: _DirectionalLightLayout
                            spacing: 0
                            CheckBox {
                                id: _DirectionalLightChBx
                                width: 30
                                height: 30
                                checked: true
                                Material.accent: Material.LightBlue
                                onCheckedChanged: {
                                    loadedItem.showDirectionalLight(checked)
                                }
                            }

                            Text {
                                id: _DirectionalLightText
                                color: "#f5f5f5"
                                text: qsTr("Directional Light")
                                font.letterSpacing: 0.1
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Layout.fillWidth: true
                        }

                        RowLayout {
                            id: _UVLayout
                            spacing: 0
                            CheckBox {
                                id: _UVChBx
                                width: 30
                                height: 30
                                Material.accent: Material.LightBlue
                                onCheckedChanged: {
                                    loadedItem.showUV(checked)
                                }
                            }

                            Text {
                                id: _UVText
                                color: "#f5f5f5"
                                text: qsTr("UV Material")
                                font.letterSpacing: 0.1
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Layout.fillWidth: true
                        }

                        Text {
                            id: _rendering
                            color: "#f5f5f5"
                            text: qsTr("Rendering")
                            font.pixelSize: 20
                            verticalAlignment: Text.AlignVCenter
                            Layout.bottomMargin: 0
                        }

                        RowLayout {
                            id: _AmbientOcclusionLayout
                            spacing: 0
                            CheckBox {
                                id: _AmbientOcclusionChBx
                                width: 30
                                height: 30
                                Material.accent: Material.LightBlue
                                onCheckedChanged: {
                                    loadedItem.showAO(checked)
                                }
                            }

                            Text {
                                id: _AmbientOcclusionText
                                color: "#f5f5f5"
                                text: qsTr("Ambient Occlusion")
                                font.letterSpacing: 0.1
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Layout.fillWidth: true
                        }


                        RowLayout {
                            id: _WireframeLayout
                            spacing: 0
                            CheckBox {
                                id: _WireframeChBx
                                width: 30
                                height: 30
                                Material.accent: Material.LightBlue
                                onCheckedChanged: {
                                    console.log(checked);
                                    loadedItem.enableWireframe(checked)
                                }
                            }

                            Text {
                                id: _WireframeText
                                color: "#f5f5f5"
                                text: qsTr("Wireframe")
                                font.letterSpacing: 0.1
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Layout.fillWidth: true
                        }

                        RowLayout {
                            id: _FogLayout
                            spacing: 0
                            CheckBox {
                                id: _FogChBx
                                width: 30
                                height: 30
                                Material.accent: Material.LightBlue
                                onCheckedChanged: {
                                    loadedItem.showFog(checked)
                                }
                            }

                            Text {
                                id: _FogText
                                color: "#f5f5f5"
                                text: qsTr("Enable Fog")
                                font.letterSpacing: 0.1
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Layout.fillWidth: true
                        }


                        Text {
                            id: _antialiasingQuality
                            color: "#f5f5f5"
                            text: qsTr("Antialiasing Quality")
                            font.pixelSize: 20
                            verticalAlignment: Text.AlignVCenter
                            Layout.bottomMargin: 10
                        }

                        ComboBoxC {
                            id: _aQCoBx
                            height: 40
                            Layout.leftMargin: 12
                            width: 208
                            model: ["Medium", "High", "VeryHigh"]
                            onCurrentTextChanged: {
                                switch (currentText) {
                                case "Medium" :
                                    loadedItem.setAQ(0);
                                    break;
                                case "High" :
                                    loadedItem.setAQ(1);
                                    break;
                                case "VeryHigh":
                                    loadedItem.setAQ(2);
                                    break;
                                }
                            }

                        }

                        Text {
                            id: _MaterialOverride
                            color: "#f5f5f5"
                            text: qsTr("Material Override")
                            font.pixelSize: 18
                            verticalAlignment: Text.AlignVCenter
                            Layout.topMargin: 10
                            Layout.bottomMargin: 10
                        }

                        ComboBoxC {
                            id: _MaterialOverrideCoBx
                            Layout.leftMargin: 12
                            model: ["None", "BaseColor", "Roughness", "Metalness", "Normals"]
                            onCurrentTextChanged: {
                                switch (currentText) {
                                case "None":
                                    loadedItem.setMO(0);
                                    break;
                                case "BaseColor":
                                    loadedItem.setMO(1);
                                    break;
                                case "Roughness":
                                    loadedItem.setMO(2);
                                    break;
                                case "Metalness":
                                    loadedItem.setMO(3);
                                    break;
                                case "Normals":
                                    loadedItem.setMO(4);
                                    break;
                                }
                            }

                        }

                        Text {
                            id: _Miscellaneous
                            color: "#f5f5f5"
                            text: qsTr("Miscellaneous")
                            font.pixelSize: 20
                            verticalAlignment: Text.AlignVCenter
                            Layout.bottomMargin: 0
                            Layout.topMargin: 10
                        }

                        RowLayout {
                            id: _AdvanceDebuggingRowLayout
                            spacing: 0
                            CheckBox {
                                id: _AdvanceDebuggingChBx
                                width: 30
                                height: 30
                                Material.accent: Material.LightBlue
                                onCheckedChanged: {
                                    loadedItem.showAdvanceDebug(checked)
                                }
                            }

                            Text {
                                id: _AdvanceDebuggingText
                                color: "#f5f5f5"
                                text: qsTr("Advance Debugging")
                                font.letterSpacing: 0.1
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            Rectangle {
                id: renderer
                Layout.preferredWidth: parent.width * 0.8
                Layout.fillHeight: true

                color: "#4f4f4f"
                border.color: "#666666"

                RowLayout {
                    id: renderDetails
                    x: 806
                    y: 0
                    width: 200
                    height: 400
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 10
                    anchors.topMargin: 20
                    spacing: 0
                }

                Loader {
                    id: loader
                    focus: true
                    anchors.fill: parent
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.topMargin: 0
                    anchors.bottomMargin: 20
                    source: "ModelObject.qml"
                    z: 1
                    asynchronous: true

                    onLoaded: {
                        if(loader.item) {
                            loadedItem = loader.item;

                        } else {
                            console.log("loader.item is undefined !");
                        }
                    }
                }

                Rectangle {
                    id: _StatsRec
                    height: 20
                    color: "#333333"
                    border.color: "#444444"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0

                    RowLayout {
                        id: rowLayout
                        y: -2
                        width: implicitWidth
                        //width:
                        height: 20
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 4
                        anchors.bottomMargin: 0
                        layoutDirection: Qt.LeftToRight
                        spacing: 8

                        Text {
                            id: _source
                            height: 25
                            color: "#bfbfbf"
                            text: qsTr("Source :")
                            font.pixelSize: 15
                        }

                        Text {
                            id: _modelName
                            height: 25
                            color: "#bfbfbf"
                            text: qsTr("#Cube")
                            font.pixelSize: 15
                        }

                        Text {
                            id: _statsSpacer
                            height: 25
                            color: "#bfbfbf"
                            text: " || "
                            font.pixelSize: 10
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillHeight: true
                        }

                        Text {
                            id: _viewMode
                            height: 25
                            color: "#bfbfbf"
                            text: viewMode
                            font.pixelSize: 15
                        }

                    }
                }

                RowLayout {
                    id: _ViewModeLayout
                    width: 127
                    height: 35
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 8
                    anchors.topMargin: 5
                    z: 1

                    Switch {
                        id: _viewModeSwitch
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Material.accent: Material.LightBlue
                        z: 2
                        onCheckedChanged: {
                            loadedItem.setCameraMode(checked)
                            if (checked) {
                                viewMode = "view mode : Orthographic View";
                            } else {
                                viewMode = "view mode : Perspective View";
                            }
                        }
                    }

                    Text {
                        id: _viewModeText
                        color: "#f5f5f5"
                        text: "view mode"
                        font.pixelSize: 15
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }
        }

        Rectangle {
            id: footer
            //width: parent.width
            height: 70
            color: "#333333"
            border.color: "#444444"
            Layout.fillHeight: false
            Layout.fillWidth: true

            Text {
                color: "#ffffff"
                text: "Developer : Pulkit"
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 25
                anchors.bottomMargin: 10
                font.pixelSize: 16
            }

            Button {
                id: recButton
                width: 98
                height: 42
                text: qsTr("Load")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 22
                anchors.topMargin: 14
                topInset: 1

                flat: false
                bottomInset: 1
                baselineOffset: 30
                font.weight: Font.Normal
                font.preferShaping: true
                font.kerning: true
                font.pointSize: 14
                highlighted: true

                Material.accent: Material.LightBlue
                Material.roundedScale: Material.SmallScale

                onClicked: {
                    //debugView.visible = true;
                    selectDialogBox.visible = true;
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;matPrevEnvDoc:"SkyBox";matPrevEnvValueDoc:"preview_studio";matPrevModelDoc:"#Sphere"}
D{i:49}D{i:51}D{i:52}
}
##^##*/
