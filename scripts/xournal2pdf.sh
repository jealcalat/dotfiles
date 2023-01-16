#!/bin/sh

xournal2pdf(){
  xournalpp -p $1 $2
}

xournal2pdfBulk(){
  for file in *.xopp; do
    newFile="${file%.*}.pdf";
    xournal2pdf $newFile $file;
  done
}