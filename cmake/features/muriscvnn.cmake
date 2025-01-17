IF(NOT MURISCVNN_DIR)
    MESSAGE(FATAL_ERROR "Missing value: MURISCVNN_DIR")
ENDIF()

IF(NOT RISCV_VEXT)
    SET(USE_VEXT OFF)
ELSE()
    SET(USE_VEXT ON)
ENDIF()

IF(NOT RISCV_PEXT)
    SET(USE_PEXT OFF)
ELSE()
    SET(USE_PEXT ON)
ENDIF()

IF(NOT MURISCVNN_TOOLCHAIN)
    SET(MURISCVVN_TOOLCHAIN GCC)
    # SET(MURISCVVN_TOOLCHAIN NONE)
ENDIF()

SET(MURISCVNN_INCLUDE_DIRS ${MURISCVNN_DIR}/Include ${MURISCVNN_DIR}/Include/CMSIS/NN/Include)

# TODO: propagarting all toolchain specific vars does not scale well
SET(BUILD_FLAGS "")
IF(RISCV_ARCH)
    SET(BUILD_FLAGS "${BUILD_FLAGS} -march=${RISCV_ARCH}")
ENDIF()
IF(RISCV_ABI)
    SET(BUILD_FLAGS "${BUILD_FLAGS} -mabi=${RISCV_ABI}")
ENDIF()

INCLUDE(ExternalProject)
EXTERNALPROJECT_ADD(
    muriscvnn
    PREFIX muriscvnn
    SOURCE_DIR ${MURISCVNN_DIR}
    CMAKE_ARGS -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -DCMAKE_C_FLAGS:STRING=${BUILD_FLAGS}
               -DCMAKE_CXX_FLAGS:STRING=${BUILD_FLAGS}
               -DUSE_VEXT=${USE_VEXT}
               -DUSE_PEXT=${USE_PEXT}
               -DTOOLCHAIN=${MURISCVNN_TOOLCHAIN}
               -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
               -DENABLE_UNIT_TESTS=OFF
               -DTC_PREFIX=${TC_PREFIX}
               -DEXE_EXT=${EXE_EXT}
               -DRISCV_ARCH=${RISCV_ARCH}
               -DRISCV_ABI=${RISCV_ABI}
               -DARM_CPU=${ARM_CPU}
               -DARM_FLOAT_ABI=${ARM_FLOAT_ABI}
               -DARM_FPU=${ARM_FPU}
    BUILD_COMMAND "${CMAKE_COMMAND}" --build . -j4
    INSTALL_COMMAND ""
)

EXTERNALPROJECT_GET_PROPERTY(muriscvnn BINARY_DIR)
SET(MURISCVNN_LIB ${BINARY_DIR}/Source/libmuriscvnn.a)

# TFLite integration
IF(TFLM_OPTIMIZED_KERNEL_LIB)
    LIST(APPEND TFLM_OPTIMIZED_KERNEL_LIB ${MURISCVNN_LIB})
ELSE()
    SET(TFLM_OPTIMIZED_KERNEL_LIB ${MURISCVNN_LIB})
ENDIF()

IF(TFLM_OPTIMIZED_KERNEL_INCLUDE_DIR)
    LIST(APPEND TFLM_OPTIMIZED_KERNEL_INCLUDE_DIR ${MURISCVNN_INCLUDE_DIRS})
ELSE()
    SET(TFLM_OPTIMIZED_KERNEL_INCLUDE_DIR ${MURISCVNN_INCLUDE_DIRS})
ENDIF()

IF(TFLM_OPTIMIZED_KERNEL_DEPS)
    LIST(APPEND TFLM_OPTIMIZED_KERNEL_DEPS muriscvnn)
ELSE()
    SET(TFLM_OPTIMIZED_KERNEL_DEPS muriscvnn)
ENDIF()

# TVM integration
IF(TVM_EXTRA_LIBS)
    LIST(APPEND TVM_EXTRA_LIBS ${MURISCVNN_LIB})
ELSE()
    SET(TVM_EXTRA_LIBS ${MURISCVNN_LIB})
ENDIF()

IF(TVM_EXTRA_INCS)
    LIST(APPEND TVM_EXTRA_INCS ${MURISCVNN_INCLUDE_DIRS})
ELSE()
    SET(TVM_EXTRA_INCS ${MURISCVNN_INCLUDE_DIRS})
ENDIF()

IF(TVM_EXTRA_DEPS)
    LIST(APPEND TVM_EXTRA_DEPS muriscvnn)
ELSE()
    SET(TVM_EXTRA_DEPS muriscvnn)
ENDIF()
