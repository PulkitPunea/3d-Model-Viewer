import QtQuick
import QtQuick.Controls
import QtQuick3D
import QtQuick3D.Helpers

import "shaders"
import "images"

Item {
    id: modelObjectRoot
    anchors.fill: parent

    //Show elements property
    property bool isGrid: false
    property bool isAxis: false
    property bool isSkybox: false
    property bool isDirectionalLight: true
    property bool isUV: false

    //Rendering Features property
    property bool isAO: false
    property bool isWireframe: false
    property bool isFog: false

    //Advanced Debugging property
    property bool advanceDebugV: false

    //Load Model Signal
    signal loadModelSignal(string modelSource)

    //Set Camera Modes
    signal setCameraMode(bool state)

    //Show Elements Signal
    signal showGrid(bool state)
    signal showAxis(bool state)
    signal showSkybox(bool state)
    signal showDirectionalLight(bool state)
    signal showUV(bool state)

    //Rendering Features Signal
    signal showAO(bool state)
    signal enableWireframe(bool state)
    signal showFog(bool state)
    signal setAQ(int id)
    signal setMO(int id)

    //Advanced Debugging Singal
    signal showAdvanceDebug(bool state)

    //Load Model Handler Funtion
    function handleLoadModelSignal(modelSource) {
        console.log(modelSource); // Use the parameter here
        modelObject.source = modelSource;
        console.log("------Model Loaded form Source.------")
    }

    //Camera Mode handler function
    function handleSetCameraMode(state) {
        if (state) {
            orbitCameraController.camera = orthographicCamera
            orthographicCamera.visible = true
            perspectiveCamera.visible = false
        } else {
            orbitCameraController.camera = perspectiveCamera
            perspectiveCamera.visible = true
            orthographicCamera.visible = false
        }
    }

    //Show Elements Handler Functions
    function handleShowGrid(state) {
        isGrid = state;
    }

    function handleShowAxis(state) {
        isAxis = state;
    }

    function handleShowSkybox(state) {
        if(state) {
            sceneEnvironment.backgroundMode = SceneEnvironment.SkyBox
        }
        else {
            sceneEnvironment.backgroundMode = SceneEnvironment.Transparent
        }
    }

    function handleShowDirectionalLight(state) {
        isDirectionalLight = state
    }

    function handleShowUV(state){
        if (state) {
            modelObject.materials = cMaterial
        } else {
            modelObject.materials = pMaterial
        }
    }

    //Rendering Features Handler Functions
    function handleShowAO(state) {
        isAO = state
    }

    function handleEnableWireframe(state) {
        isWireframe = state;
    }

    function handleShowFog(state){
        isFog = state
    }

    function handleSetAQ(id) {
        if(id === 0) {
            sceneEnvironment.antialiasingQuality = SceneEnvironment.Medium
        } else if(id === 1) {
            sceneEnvironment.antialiasingQuality = SceneEnvironment.High
        } else if(id === 2) {
            sceneEnvironment.antialiasingQuality = SceneEnvironment.VeryHigh
        } else {
            console.log("No valid Antialiasing Quaity id found !")
        }
    }

    function handleSetMO(id) {
        if (id === 0) {
            debug.materialOverride = DebugSettings.None
        } else if (id === 1) {
            debug.materialOverride = DebugSettings.BaseColor
        } else if (id === 2) {
            debug.materialOverride = DebugSettings.Roughness
        } else if (id === 3) {
            debug.materialOverride = DebugSettings.Metalness
        } else if (id === 4) {
            debug.materialOverride = DebugSettings.Normals
        } else {
            console.log("No valid Material Override id found !")
        }
    }

    //Advanced Debugging Handler Functions
    function handleAdvanceDebug(state) {
        advanceDebugV = state;
    }

    //Load Model Signal Linker
    onLoadModelSignal: { handleLoadModelSignal(modelSource) }

    //Camera Mode Signal Linker
    onSetCameraMode: { handleSetCameraMode(state) }

    //Show Elements Signal Linker
    onShowGrid: { handleShowGrid(state) }
    onShowAxis: { handleShowAxis(state) }
    onShowSkybox: { handleShowSkybox(state) }
    onShowDirectionalLight: { handleShowDirectionalLight(state) }
    onShowUV: { handleShowUV(state) }

    //Rendering Features Signal Linker
    onShowAO: { handleShowAO(state) }
    onEnableWireframe: { handleEnableWireframe(state) }
    onShowFog: { handleShowFog(state) }
    onSetAQ: { handleSetAQ(id) }
    onSetMO: { handleSetMO(id) }

    //Advanced Debugging Signal Linker
    onShowAdvanceDebug: { handleAdvanceDebug(state) }

    View3D {
        id: view3D
        focus: true
        anchors.fill: parent
        environment: sceneEnvironment

        SceneEnvironment {
            id: sceneEnvironment
            clearColor: "#ff0000"

            backgroundMode: SceneEnvironment.Transparent

            lightProbe: Texture {
                textureData: ProceduralSkyTextureData {
                    textureQuality: ProceduralSkyTextureData.SkyTextureQualityLow
                }
            }

            fog: fog
            aoEnabled: isAO
            antialiasingQuality: SceneEnvironment.Medium
            antialiasingMode: SceneEnvironment.MSAA

            debugSettings: DebugSettings {
                id: debug
                materialOverride: DebugSettings.None
                wireframeEnabled: isWireframe
            }
        }

        PerspectiveCamera {
            id: perspectiveCamera
            visible: true
            z: 350
        }

        OrthographicCamera {
            id: orthographicCamera
            visible: false
            z: 500
        }

        OrbitCameraController {
            id: orbitCameraController
            smooth: false
            origin: modelObject
            camera: perspectiveCamera
            yInvert: false
            xInvert: true
            panEnabled: true
            mouseEnabled: true
            ySpeed: 0.4
            xSpeed: 0.4
        }

        Node {
            id: scene
            DirectionalLight {
                id: directionalLight
                visible: isDirectionalLight
                position: Qt.vector3d(-500, 500, -100)
                color: "#ffffff"
                castsShadow: false
                ambientColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
            }

            Model {
                id: modelObject
                source: "#Cube"
                eulerRotation.y: 0
                eulerRotation.x: 0
                eulerRotation.z: 0
                materials: pMaterial

                PrincipledMaterial {
                    id:pMaterial
                }

                //UV Visualisation
                CustomMaterial {
                    id:cMaterial
                    fragmentShader: "shaders/fragmentShader.frag"
                    shadingMode: CustomMaterial.Shaded
                    property TextureInput textureMap: TextureInput {
                        texture: Texture {
                            id: texID
                            source: "images/grid.jpg"
                        }
                    }
                }

                AxisHelper {
                    id: axisHelper
                    enableAxisLines: isAxis
                    enableXYGrid: false
                    enableXZGrid: isGrid
                }
            }

            Fog {
                id: fog
                depthNear: 0
                depthEnabled: true
                enabled: isFog
            }
        }
    }

    DebugView {
        id: advanceDebug
        source: view3D
        x: 824
        y: 50
        visible: advanceDebugV
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 30
        resourceDetailsVisible: false
    }

    Item {
        id: __materialLibrary__

        PrincipledMaterial {
            id: principledMaterial
            objectName: "New Material"
        }
    }
}

/*##^##
Designer {
    D{i:0;matPrevEnvDoc:"SkyBox";matPrevEnvValueDoc:"preview_studio";matPrevModelDoc:"#Sphere"}
D{i:1;cameraSpeed3d:25;cameraSpeed3dMultiplier:1}
}
##^##*/
