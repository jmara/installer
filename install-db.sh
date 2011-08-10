#!/bin/bash

echo "Dbserver install ..."
s=$(cat db.pkglist)
aptitude install $s
