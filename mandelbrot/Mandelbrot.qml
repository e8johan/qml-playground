/*
 * Copyright (c) 2015, Johan Thelin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * * Neither the name of qml-playground nor the names of its
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import QtQuick 2.3

ShaderEffect {
    property int iterations: 30
    property point origin: Qt.point(0, 0)
    property real scale: 1.0

    property real _scale: 1.0/scale
    property point _origin: Qt.point(origin.x/width/scale, origin.y/height/scale)

    /* Adapted from http://nuclear.mutantstargoat.com/articles/sdr_fract/ */
    fragmentShader: "
        varying highp vec2 qt_TexCoord0;
        uniform highp vec2 _origin;
        uniform highp float _scale;
        uniform highp int iterations;

        void main() {
            highp vec2 z, c;

            c.x = 1.3333 * (qt_TexCoord0.x - 0.5) * _scale - _origin.x;
            c.y = (qt_TexCoord0.y - 0.5) * _scale - _origin.y;

            int i;
            z = c;
            for(i=0; i<iterations; i++) {
                highp float x = (z.x * z.x - z.y * z.y) + c.x;
                highp float y = (z.y * z.x + z.x * z.y) + c.y;

                if((x * x + y * y) > 4.0) break;
                z.x = x;
                z.y = y;
            }

            gl_FragColor = vec4((iterations==i?0.0:float(i) / float(iterations)), 0.0, 0.0, 1.0);
        }"
}
