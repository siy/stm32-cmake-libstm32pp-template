# TODO: Add support for external RAM

IF((NOT STM32_CCRAM_SIZE) OR (STM32_CCRAM_SIZE STREQUAL "0K"))
  SET(STM32_CCRAM_DEF "")
  SET(STM32_CCRAM_SECTION "")
ELSE()
  SET(STM32_CCRAM_DEF "  CCMRAM (rw) : ORIGIN = ${STM32_CCRAM_ORIGIN}, LENGTH = ${STM32_CCRAM_SIZE}\n")
  SET(STM32_CCRAM_SECTION 
  "  _siccmram = LOADADDR(.ccmram)\;\n"
  "  .ccmram :\n"
  "  {"
  "    . = ALIGN(4)\;\n"
  "    _sccmram = .\;\n"
  "    *(.ccmram)\n"
  "    *(.ccmram*)\n"
  "    . = ALIGN(4)\;\n"
  "    _eccmram = .\;\n"
  "  } >CCMRAM AT> FLASH\n"
  )
ENDIF()

SET(STM32_LINKER_SCRIPT_TEXT "\n"
  "/*******************************************************************************\n"
  "*\n"
  "* Copyright (C) 2012 Jorge Aparicio <jorge.aparicio.r@gmail.com>\n"
  "* Changes Copyright (C) 2018 Sergiy Yevtushenko <sergiy.yevtushenko@gmail.com>\n"
  "*\n"
  "* This file is part of stm32-cmake-libstm32pp-template.\n"
  "*\n"
  "* stm32-cmake-libstm32pp-template is free software: you can redistribute it and/or\n"
  "* modify it under the terms of the GNU General Public License as published by the Free\n"
  "* Software Foundation, either version 3 of the License, or (at your option)\n"
  "* any later version.\n"
  "*\n"
  "* stm32-cmake-libstm32pp-template is distributed in the hope that it will be useful,\n"
  "* but WITHOUT ANY WARRANTY\; without even the implied warranty of MERCHANTABILITY or\n"
  "* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for\n"
  "* more details.\n"
  "*\n"
  "* You should have received a copy of the GNU General Public License along\n"
  "* with bareCortexM. If not, see <http://www.gnu.org/licenses/>.\n"
  "*\n"
  "******************************************************************************/\n"
  "\n"
  "MEMORY\n"
  "{\n"
  " FLASH (rx)    : ORIGIN = ${STM32_FLASH_ORIGIN}, LENGTH = ${STM32_FLASH_SIZE}\n"
  " RAM (rwx)     : ORIGIN = ${STM32_RAM_ORIGIN}, LENGTH = ${STM32_RAM_SIZE}\n"
  "}\n"
  "\n"
  "/* Config Libraries */\n"
  "GROUP(libgcc.a libc.a libm.a libnosys.a)\n"
  "\n"
  "ENTRY(resetHandler)\n"
  "\n"
  "SECTIONS\n"
  "{\n"
  "	.text :\n"
  "	{\n"
  "		KEEP(*(.exception_vector))\n"
  "		KEEP(*(.interrupt_vector))\n"
  "		*(.text*)\n"
  "\n"
  "		KEEP(*(.init))\n"
  "		KEEP(*(.fini))\n"
  "\n"
  "		/* .ctors */\n"
  "		*crtbegin.o(.ctors)\n"
  "		*crtbegin?.o(.ctors)\n"
  "		*(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)\n"
  "		*(SORT(.ctors.*))\n"
  "		*(.ctors)\n"
  "\n"
  "		/* .dtors */\n"
  " 		*crtbegin.o(.dtors)\n"
  " 		*crtbegin?.o(.dtors)\n"
  " 		*(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors)\n"
  " 		*(SORT(.dtors.*))\n"
  " 		*(.dtors)\n"
  "\n"
  "		*(.rodata*)\n"
  "\n"
  "		KEEP(*(.eh_frame*))\n"
  "	} > FLASH\n"
  "\n"
  "	.ARM.extab :\n"
  "	{\n"
  "		*(.ARM.extab* .gnu.linkonce.armextab.*)\n"
  "	} > FLASH\n"
  "\n"
  "	__exidx_start = .\;\n"
  "	.ARM.exidx :\n"
  "	{\n"
  "		*(.ARM.exidx* .gnu.linkonce.armexidx.*)\n"
  "	} > FLASH\n"
  "	__exidx_end = .\;\n"
  "\n"
  "	__etext = .\;\n"
  "\n"
  "	.data : AT (__etext)\n"
  "	{\n"
  "		__data_start__ = .\;\n"
  "		*(vtable)\n"
  "		*(.data*)\n"
  "\n"
  "		. = ALIGN(4)\;\n"
  "		/* preinit data */\n"
  "		PROVIDE_HIDDEN (__preinit_array_start = .)\;\n"
  "		KEEP(*(.preinit_array))\n"
  "		PROVIDE_HIDDEN (__preinit_array_end = .)\;\n"
  "\n"
  "		. = ALIGN(4)\;\n"
  "		/* init data */\n"
  "		PROVIDE_HIDDEN (__init_array_start = .)\;\n"
  "		KEEP(*(SORT(.init_array.*)))\n"
  "		KEEP(*(.init_array))\n"
  "		PROVIDE_HIDDEN (__init_array_end = .)\;\n"
  "\n"
  "		. = ALIGN(4)\;\n"
  "		/* finit data */\n"
  "		PROVIDE_HIDDEN (__fini_array_start = .)\;\n"
  "		KEEP(*(SORT(.fini_array.*)))\n"
  "		KEEP(*(.fini_array))\n"
  "		PROVIDE_HIDDEN (__fini_array_end = .)\;\n"
  "\n"
  "		. = ALIGN(4)\;\n"
  "		/* All data end */\n"
  "		__data_end__ = .\;\n"
  "\n"
  "	} > RAM\n"
  "\n"
  "${STM32_CCRAM_SECTION}"
  "\n"
  "	.bss :\n"
  "	{\n"
  "		__bss_start__ = .\;\n"
  "		*(.bss*)\n"
  "		*(COMMON)\n"
  "		__bss_end__ = .\;\n"
  "	} > RAM\n"
  "\n"
  "	.heap :\n"
  "	{\n"
  "		__end__ = .\;\n"
  "		end = __end__\;\n"
  "		*(.heap*)\n"
  "		__HeapLimit = .\;\n"
  "	} > RAM\n"
  "\n"
  "	/* .stack_dummy section doesn't contains any symbols. It is only\n"
  "	 * used for linker to calculate size of stack sections, and assign\n"
  "	 * values to stack symbols later */\n"
  "	.stack_dummy :\n"
  "	{\n"
  "		*(.stack*)\n"
  "	} > RAM\n"
  "\n"
  "	/* Set stack top to end of RAM, and stack limit move down by\n"
  "	 * size of stack_dummy section */\n"
  "	__StackTop = ORIGIN(RAM) + LENGTH(RAM)\;\n"
  "	__StackLimit = __StackTop - SIZEOF(.stack_dummy)\;\n"
  "	PROVIDE(__stack = __StackTop)\;\n"
  "\n"
  "	/* Check if data + heap + stack exceeds RAM limit */\n"
  "	ASSERT(__StackLimit >= __HeapLimit, \"region RAM overflowed with stack\")\n"
  "}\n"
)
