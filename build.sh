#!/bin/bash
cd src
moonc -t ../lib .
cd ..
cp -rf ./lib/pop/* ./demo/pop/
