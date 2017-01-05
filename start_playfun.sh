#!/bin/bash
terminator --new-tab -x ./playfun --helper 8000
terminator --new-tab -x ./playfun --helper 8001
terminator --new-tab -x ./playfun --helper 8002
terminator --new-tab -x ./playfun --helper 8003
./playfun --master 8000 8001 8002 8003
