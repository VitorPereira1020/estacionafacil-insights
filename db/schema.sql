CREATE DATABASE IF NOT EXISTS estacionafacil;
USE estacionafacil;

CREATE TABLE usuario (id INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(100) NOT NULL,
  email VARCHAR(120) UNIQUE NOT NULL, senha_hash VARCHAR(255) NOT NULL,
  perfil ENUM('diretor','gerente','analista','admin') NOT NULL);

CREATE TABLE cliente (id INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(100), email VARCHAR(120));

CREATE TABLE veiculo (id INT AUTO_INCREMENT PRIMARY KEY, cliente_id INT NOT NULL, placa VARCHAR(10),
  categoria ENUM('carro_pequeno','carro_grande','moto') NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id));

CREATE TABLE servico (id INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(60) NOT NULL,
  categoria ENUM('vaga_avulsa','vaga_coberta','lavajato','estetica','manobrista','app_reserva','pernoite','contrato_mensal') NOT NULL);

CREATE TABLE atendimento (id INT AUTO_INCREMENT PRIMARY KEY, veiculo_id INT NOT NULL,
  tipo_contrato ENUM('avulso','semanal','mensal') NOT NULL, entrada DATETIME, saida DATETIME,
  pagamento ENUM('dinheiro','pix','credito','debito'),
  FOREIGN KEY (veiculo_id) REFERENCES veiculo(id));

CREATE TABLE atendimento_servico (atendimento_id INT, servico_id INT, PRIMARY KEY(atendimento_id, servico_id),
  FOREIGN KEY (atendimento_id) REFERENCES atendimento(id), FOREIGN KEY (servico_id) REFERENCES servico(id));

CREATE TABLE avaliacao (id INT AUTO_INCREMENT PRIMARY KEY, atendimento_id INT, servico_id INT NOT NULL,
  texto TEXT NOT NULL, nota TINYINT, data_avaliacao DATETIME NOT NULL,
  canal ENUM('site','app','csv') NOT NULL, lote_id INT,
  FOREIGN KEY (atendimento_id) REFERENCES atendimento(id), FOREIGN KEY (servico_id) REFERENCES servico(id));

CREATE TABLE analise_avaliacao (id INT AUTO_INCREMENT PRIMARY KEY, avaliacao_id INT UNIQUE NOT NULL,
  categoria_prevista VARCHAR(30), sentimento ENUM('positivo','neutro','negativo'), score DECIMAL(4,3),
  revisada_manual BOOLEAN DEFAULT FALSE, FOREIGN KEY (avaliacao_id) REFERENCES avaliacao(id));

CREATE TABLE topico (id INT AUTO_INCREMENT PRIMARY KEY, termo VARCHAR(60) UNIQUE NOT NULL);
CREATE TABLE analise_topico (analise_id INT, topico_id INT, PRIMARY KEY(analise_id, topico_id),
  FOREIGN KEY (analise_id) REFERENCES analise_avaliacao(id), FOREIGN KEY (topico_id) REFERENCES topico(id));

CREATE TABLE limiar (id INT AUTO_INCREMENT PRIMARY KEY, servico_id INT UNIQUE NOT NULL,
  valor_minimo DECIMAL(5,2) NOT NULL, amostra_minima INT DEFAULT 10, email_destino VARCHAR(120),
  FOREIGN KEY (servico_id) REFERENCES servico(id));

CREATE TABLE alerta (id INT AUTO_INCREMENT PRIMARY KEY, servico_id INT NOT NULL, data_hora DATETIME NOT NULL,
  is_calculado DECIMAL(5,2) NOT NULL, status ENUM('aberto','tratado') DEFAULT 'aberto', usuario_id INT,
  FOREIGN KEY (servico_id) REFERENCES servico(id), FOREIGN KEY (usuario_id) REFERENCES usuario(id));