var props = {
    scale: 0.75,
    hello: "world"
}

function setup() {
    createCanvas(640, 640);
    
    // pass initial prop values to iOS
    window.webkit.messageHandlers.props.postMessage(props)
    
    // TODO: abstract out of code?
//    registerProps(props);
}

// TODO: abstract into library
function setProp(key, value) {
    props[key] = value
}

function postProp(key, value) {
    var msg = {};
    msg[key] = value
    window.webkit.messageHandlers.props.postMessage(msg);
}

function draw() {
    background(127);
    noStroke();
    
    rect(0, 0, props.scale*width, props.scale*height);
    
    postProp("frameCount", frameCount);
}
