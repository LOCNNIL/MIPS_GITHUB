module registerFile #(
	parameter DATA_WIDTH=32,
	parameter ADDR_WIDTH=8 
)
(
	input clk,
	input rst,
	input[DATA_WIDTH:0] data_In,
	input[3:0] data_InReg,
	input enable,
	input[3:0] data_OutRegA,
	input[3:0] data_OutRegB,
	output reg[ADDR_WIDTH-1:0] regA,
	output reg[ADDR_WIDTH-1:0] regB
);

//--------------Internal variables----------------

reg [DATA_WIDTH-1:0] s [0:(1<<ADDR_WIDTH)-1]; //registros de 0 - 7

reg [DATA_WIDTH-1:0] t [0:(1<<ADDR_WIDTH)-1]; //registros de 8 - 15

	integer i;

	initial begin
	 //inicializacao dos 16 registros
	 //for com a inicializacao dos vetores s e t zerando todos os registros
		for(i = 0; i < 8; i = i + 1)
			begin
				s[i] = 0;
				t[i] = 0;
			end
	end

	always @ (posedge clk) begin
						
		if(rst) begin	//Testa a condição de reset
			for(i = 0; i < 8; i = i + 1) begin //for com a inicializacao dos vetores s e t
				s[i] = 0;
				t[i] = 0;
			end
		end

		else begin//[3:0] data_InReg
			if(enable) begin
				if(data_InReg<4'b1000) //verifica para qual reg enviar os dados
					s[data_InReg] <= data_In; //salva os dados de entrada no reg0
				else if(data_InReg>4'b0111)
					t[data_InReg-4'b1000] <= data_In; //como o vetor t[7:0] precisa-se tirar 8 do data_InReg para tirar o offset de 8 a 15
			end					
		end
	end
	
	always @ (posedge clk) begin//
		if(data_OutRegA<4'b1000) //verifica se deve enviar os dados para o regA
				regA <= s[data_OutRegA]; //salva no regB o conteudo do s[i]
		else if(data_OutRegA>4'b0111)
			regA <= t[data_OutRegA-4'b1000];//salva no regB o conteudo do t[i]
			

		if(data_OutRegB<4'b1000) //verifica se deve enviar os dados para o regB
			regB <= s[data_OutRegB]; //salva no regB o conteudo do s[i]
		else if(data_OutRegB>4'b0111)
			regB <= t[data_OutRegB-4'b1000];	//salva no regB o conteudo do t[i]
	end
	
endmodule
