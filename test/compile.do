puts {
  *****************************
  BIGLARI-COMPILER FOR MODELSIM
  *****************************
}

set library_file_list {
                           design_library {
                                           ../src/util/address_constants.vhd
                                           ../src/memory/register.vhd
                                           ../src/processor/cor_asp.vhd
                           }
                           test_library   {
                                           testbench_corasp.vhd
                           }
}

#Does this installation support Tk?
set tk_ok 1
if [catch {package require Tk}] {set tk_ok 0}

catch {
  vlib work
}

foreach {library file_list} $library_file_list {
  vlib $library
  vmap $library work
  foreach file $file_list {
    if [regexp {.vhdl?$} $file] {
    vcom -93 $file
    } else {
    vlog $file
    }
  }
}

puts {
  *************************************************************************************************
  All files successfully compiled.
  *************************************************************************************************

  Q: wHaT iS rEc0P?????
  A: You asking questions that make NO SENSE

}