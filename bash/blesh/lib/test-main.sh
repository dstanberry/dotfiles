# this script is a part of blesh (https://github.com/akinomyoga/ble.sh) under BSD-3-Clause license
ble-import lib/core-test
ble/test/start-section 'main' 14
(
  ble/test ble/util/put a     stdout=a
  ble/test ble/util/print a   stdout=a
  ble/test ble/util/put a b   stdout='a b'
  ble/test ble/util/print a b stdout='a b'
  ble/test 'ble/util/put a b; ble/util/put c d' \
           stdout='a bc d'
  ble/test 'ble/util/print a b; ble/util/print c d' \
           stdout='a b' \
           stdout='c d'
)
(
  function ble/test/dummy-1 { true; }
  function ble/test/dummy-2 { true; }
  function ble/test/dummy-3 { true; }
  ble/test ble/bin#has ble/test/dummy-1
  ble/test ble/bin#has ble/test/dummy-{1..3}
  ble/test ble/bin#has ble/test/dummy-0 exit=1
  ble/test ble/bin#has ble/test/dummy-{0..2} exit=1
)
(
  ble/test/chdir
  mkdir -p ab/cd/ef
  touch ab/cd/ef/file.txt
  ln -s ef/file.txt ab/cd/link1
  ln -s ab link.d
  ln -s link.d/cd/link1 f.txt
  ble/test '
    ble/util/readlink f.txt
    [[ $ret != /* ]] && ret=${PWD%/}/$ret' \
    ret="${PWD%/}/ab/cd/ef/file.txt"
  ble/test/rmdir
)
(
  ble/test '[[ -d $_ble_base ]]'
  ble/test '[[ -d $_ble_base_run ]]'
  ble/test '[[ -d $_ble_base_cache ]]'
)
ble/test/end-section
