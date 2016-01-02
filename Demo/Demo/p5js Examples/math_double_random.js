// http://p5js.org/examples/examples/Math_Double_Random.php

var totalPts = 300;
var steps = totalPts + 1;

function setup() {
    createCanvas(710, 400);
    stroke(255);
    frameRate(1);
}

function draw() {
    background(0);
    var rand = 0;
    for  (var i = 1; i < steps; i++) {
        point( (width/steps) * i, (height/2) + random(-rand, rand) );
        rand += random(-5, 5);
    }
}