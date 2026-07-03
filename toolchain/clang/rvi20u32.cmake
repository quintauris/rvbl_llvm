#[[
  Copyright 2026 Quintauris GmbH
  Licensed under the Apache License, Version 2.0 (the "License").
  https://www.apache.org/licenses/LICENSE-2.0
]]

include(${CMAKE_CURRENT_LIST_DIR}/toolchain.cmake)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv32)
set(CMAKE_CROSSCOMPILING 1)

if(NOT DEFINED arch AND NOT DEFINED abi)
  #[[
    From
    https://docs.riscv.org/reference/rva20-rvi20-rva22/rvi20.html#5-1-1-rvi20u32

    - Mandatory extensions:

    Not applicable.

    - Optional extensions:

    [x] M           Integer multiply and divide instructions
    [x] A           Atomic instructions
    [ ] F           Single-precision floating-point instructions
    [ ] D           Double-precision floating-point instructions
    [ ] C           Compressed instructions
    [x] Zifrencei   Instruction fence
    [x] Zicntr      Architectural performance counters
    [ ] Zihpm       Programmable hardware performance counters

    - Other

    [x] Zicsr       Control/status register access instructions
  ]]
  set(arch "rv32ima_zicntr_zifencei_zicsr")
  set(abi "ilp32")
endif()

set(CMAKE_C_COMPILER_TARGET riscv32)
set(CMAKE_C_COMPILER_ABI ilp32)
set(CMAKE_C_COMPILER_LINKER_ID GNU)
set(rvbl_linker_id ${CMAKE_C_COMPILER_LINKER_ID})
set(rvbl_linker_nostdlib -nostdlib)
set(rvbl_elf_copy_parameters "-O" "binary")
set(rvbl_toolchain_specific_suffix ".gnu")
set(CMAKE_C_COMPILER_LINKER_TARGET elf32lriscv)
set(CMAKE_C_FLAGS
    "--target=riscv32 -march=${arch} -mabi=${abi} -std=c${CMAKE_C_STANDARD} \
    -msmall-data-limit=0 -fdata-sections -ffunction-sections")
set(CMAKE_C_LINK_EXECUTABLE
    "<CMAKE_LINKER> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> \
    <LINK_LIBRARIES>")
set(CMAKE_EXECUTABLE_SUFFIX_C ".elf")

set(CMAKE_ASM_COMPILER_TARGET ${CMAKE_C_COMPILER_TARGET})
set(CMAKE_ASM_COMPILER_ABI ${CMAKE_C_COMPILER_ABI})
set(CMAKE_ASM_COMPILER_LINKER_ID ${CMAKE_C_COMPILER_LINKER_ID})
set(CMAKE_ASM_COMPILER_LINKER_TARGET elf32lriscv)
set(CMAKE_ASM_FLAGS
    "--target=riscv32 -march=${arch} -mabi=${abi} -x assembler-with-cpp")
set(CMAKE_ASM_FLAGS_RELEASE "")
set(CMAKE_ASM_LINK_EXECUTABLE
    "<CMAKE_LINKER> <CMAKE_ASM_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> \
    <LINK_LIBRARIES>")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

block()
set(prefix "-L ")
set(dirs $<TARGET_PROPERTY:LINKER_SEARCH_DIRECTORIES>)
add_link_options("-T" "$<TARGET_PROPERTY:LINKER_SCRIPT>" "--gc-sections"
                 $<LIST:TRANSFORM,${dirs},PREPEND,SHELL:${prefix}>)
endblock()

install(FILES ${CMAKE_CURRENT_LIST_FILE} DESTINATION cmake/toolchain)
