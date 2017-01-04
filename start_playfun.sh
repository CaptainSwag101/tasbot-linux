#!/bin/bash
terminator -x ./playfun --helper 8000
terminator -x ./playfun --helper 8001
terminator -x ./playfun --helper 8002
terminator -x ./playfun --helper 8003
./playfun --master 8000 8001 8002 8003
