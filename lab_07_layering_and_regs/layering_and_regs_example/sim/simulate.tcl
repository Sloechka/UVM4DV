global env

if {[info exists env(DUMPDB)]} {
  set DB_EN $env(DUMPDB)
} else {
  set DB_EN 0
}
puts "DB_EN=$DB_EN"

if {[info exists env(TOP_LEVEL_NAME)]} {
  set TOP_LEVEL_NAME $env(TOP_LEVEL_NAME)
} else {
  set TOP_LEVEL_NAME 0
}
puts "TOP_LEVEL_NAME=$TOP_LEVEL_NAME"


proc create_db {} {
  global TOP_LEVEL_NAME
  set assert_1164_warnings no
  database -open [set TOP_LEVEL_NAME].shm -into [set TOP_LEVEL_NAME].shm -event -default -compress
  probe -create -shm $TOP_LEVEL_NAME -all -variables -database [set TOP_LEVEL_NAME].shm -memories -depth all
}


if {$DB_EN == 1} {
  create_db
}

run

exit
