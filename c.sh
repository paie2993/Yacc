#!/bin/bash

bison -d lang.y

flex lang.lex

gcc lex.yy.c lang.tab.c -o parse