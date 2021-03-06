-- DEFINE O BANCO DE DADOS "AGENCIA"
CREATE SCHEMA AGENCIA;
USE AGENCIA;


-- COMMANDOS DE SQL DDL PARA CRIAÇÃO DAS TABELAS
create table endereco(

cep varchar(10) not null,
estado varchar(2),
logradouro varchar(50),
predio varchar(10),
complemento varchar (20),
cidade varchar(20),
primary key (cep)

);

CREATE TABLE pessoa (
	cod int not null auto_increment,
	nome    varchar(100) not null, 
	dt_nasc date,
	sexo enum ('M', 'F'),
	fone   varchar(15),
    foto blob,
    cep varchar(10) not null, #da relacao
    num int check(num > 0), #da relacao
    
	primary key (cod),
    foreign key (cep) references endereco(cep)
);

create table agencia(

CNPJ char (18) not null unique,
nome_fantasia varchar(50),
cep varchar(10) unique, #da relacao
num int check(num > 0), #da relacao
codgerente int not null unique,  
datainicio date,
num_cliente int check(num >= 0),
num_funcionarios int check(num >= 0),

primary key (CNPJ),
foreign key (cep) references endereco(cep) 
#foreign key (codgerente) references gerente(cod)

);

create table agente(
salario decimal(10,2) check(salario>0), 
ramal int check(num > 0),
cpf char(14) not null unique,
cod int not null, #da hierarquia
cod_agencia char (18) not null,

primary key(cod),
constraint fk_agente_pessoa foreign key (cod) references pessoa(cod) on delete cascade on update cascade,
constraint fk_agente_agencia foreign key (cod_agencia) references agencia(CNPJ) on delete cascade on update cascade
);

create table guia(
salario decimal(10,2) check(salario>0), 
ramal int check(num > 0),
cpf char(14) not null unique,
cod int not null, #da hierarquia
cod_agencia char (18) not null,

primary key(cod),
constraint fk_guia_pessoa foreign key (cod) references pessoa(cod) on delete cascade on update cascade,
constraint fk_guia_agencia foreign key (cod_agencia) references agencia(CNPJ)on delete cascade on update cascade

);

create table motorista(
salario decimal(10,2) check(salario>0), 
ramal int check(num > 0),
cpf char(14) not null unique,
cod int not null, #da hierarquia
cod_agencia char (18) not null,

primary key(cod),
constraint fk_motorista_pessoa foreign key (cod) references pessoa(cod) on delete cascade on update cascade,
constraint fk_motorista_agencia foreign key (cod_agencia) references agencia(CNPJ) on delete cascade on update cascade

);

create table gerente(
salario decimal(10,2) check(salario>0), 
ramal int check(num > 0),
cpf char(14) not null unique,
cod int not null, #da hierarquia
cod_agencia char (18) not null,

primary key(cod),
constraint fk_gerente_pessoa foreign key (cod) references pessoa(cod) on delete cascade on update cascade,
constraint fk_gerente_agencia foreign key (cod_agencia) references agencia(CNPJ)on delete cascade on update cascade

);

ALTER TABLE agencia ADD constraint fk_agencia_gerente FOREIGN KEY ( codgerente ) REFERENCES gerente (cod) on update cascade; # pois estava dando erro antes


create table malaDireta(
codigo int not null auto_increment,
texto varchar(300),
dt_criacao date ,
dt_envio date check(dt_envio >= dt_criacao),

primary key (codigo)
);

create table arquivo_pdf(
codmala int not null,
arquivo varbinary(500),

primary key (codmala, arquivo),
constraint fk_arquivo_mala foreign key(codmala) references malaDireta(codigo) on delete cascade on update cascade
);

create table cliente_juridico( 
cod int not null, #da hierarquia
agencia char (18),
CNPJ char (18), 
nome_fantasia varchar(50),

primary key(cod),
constraint fk_juridico_agencia foreign key (agencia) references agencia(CNPJ) on update cascade,
constraint fk_juridico_pessoa foreign key (cod) references pessoa(cod) on delete cascade on update cascade

);

create table clienteJuridico_recebe_malaDireta(

codcliente int not null,
codmala int not null, 

primary key(codcliente, codmala),
constraint fk_juridicoMala_juridico foreign key(codcliente) references cliente_juridico(cod) on delete cascade on update cascade,
constraint fk_juridicoMala_mala foreign key(codmala) references malaDireta(codigo) on delete cascade on update cascade
);

