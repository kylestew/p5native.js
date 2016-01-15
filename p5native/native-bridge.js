
// PROP TYPES - how they map to UI elements
var PropTypeEnum = {
    SLIDER: "slider",
}

// USER can register almost anything here - just needs key/value
// prop value becomes part of props and can be accessed in the global scope
var props = {};
function registerProp(prop) {
    props[prop.key] = prop.value;
    window.webkit.messageHandlers.propRegistration.postMessage(prop);
}

// iOS -> p5.js
function receivePropUpdate(key, value) {
    props[key] = value
}

// p5.js -> iOS
function postPropUpdate(key, value) {
    var msg = {};
    msg[key] = value
    window.webkit.messageHandlers.props.postMessage(msg);
}

// internal p5.js use, passes to bridge
function setProp(key, value) {
    props[key] = value;
    postPropUpdate(key, value);
}

// debug logging bridge: p5.js -> Native
function debugLog(message) {
    window.webkit.messageHandlers.debugLog.postMessage(message);
}
