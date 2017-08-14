#!/bin/bash

git status | grep -o  "_post.*\.md" | xargs -I {} ruby ./modify.rb {}
