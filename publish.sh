#!/bin/bash

cd ~/myj/

git status | grep -o  "_post.*\.md" | xargs ruby modify.rb

git status
echo "Do you wish to commit this changes?"

# select yn in "Yes" "No"; do
#     case $yn in
#         Yes ) git add . ; git commit -a -m 'publish'; git push; break;;
#         No ) exit;;
#     esac
# done
