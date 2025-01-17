SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_PROCESSOR Pulp)

SET(RISCV_ELF_GCC_PREFIX
    ""
    CACHE PATH "install location for riscv-gcc toolchain"
)
SET(RISCV_ELF_GCC_BASENAME
    "riscv32-unknown-elf-"
    CACHE STRING "base name of the toolchain executables"
)
SET(RISCV_ARCH
    "rv32imac"
    CACHE STRING "march argument to the compiler"
)
# set(RISCV_ARCH "rv32imac" CACHE STRING "march argument to the compiler")
SET(RISCV_ABI
    "ilp32"
    CACHE STRING "mabi argument to the compiler"
)
SET(TC_PREFIX "${RISCV_ELF_GCC_PREFIX}/bin/${RISCV_ELF_GCC_BASENAME}-")

# SET(GVSOC_BASIC_CMAKE_DIR
#     ""
#     CACHE STRING "Directory of GVSOC basic cmake directory"
# )

# SET(GVSOC_PULP_TC_DIR ${ETISS_DIR}/examples/SW/riscv/cmake)
# ADD_DEFINITIONS(-DGVSOC_PULP_NO_GPIO)

# SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${GVSOC_BASIC_CMAKE_DIR}")
# IF(NOT GVSOC_PULPISSIMO_ROM_START)
#     SET(GVSOC_PULPISSIMO_ROM_START 0x0)
# ENDIF()
# IF(NOT GVSOC_PULPISSIMO_ROM_SIZE)
#     SET(GVSOC_PULPISSIMO_ROM_SIZE 0x100000)
# ENDIF()
# IF(NOT GVSOC_PULPISSIMO_RAM_START)
#     SET(GVSOC_PULPISSIMO_RAM_START 0x100000)
# ENDIF()
# IF(NOT GVSOC_PULPISSIMO_RAM_SIZE)
#     SET(GVSOC_PULPISSIMO_RAM_SIZE 0x200000)
# ENDIF()
# SET(GVSOC_PULPISSIMO_MIN_STACK_SIZE 0x4000)
# SET(GVSOC_PULPISSIMO_MIN_HEAP_SIZE 0x4000)
# SET(ETISS_LOGGER_ADDR 0xf0000000)

INCLUDE(targets/gvsoc/PulpissimoTarget)
MACRO(COMMON_ADD_LIBRARY TARGET_NAME)
    ADD_LIBRARY_GVSOC_PULPISSIMO(${TARGET_NAME} ${ARGN})
ENDMACRO()
MACRO(COMMON_ADD_EXECUTABLE TARGET_NAME)
    SET(ARGS "${ARGN}")
    SET(SRC_FILES ${ARGS})
    ADD_EXECUTABLE_GVSOC_PULPISSIMO(${TARGET_NAME} ${ARGN})
ENDMACRO()

ADD_DEFINITIONS(-march=${RISCV_ARCH})
ADD_DEFINITIONS(-mabi=${RISCV_ABI})

IF(RISCV_VEXT)
    ADD_DEFINITIONS(-DUSE_VEXT)
ENDIF()
