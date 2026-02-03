
import 'react';

declare module '@react-three/fiber' {
    import * as React from 'react';
    export const Canvas: React.ComponentType<any>;
    export const useFrame: (callback: (state: any, delta: number) => void, renderPriority?: number) => null;
}

declare module 'react' {
    namespace JSX {
        interface IntrinsicElements {
            meshStandardMaterial: any;
            boxGeometry: any;
            mesh: any;
            ambientLight: any;
            spotLight: any;
            pointLight: any;
            [elemName: string]: any;
        }
    }
}
