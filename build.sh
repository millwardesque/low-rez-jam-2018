#!/bin/bash
PICOTOOL_DIR=../../picotool

> debug.log.p8l
$PICOTOOL_DIR/p8tool build lrj.p8 --lua game.lua --lua-path="?;?.lua;lib/?.lua"
