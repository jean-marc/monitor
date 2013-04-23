CC = g++ -std=c++0x -I . -O3 
CFLAGS = -w -Wno-invalid-offsetof -Xlinker -zmuldefs -DOBJRDF_VERB -DPERSISTENT #-DTEST_STRING
monitor_server:monitor_server.cpp
	$(CC) $(CFLAGS) $< -lobjrdf -o monitor_server
clean:
	rm -f monitor_server

