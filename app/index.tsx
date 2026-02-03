import { Canvas, useFrame } from '@react-three/fiber';
import { useRef } from 'react';
import { View } from 'react-native';
import { Mesh } from 'three';

function Box(props: any) {
    const mesh = useRef<Mesh>(null!);

    useFrame((state, delta) => {
        mesh.current.rotation.x += delta;
        mesh.current.rotation.y += delta;
    });

    return (
        <mesh
            {...props}
            ref={mesh}
            scale={1.5}>
            <boxGeometry args={[1, 1, 1]} />
            <meshStandardMaterial color={'orange'} />
        </mesh>
    );
}

export default function Index() {
    return (
        <View style={{ flex: 1, backgroundColor: '#000' }}>
            <Canvas>
                <ambientLight intensity={Math.PI / 2} />
                <spotLight position={[10, 10, 10]} angle={0.15} penumbra={1} decay={0} intensity={Math.PI} />
                <pointLight position={[-10, -10, -10]} decay={0} intensity={Math.PI} />
                <Box position={[0, 0, 0]} />
            </Canvas>
        </View>
    );
}
