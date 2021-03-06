LOCAL_PATH := $(call my-dir)

# When zero we link against libmmcamera; when 1, we dlopen libmmcamera.
DLOPEN_LIBMMCAMERA := 1

include $(CLEAR_VARS)

LOCAL_CFLAGS := -DDLOPEN_LIBMMCAMERA=$(DLOPEN_LIBMMCAMERA)

ifeq ($(strip $(TARGET_USES_ION)), true)
    LOCAL_CFLAGS += -DUSE_ION
endif

ifeq ($(TARGET_USES_MEDIA_EXTENSIONS),true)
    LOCAL_CFLAGS += -DUSE_NATIVE_HANDLE_SOURCE
endif

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
    LOCAL_CFLAGS += -DUSE_QCOM_ION_MASK_VARIANT
endif

LOCAL_CFLAGS += \
    -DCAMERA_ION_HEAP_ID=ION_IOMMU_HEAP_ID \
    -DCAMERA_ZSL_ION_HEAP_ID=ION_IOMMU_HEAP_ID \
    -DCAMERA_GRALLOC_HEAP_ID=GRALLOC_USAGE_PRIVATE_IOMMU_HEAP \
    -DCAMERA_GRALLOC_FALLBACK_HEAP_ID=GRALLOC_USAGE_PRIVATE_SYSTEM_HEAP \
    -DCAMERA_ION_FALLBACK_HEAP_ID=ION_IOMMU_HEAP_ID \
    -DCAMERA_ZSL_ION_FALLBACK_HEAP_ID=ION_IOMMU_HEAP_ID \
    -DCAMERA_GRALLOC_CACHING_ID=0 \
    -DNUM_PREVIEW_BUFFERS=4 \
    -DHW_ENCODE \
    -D_ANDROID_

# Uncomment below line to enable smooth zoom
#LOCAL_CFLAGS += -DCAMERA_SMOOTH_ZOOM

# Uncomment below line to close native handles on releaseRecordingFrame
LOCAL_CFLAGS += -DHAL_CLOSE_NATIVE_HANDLES

LOCAL_SRC_FILES := \
    QCameraHAL.cpp \
    QCameraHWI.cpp \
    QCameraHWI_Mem.cpp \
    QCameraHWI_Parm.cpp\
    QCameraHWI_Preview.cpp \
    QCameraHWI_Record.cpp \
    QCameraHWI_Still.cpp \
    QCameraParameters.cpp \
    QCameraStream.cpp \
    QualcommCamera2.cpp

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/mm-camera-interface \
    $(call project-path-for,qcom-media)/mm-core/inc \
    $(call project-path-for,qcom-media)/libstagefrighthw \
    $(call project-path-for,qcom-display)/libgralloc \
    $(call project-path-for,qcom-display)/libgenlock \
    frameworks/native/include/media/hardware

# Kernel headers
LOCAL_HEADER_LIBRARIES := generated_kernel_headers

LOCAL_SHARED_LIBRARIES := libutils libui libcamera_client libcamera_metadata liblog libcutils libbinder libnativewindow
LOCAL_SHARED_LIBRARIES += libgenlock libmmcamera_interface
LOCAL_SHARED_LIBRARIES += android.hidl.token@1.0-utils android.hardware.graphics.bufferqueue@1.0

ifneq ($(DLOPEN_LIBMMCAMERA),1)
    LOCAL_SHARED_LIBRARIES += liboemcamera
else
    LOCAL_SHARED_LIBRARIES += libdl
endif

LOCAL_CFLAGS += -Wall -Werror

LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE := camera.mako

include $(BUILD_SHARED_LIBRARY)

include $(LOCAL_PATH)/mm-camera-interface/Android.mk
