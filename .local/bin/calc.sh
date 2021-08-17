#!/bin/sh

math="$1"
scale="${2:-0}"

bc -s << MATH

scale = 0
t = 10 ^ $scale

scale = $scale + 1
m = $math

r = 0
if (m < 0) r = -0.5
if (m > 0) r = 0.5

x = m * t + r

scale = $scale
x / t

MATH
