// Learn more https://docs.expo.io/guides/customizing-metro
const { getDefaultConfig } = require('expo/metro-config');

/** @type {import('expo/metro-config').MetroConfig} */
const config = getDefaultConfig(__dirname);

// Ensure cjs and mjs are resolved
config.resolver.sourceExts.push('cjs', 'mjs');

// Add support for 3D assets
config.resolver.assetExts.push('glb', 'gltf', 'png', 'jpg');

module.exports = config;
