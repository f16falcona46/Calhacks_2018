package require fcgi
package require sqlite3
package require rest

set curdir [file dirname [info script]]

sqlite3 clientsDb [file join $curdir "clients.db"]
clientsDb eval {CREATE TABLE IF NOT EXISTS Clients (Id INTEGER NOT NULL UNIQUE, DoorOpen INTEGER, PRIMARY KEY(Id));}

fcgi Init
set sock [fcgi OpenSocket :8000]
set req [fcgi InitRequest $sock 0]

while {1} {
	fcgi Accept_r $req
	#get the requested page
	set pd [fcgi GetParam $req]
	set request_str [dict get $pd "REQUEST_URI"]
	
	set C "Status: 200 OK\n"
	#generate the page
	append C "Content-Type: "
	append C "text/html"
	append C "\r\n\r\n"
	
	set query_params [rest::parameters $request_str]
	
	if [dict exists $query_params "action"] {
		if {[dict get $query_params "action"] eq "add_sensor"} {
			set id [expr {int(1000000 * rand())}]
			clientsDb eval {INSERT INTO Clients (Id, DoorOpen) VALUES ($id, 0);}
			append C [format "%06d" $id]
		} elseif {[dict get $query_params "action"] eq "door_open"} {
			if [dict exists $query_params "id"] {
				set id [dict get $query_params "id"]
				clientsDb eval {UPDATE Clients SET DoorOpen=1 WHERE Id=$id;}
			} else {
				append C "Parameter id is missing."
			}
		} elseif {[dict get $query_params "action"] eq "door_close"} {
			if [dict exists $query_params "id"] {
				set id [dict get $query_params "id"]
				clientsDb eval {UPDATE Clients SET DoorOpen=0 WHERE Id=$id;}
			} else {
				append C "Parameter id is missing."
			}
		} elseif {[dict get $query_params "action"] eq "is_door_open"} {
			if [dict exists $query_params "id"] {
				set id [dict get $query_params "id"]
				append C [clientsDb eval {SELECT DoorOpen FROM Clients WHERE Id=$id;}]
			} else {
				append C "Parameter id is missing."
			}
		}
	} else {
		append C "Parameter action is missing."
	}
	
	#output the page
	fcgi PutStr $req stdout $C
	fcgi SetExitStatus $req stdout 0
	fcgi Finish_r $req
}