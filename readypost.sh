#!/bin/bash

git status | grep -o  "_post.*\.md" | xargs -I {} ./modify.rb {}
