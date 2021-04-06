
{ Programa de Controle de Estoque - Pascal

    Desenvolvido por Rafael Alkmim
    Disciplina: Linguagens de Programacao

}

program controleEstoque;

uses crt, sysutils;

type
    produto = Record
    nome: string[30];
    quantidade: integer;
    dataValidade: string[10];
end;

function menu:integer;

    var opcao: integer;
begin

    clrscr; // Limpar a tela

    writeln('CONTROLE DE ESTOQUE');
    writeln;
    writeln('1 - Cadastro de Produtos');
    writeln('2 - Listar Estoque');
    writeln('3 - Registrar Venda');
    writeln('4 - Finalizar');
    writeln;
    writeln('Digite a opcao desejada: ');
    readln(opcao);

    menu := opcao;
end;

function opcaoCRUD:integer;

    var opcao: integer;
begin

    clrscr; // Limpar a tela

    writeln('OPCOES DE PRODUTOS');
    writeln;
    writeln('1 - Inserir Novo Produto');
    writeln('2 - Editar Produto');
    writeln('3 - Excluir Produto');
    writeln('4 - Voltar ao Menu Anterior');
    writeln;
    writeln('Digite a opcao desejada: ');
    readln(opcao);

    opcaoCRUD := opcao;
end;

procedure cadastraProduto;
var
  novoProduto: produto;
  arquivo: file of produto;
begin
  clrscr;

  writeln('CADASTRAR PRODUTO');
  writeln;
  write('Digite o nome do produto: ');
  readln(novoProduto.nome);
  write('Digite a quantidade do produto em estoque: ');
  readln(novoProduto.quantidade);
  write('Digite a data de validade do produto (dd/mm/aaaa): ');
  readln(novoProduto.dataValidade);

  assign(arquivo, 'produtos.dat');
  {$I-} reset(arquivo); {$I+};
  if ioresult <> 0 then
    rewrite(arquivo);

  if filesize(arquivo) > 0 then
    seek(arquivo, filesize(arquivo));

  write(arquivo, novoProduto);
  close(arquivo);
end;

procedure atualizaProduto;
var
  encontrado: boolean;
  nome: string[30];
  quantidade: integer;
  dataValidade: string[10];
  tmp: produto;
  arquivoAntigo, arquivoAtualizado: file of produto;
begin
  encontrado := false;
 
  clrscr;
 
  writeln('ATUALIZAR PRODUTO');
  writeln;
  write('Digite o nome do Produto: ');
  readln(nome);
  write('Digite a quantidade: ');
  readln(quantidade);
  write('Digite a data de validade: ');
  readln(dataValidade);
 
  assign(arquivoAntigo, 'produtos.dat');
  {$I-} reset(arquivoAntigo); {$I+};
  if ioresult = 0 then
  begin
    assign(arquivoAtualizado, 'temp.dat');
    {$I-} rewrite(arquivoAtualizado); {$I+};
    if ioresult <> 0 then
    begin
      writeln;
      write('ERRO! Nao foi possivel atualizar o produto.');
      close(arquivoAntigo);
      sleep(2000);
    end
    else
    begin
      seek(arquivoAntigo, 0);
      while not eof(arquivoAntigo) do
      begin
        read(arquivoAntigo, tmp);
        if nome = tmp.nome then
        begin
          tmp.quantidade := quantidade;
          tmp.dataValidade := dataValidade;
          encontrado := true;
        end;
        write(arquivoAtualizado, tmp);
      end;
      close(arquivoAntigo);
      close(arquivoAtualizado);
      erase(arquivoAntigo);
      rename(arquivoAtualizado, 'produtos.dat');
 
      writeln;
      if encontrado then
        write('Atualizacao realizada com sucesso!')
      else
        write('ERRO! Nao foi possivel encontrar o produto informado.');
      sleep(2000);
    end;
  end
  else
  begin
    writeln;
    write('Nao ha produtos cadastrados.');
    sleep(2000);
  end;
end;

procedure removeProduto;
var
  encontrado: boolean;
  nome: string[30];
  tmp: produto;
  arquivoAntigo, arquivoAtualizado: file of produto;
begin
  encontrado := false;
 
  clrscr;
 
  writeln('REMOVER PRODUTO');
  writeln;
  write('Digite o nome do produto a ser removido: ');
  readln(nome);
 
  assign(arquivoAntigo, 'produtos.dat');
  {$I-} reset(arquivoAntigo); {$I+};
  if ioresult = 0 then
  begin
    assign(arquivoAtualizado, 'temp.dat');
    {$I-} rewrite(arquivoAtualizado); {$I+};
    if ioresult <> 0 then
    begin
      writeln;
      write('ERRO! Nao foi possivel remover o produto.');
      close(arquivoAntigo);
      sleep(2000);
    end
    else
    begin
      seek(arquivoAntigo, 0);
      while not eof(arquivoAntigo) do
      begin
        read(arquivoAntigo, tmp);
        if nome <> tmp.nome then
        begin
          write(arquivoAtualizado, tmp);
        end
        else
          encontrado := true;
      end;
      close(arquivoAntigo);
      close(arquivoAtualizado);
 
      erase(arquivoAntigo);
      rename(arquivoAtualizado, 'produtos.dat');
 
      writeln;
      if encontrado then
        write('Exclusao realizada com sucesso!')
      else
        write('ERRO! Nao foi encontrado um produto com esse nome.');
      sleep(2000);
    end;
  end
  else
  begin
    writeln;
    write('Nao ha produtos cadastrados!');
    sleep(2000);
  end;
end;

procedure listarEstoque;
var
  currentProduto: produto;
  arquivo: file of produto;
begin
  clrscr;
 
  writeln('LISTAR ESTOQUE');
  writeln;
 
  assign(arquivo, 'produtos.dat');
  {$I-} reset(arquivo); {$I+};
  if ioresult <> 0 then
  begin
    writeln;
    write('Nao ha produtos cadastrados!');
    sleep(2000);
  end
  else
  begin
    seek(arquivo, 0);
    while not eof(arquivo) do
    begin
      read(arquivo, currentProduto);
      writeln;
      writeln('Produto: ', currentProduto.nome);
      writeln('Quantidade: ', currentProduto.quantidade);
      writeln('Data de validade: ', currentProduto.dataValidade);
    end;

    writeln;
    writeln('Pressione qualquer tecla para retornar.');
    writeln;

    ReadKey;
 
    close(arquivo);
  end;
end;

procedure menuCRUD;

var
  opcao_crud: integer;

begin
  repeat
    opcao_crud := opcaoCRUD;

    case opcao_crud of
      1: cadastraProduto;
      2: atualizaProduto;
      3: removeProduto;
      4:
      else
        begin
          writeln('Erro! Selecione uma opcao valida!');
        end
    end;
    sleep(1000); // Adiciona delay para exibir a opção
  until opcao_crud = 4;
end;

var
  opcao: integer;

begin
  repeat
    opcao := menu;

    case opcao of
      1: menuCRUD;
      2: listarEstoque;
      3: writeln('Registra Venda');
      4:
        begin
          writeln('Obrigado por utilizar nosso programa!');
        end
      else
        begin
          writeln('Erro! Selecione uma opcao valida!');
        end
    end;
    sleep(2000); // Adiciona delay para exibir a opção
  until opcao = 4;
end.
