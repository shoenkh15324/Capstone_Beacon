################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/lib/beacon_f103/USB_DEVICE/Target/usbd_conf.c 

OBJS += \
./src/lib/beacon_f103/USB_DEVICE/Target/usbd_conf.o 

C_DEPS += \
./src/lib/beacon_f103/USB_DEVICE/Target/usbd_conf.d 


# Each subdirectory must supply rules for building sources it contributes
src/lib/beacon_f103/USB_DEVICE/Target/%.o src/lib/beacon_f103/USB_DEVICE/Target/%.su src/lib/beacon_f103/USB_DEVICE/Target/%.cyclo: ../src/lib/beacon_f103/USB_DEVICE/Target/%.c src/lib/beacon_f103/USB_DEVICE/Target/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DSTM32F103xB -c -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/ap" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/bsp" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/common" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/common/hw/include" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/hw" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/Drivers/CMSIS/Include" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/Drivers/CMSIS/Device/ST/STM32F1xx/Include" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/Drivers/STM32F1xx_HAL_Driver/Inc" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/Middlewares/ST/STM32_USB_Device_Library/Core/Inc" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/USB_DEVICE/App" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/USB_DEVICE/Target" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/common/core" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-src-2f-lib-2f-beacon_f103-2f-USB_DEVICE-2f-Target

clean-src-2f-lib-2f-beacon_f103-2f-USB_DEVICE-2f-Target:
	-$(RM) ./src/lib/beacon_f103/USB_DEVICE/Target/usbd_conf.cyclo ./src/lib/beacon_f103/USB_DEVICE/Target/usbd_conf.d ./src/lib/beacon_f103/USB_DEVICE/Target/usbd_conf.o ./src/lib/beacon_f103/USB_DEVICE/Target/usbd_conf.su

.PHONY: clean-src-2f-lib-2f-beacon_f103-2f-USB_DEVICE-2f-Target

