#Makefile con todo el flujo de trabajo para GOWIN. Utilizando Yosys, nextpnr, iverilog, gtkwave y openFPGALoader



#Nombre del proyecto... Acá ponen el nombre que deseen.
PROYECT = Procesador

#Fuentes de diseno
SOURCES := $(wildcard ../design/*.v ../design/*.sv) #Todas las fuentes .v o .sv que estan en design
#Si quieren indicarlas una a una, pueden hacerlo como en este ejemplo:
#SOURCES = ../design/module_top_deco_gray.v ../design/module_input_deco_gray.v 

#Fuente de simulacion
#aca va el testbench que quieran simular
TESTBENCH = ../sim/Procesador_tb.sv


#el top se indica sin la extension .v, esto hace referencia al nombre que le pusieron al módulo y no al archivo en si.
TOP_DESIGN = Procesador
TOP_TB     = Procesador_tb

#nombre del vcd que va a generar el tb
VCD_FILE = Procesador_tb.vcd


all: synth test

# Synthesis
synth: ${SOURCES}
	@echo "Ejecutando la sintesis..."
	@yosys -p "read_verilog -sv ${SOURCES}; synth_gowin -top ${TOP_DESIGN} -json ${PROYECT}.json" > synthesis_${BOARD}.log 2>&1 
	@echo "COMPLETADO"
		
#Generar vcd con icarus verilog
test: ${SOURCES} ${TESTBENCH}
	@iverilog -o ${PROYECT}_test.o -s ${TOP_TB} -g2005-sv ${TESTBENCH} ${SOURCES}
	@vvp ${PROYECT}_test.o 
	
#Visualizar los diagramas de tiempo con GTKWave
wv: ${VCD_FILE}
	gtkwave ${VCD_FILE} 

.PHONY: load  wv
.INTERMEDIATE: ${PROYECT}_pnr.json ${PROYECT}.json