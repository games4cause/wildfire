import { Canvas, useFrame } from '@react-three/fiber';
import { useRef } from 'react';
import { PanResponder, View } from 'react-native';
import { Group, Mesh } from 'three';

function Sphere(props: any) {
    const mesh = useRef<Mesh>(null!);

    useFrame((state) => {
        // Up-down animation: sin wave based on time
        mesh.current.position.y = Math.sin(state.clock.elapsedTime) * 0.5;
    });

    return (
        <mesh
            {...props}
            ref={mesh}
            scale={1}>
            <sphereGeometry args={[0.5, 32, 32]} />
            <meshStandardMaterial color={'red'} />
        </mesh>
    );
}

function GreenPlane() {
    return (
        <mesh position={[0, -2, 0]} rotation={[-Math.PI / 2, 0, 0]}>
            <planeGeometry args={[5, 5]} />
            <meshStandardMaterial color={'green'} />
        </mesh>
    );
}

function Scene({ targetRotationY }: { targetRotationY: React.MutableRefObject<number> }) {
    const groupRef = useRef<Group>(null!);

    useFrame(() => {
        if (groupRef.current) {
            // Lerp smoothing: current = current + (target - current) * alpha
            // Alpha of 0.1 provides a nice weighted feel
            groupRef.current.rotation.y += (targetRotationY.current - groupRef.current.rotation.y) * 0.1;
        }
    });

    return (
        <group ref={groupRef}>
            <directionalLight position={[5, 5, 5]} intensity={Math.PI} />
            <Sphere position={[0, 0, 0]} />
            <GreenPlane />
        </group>
    );
}

export default function Index() {
    const targetRotationY = useRef(0);
    const previousDx = useRef(0);

    const panResponder = useRef(
        PanResponder.create({
            onStartShouldSetPanResponder: () => true,
            onMoveShouldSetPanResponder: () => true,
            onPanResponderGrant: () => {
                previousDx.current = 0;
            },
            onPanResponderMove: (_, gestureState) => {
                const delta = gestureState.dx - previousDx.current;
                previousDx.current = gestureState.dx;

                // Sensitivity 0.01 (100px = 1 radian)
                targetRotationY.current += delta * 0.01;
            },
        })
    ).current;

    return (
        <View style={{ flex: 1, backgroundColor: '#000' }} {...panResponder.panHandlers}>
            <Canvas
                style={{ flex: 1 }}
                events={null}
                orthographic
                camera={{ zoom: 50, position: [0, 5, 10] }}
            >
                <Scene targetRotationY={targetRotationY} />
            </Canvas>
        </View>
    );
}
