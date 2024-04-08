################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/hw/driver/beacon.c \
../src/hw/driver/cdc.c \
../src/hw/driver/cli.c \
../src/hw/driver/led.c \
../src/hw/driver/uart.c 

OBJS += \
./src/hw/driver/beacon.o \
./src/hw/driver/cdc.o \
./src/hw/driver/cli.o \
./src/hw/driver/led.o \
./src/hw/driver/uart.o 

C_DEPS += \
./src/hw/driver/beacon.d \
./src/hw/driver/cdc.d \
./src/hw/driver/cli.d \
./src/hw/driver/led.d \
./src/hw/driver/uart.d 


# Each subdirectory must supply rules for building sources it contributes
src/hw/driver/%.o src/hw/driver/%.su src/hw/driver/%.cyclo: ../src/hw/driver/%.c src/hw/driver/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DSTM32F103xB -c -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/ap" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/bsp" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/common" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/common/hw/include" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/hw" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/Drivers/CMSIS/Include" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/Drivers/CMSIS/Device/ST/STM32F1xx/Include" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/Drivers/STM32F1xx_HAL_Driver/Inc" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/Middlewares/ST/STM32_USB_Device_Library/Core/Inc" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/USB_DEVICE/App" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/lib/beacon_f103/USB_DEVICE/Target" -I"C:/Users/mok07/Desktop/Study/Capstone/beacon/beacon_fw/src/common/core" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-src-2f-hw-2f-driver

clean-src-2f-hw-2f-driver:
	-$(RM) ./src/hw/driver/beacon.cyclo ./src/hw/driver/beacon.d ./src/hw/driver/beacon.o ./src/hw/driver/beacon.su ./src/hw/driver/cdc.cyclo ./src/hw/driver/cdc.d ./src/hw/driver/cdc.o ./src/hw/driver/cdc.su ./src/hw/driver/cli.cyclo ./src/hw/driver/cli.d ./src/hw/driver/cli.o ./src/hw/driver/cli.su ./src/hw/driver/led.cyclo ./src/hw/driver/led.d ./src/hw/driver/led.o ./src/hw/driver/led.su ./src/hw/driver/uart.cyclo ./src/hw/driver/uart.d ./src/hw/driver/uart.o ./src/hw/driver/uart.su

.PHONY: clean-src-2f-hw-2f-driver

