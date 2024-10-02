#! /bin/sh

assert() {
    [ $? -ne ${2-0} ] && echo "$1 test failed" && exit 1
}

cp input/input.html out.html
../swsu-html template input/head.html out.html
head -2 out.html | diff -q - input/head.html
assert "Template"
rm out.html

cp input/input.html out.html
../swsu-html srcset out.html
grep image.webp out.html | grep srcset -q
assert "Srcset space"
grep picture.webp out.html | grep srcset -v -q
assert "Srcset endtag"
grep number11 out.html | grep srcset -v -q
assert "Srcset filename number"
rm out.html

cp input/input.jpg out.jpg
../swsu-img webp out.jpg out.webp
file --mime out.webp | grep 'out.webp: image/webp; charset=binary' -q
assert "Webp conversion"
rm out.jpg

../swsu-img watermark out.webp

../swsu-img srcset out.webp
test -e out-200.webp
assert "Srcset 200"
test -e out-400.webp
assert "Srcset 400"
test -e out-800.webp
assert "Srcset 800"
test -e out-1200.webp
assert "Srcset 1200"
rm out.webp
rm out-200.webp
rm out-400.webp
rm out-800.webp

