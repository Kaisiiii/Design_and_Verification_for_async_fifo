all: clr com sim
com:
	vcs -sverilog -full64 \
		-timescale=1ns/1ps \
		-debug_acc+r	\
		-LDFLAGS -DVCS	\
		${UVM_HOME}/src/dpi/uvm_dpi.cc	\
		-P /home/kai/Synopsys/verdi2016/share/PLI/VCS/linux64/novas.tab	\
		   /home/kai/Synopsys/verdi2016/share/PLI/VCS/linux64/pli.a	\
		+vcs+lic+wait	\
		-f file.list

sim:
	./simv -l sim.log	\
	+fsdb+autoflush

dve:
	dve -full64 -vpd vcdplus.vpd &

verdi:
	verdi	-nologo	\
			-f filelist.f	\
			-ssf *.fsdb &

clr:
	rm -rf sim* *.log csrc DVE* *.key \
		*.vpd novas* verdi* *.fsdb *.vpd \
		*Log 64 *.h	*.tcl reStart* 