create table cliente_fisico( 
cod int not null, #da hierarquia
agencia char (18),
cpf char (14), 
tipo int not null check(3>=tipo>0), 

primary key(cod),
constraint fk_fisico_agencia foreign key (agencia) references agencia(CNPJ) on update cascade,
constraint fk_fisico_pessoa foreign key (cod) references pessoa(cod) on delete cascade on update cascade

);

create table clienteFisico_recebe_malaDireta(

codcliente int not null,
codmala int not null, 

primary key(codcliente, codmala),
constraint fk_fisicoMala_fisico foreign key(codcliente) references cliente_fisico(cod) on delete cascade on update cascade,
constraint fk_fisicoMala_mala foreign key(codmala) references malaDireta(codigo) on delete cascade on update cascade
);

create table passaporte(
numero varchar(10) not null unique, 
pais_emissao varchar(50),
validade date,
dt_emissao date check(validade > dt_emissao), 
codcliente int not null,

primary key(numero),
constraint fk_passaporte_fisico foreign key(codcliente) references cliente_fisico(cod) on delete cascade on update cascade
);

create table visto(
controlnumber varchar(14) not null unique,
numeroPass varchar(10) not null,
tipo varchar(5), 
pais varchar(50),
dt_inicio date , 
dt_fim date check(dt_fim > dt_inicio), 

primary key(controlnumber),
constraint fk_visto_passaporte foreign key(numeroPass) references passaporte(numero) on delete cascade on update cascade
);

create table pacote(

codigo int not null unique auto_increment,
total_a_pagar decimal(10,2) check(total_a_pagar > 0),
vl_total decimal(10,2) check(vl_total > 0), 
vl_desconto decimal(10,2) check(vl_desconto > 0), 
datafim date check(datafim >= datainicio),
datainicio date check(datafim >= datainicio),
indicadorReserva int check(1>=indicadorReserva>=0),
tipo int not null check( 1<= tipo <=3),
n_criancas int check(n_criancas >= 0),
n_adultos int check(n_adultos >= 0),

primary key(codigo) 
);

create table clienteFisico_compra(
dt_compra date not null,
stats int check(1>=stats>=0),
codagente int not null,
codpacote int not null, 
codcliente int not null,

primary key (codagente, codpacote,codcliente, dt_compra),
constraint fk_fisicoCompra_agente foreign key (codagente) references agente(cod) on delete cascade on update cascade,
constraint fk_fisicoCompra_pacote foreign key(codpacote) references pacote(codigo) on delete cascade on update cascade,
constraint fk_fisicoCompra_fisico foreign key(codcliente) references cliente_fisico(cod) on delete cascade on update cascade

);

create table clienteJuridico_compra(
dt_compra date not null,
stats int check(1>=stats>=0),
codagente int not null,
codpacote int not null, 
codcliente int not null,

primary key (codagente, codpacote,codcliente, dt_compra),
constraint fk_juridicoCompra_agente foreign key (codagente) references agente(cod) on delete cascade on update cascade,
constraint fk_juridicoCompra_pacote foreign key(codpacote) references pacote(codigo) on delete cascade on update cascade,
constraint fk_juridicoCompra_juridico foreign key(codcliente) references cliente_juridico(cod) on delete cascade on update cascade

);

create table nivel_servico(
codigo int not null unique,
nivel int check(nivel>=0), 
descr varchar(100),

primary key(codigo)
);

create table servico_ref(
codigo int not null unique auto_increment, 
valor decimal(10,2) check(valor>0),
local_destino varchar(50),
nivel int ,
tipoServico int not null, #serviço parceiro, serviço proprio

primary key(codigo),
foreign key(nivel) references nivel_servico(codigo) 
);

create table item_pacote(
id_sk int unique auto_increment ,
codservico int not null, 
codpacote int not null, 
dt date,
vl_unitario decimal(10,2) check(vl_unitario>0),
qtd int check(qtd >= 0), 
seq int check(seq>0),
vl_com_desconto decimal(10,2),

primary key(id_sk),
constraint fk_itemPacote_pacote foreign key(codpacote) references pacote(codigo) on delete cascade on update cascade,
constraint fk_itemPacote_servico foreign key (codservico) references servico_ref(codigo) on delete cascade on update cascade,
unique index sk (codpacote, codservico)
);

create table fatura(
id int not null unique auto_increment,
codpacote int ,
dt_fatura date, 
stats int check(1>=stats>=0), 

primary key(id),
foreign key(codpacote) references pacote(codigo)

);

create table itens_fatura(
id int not null,
sk_itemPacote int not null,

primary key(id, sk_itemPacote),
constraint fk_itemFatura_fatura foreign key(id) references fatura(id) on delete cascade on update cascade,
constraint fk_itemFatura_pacote foreign key(sk_itemPacote)references item_pacote(id_sk) on delete cascade on update cascade
);



