.PHONY: default
default: all

XMLDIR  = v8.4

A64    = ${XMLDIR}/ISA_A64_xml_${VERSION}
A32    = ${XMLDIR}/ISA_AArch32_xml_${VERSION}
SYSREG = ${XMLDIR}/SysReg_xml_${VERSION}
ifeq ($(XMLDIR),v8.4)
A64    = ${XMLDIR}/ISA_v84A_A64_xml_00bet7
SYSREG = ${XMLDIR}/SysReg_v84A_xml-00bet7
endif
ifeq ($(XMLDIR),v8.5)
VERSION = v85A-2019-06
A64    = ${XMLDIR}/ISA_A64_xml_${VERSION}
A32    = ${XMLDIR}/ISA_AArch32_xml_${VERSION}
SYSREG = ${XMLDIR}/SysReg_xml_${VERSION}
endif
ifeq ($(XMLDIR),v8.6)
VERSION = v86A-2019-12
A64    = ${XMLDIR}/ISA_A64_xml_${VERSION}
A32    = ${XMLDIR}/ISA_AArch32_xml_${VERSION}
SYSREG = ${XMLDIR}/SysReg_xml_${VERSION}
endif

FILTER =
# FILTER = --filter=usermode.json

arch/regs.asl: ${SYSREG}
	mkdir -p arch
	bin/reg2asl.py $< -o $@

arch/arch.asl arch/arch.tag arch/arch_instrs.asl arch/arch_decode.asl: ${A64}
	mkdir -p arch
	bin/instrs2asl.py --altslicesyntax --demangle --verbose -oarch/arch $^ ${FILTER}
	patch -Np0 < arch.patch

ASL += prelude.asl
ASL += regs.asl
ASL += arch.asl
ASL += support/aes.asl
ASL += support/barriers.asl
ASL += support/debug.asl
ASL += support/feature.asl
ASL += support/interrupts.asl
ASL += support/memory.asl
ASL += support/fetchdecode.asl
ASL += support/stubs.asl
ASL += support/usermode.asl

all :: arch/regs.asl
all :: arch/arch.asl

clean ::
	$(RM) -r arch

# Assumes that patched/* contains a manually fixed version of arch/*
arch.patch ::
	diff -Naur arch patched

# End
