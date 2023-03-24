/* Keccak Core
	Module: keccak_pagkage
	Date: 20/12/2021
	Author: Tran Cong Tien
	ID: 1810580
*/

package keccak_pkg;
	parameter	NUM_PLANE = 5;
	parameter	NUM_SHEET = 5;
	parameter	N 	  = 64;
	
	typedef logic	[N-1:0]		lane;
	typedef lane	[NUM_SHEET-1:0] plane;
	
	typedef plane	[NUM_PLANE-1:0] state;
	//stateA = [y][x][z]

	//function ABS 
	function int ABS (int numberIn);
        	ABS = (numberIn < 0) ? -numberIn : numberIn;
    	endfunction
endpackage