create table pagamento(
codigo int not null unique auto_increment,
vl_pago decimal(10,2) check(vl_pago>0),
juros decimal(10,2) check(juros>=0),
dt_vence date ,
dt_pag date check(dt_vence >= dt_pag),
codFatura int,
tipo int not null check(3>=tipo >= 1), #da hierarquia
cod_seg int,
numero_cartao varchar(20),
dt_validade date check(dt_validade > dt_pag), 
tipoCartao int check(1 >= tipoCartao >= 0), 
nome_titular varchar(100),

primary key(codigo),
foreign key(codFatura) references fatura(id)
); 

create table mapa_arquivo(
codServico int not null, 
mapa varbinary(500) not null,

primary key(mapa, codServico),
constraint fk_mapa_servico foreign key(codServico) references servico_ref(codigo) on delete cascade on update cascade
);

create table promocao(
id int not null unique,
dt_fim date,
porcentagem_desconto double,
tipo int, 
dt_inicio date check(dt_fim >= dt_inicio),
codservico int,

primary key(id),
constraint fk_promocao_servico foreign key(codservico)  references servico_ref(codigo) on delete cascade on update cascade
);

create table intercambio(
codigo int not null,
obs varchar(200),
detalhe varchar(200),
tipo_intercambio int not null, #hierarquia

cargo varchar(20),#trabalho
dt_inicio date,
dt_fim date check(dt_fim >= dt_inicio),

cargaHoraria int check(cargaHoraria > 0), #estudo
nome_curso varchar(50),
lingua varchar(20),

primary key(codigo),
constraint fk_intercambio_servico foreign key(codigo) references servico_ref(codigo) on delete cascade on update cascade
);

create table acomodacao(
codigo int not null,
descricao varchar(100),
data_entrada date,
dt_saida date check(dt_saida >= data_entrada),
capacidade_pessoas int check(capacidade_pessoas > 0),
fumante int check (1 >= fumante >=0),
no_estrelas int check(5 >= no_estrelas > 0),
tipo varchar(100), 

primary key(codigo),
constraint fk_acomodacao_servico foreign key(codigo) references servico_ref(codigo) on delete cascade on update cascade
);

create table evento(
codigo int not null,
stats varchar(100),
data_entrada date,
dt_fim date check(dt_fim >= data_entrada),
nome varchar(100),
detalhe varchar(100),
tipo int ,
vl_desc varchar(100),
obs varchar(100), 
guiacod int not null,

primary key(codigo),
constraint fk_evento_servico foreign key(codigo) references servico_ref(codigo) on delete cascade on update cascade,
FOREIGN KEY(guiacod) REFERENCES guia(cod) 

);

create table transporte(
codigo int not null,
local_de_origem varchar(100),
data_ida date,
dt_volta date check(dt_volta >= data_ida),
modalidade varchar(100),
marca varchar(100),
tipo varchar(50),
num_identificacao int check(num_identificacao >= 0),
capacidade_n_pessoas int check(capacidade_n_pessoas >= 0),
motoristacod int not null,

primary key(codigo),
constraint fk_transporte_servico foreign key(codigo) references servico_ref(codigo) on delete cascade on update cascade,
FOREIGN KEY(motoristacod) REFERENCES motorista(cod)

);

create table servico_proprio(
codigo int not null,

primary key(codigo),
constraint fk_servicoProprio_servico foreign key(codigo) references servico_ref(codigo) on delete cascade on update cascade
);

create table servico_parceiro(
codigo int not null,

primary key(codigo),
constraint fk_servicoParceiro_servico foreign key(codigo) references servico_ref(codigo) on delete cascade on update cascade
);

create table parceiro(

CNPJ varchar(18) not null unique,
nome_fantasia varchar(50),
stats int check( 1 >=stats >= 0), 
tipo int check(4 >=tipo > 0), 
ramo varchar(10),

primary key(CNPJ)
);

create table oferece(
codigo int not null,
CNPJ varchar(18) not null,
dt_inicio date, 
dt_fim date check(dt_fim >= dt_inicio), 
percentual float check(percentual >= 0), 
no_contrato int not null,

primary key(codigo, CNPJ, no_contrato),
constraint fk_oferece_servicoParceiro foreign key(codigo) references servico_parceiro(codigo) on delete cascade on update cascade,
constraint fk_oferece_parceiro foreign key(CNPJ) references parceiro(CNPJ) on delete cascade on update cascade

);




