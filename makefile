
all: com sim 
com:
	vcs -full64 -sverilog \
	-f ./rtl/file.list	\
	-l compile.log	\
	-timescale=1ns/1ns	\
	-debug_acc+r	\
	-LDFLAGS	\
	-rdynamic	\
	-P /home/kai/Synopsys/verdi2016/share/PLI/VCS/linux64/novas.tab	\
	   /home/kai/Synopsys/verdi2016/share/PLI/VCS/linux64/pli.a	\
	+vcs+lic+wait	\

sim:
	./simv -l sim.log	\
	+fsdb+autoflush
	

dve:
	dve -full64 -vpd vcdplus.vpd &

verdi:
	verdi -nologo	\
	-f	./rtl/file.list	\
	-ssf *.fsdb	&

clr:
	rm -rf sim* *.log csrc DVE* *.key *.vpd novas* verdi* *fsdb *.vdb *Log
