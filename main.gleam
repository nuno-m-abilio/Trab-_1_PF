import gleam/string
import gleam/list
import gleam/int
import sgleam/check

//   Análise do problema: O objetivo do trabalho é gerar a tabela de classificação do Brasileirão.
// Para isso, o usuário passará para o programa uma lista de Strings com os resultados dos jogos
// realizados, cada uma sendo escrito na forma “Anfitrião Gols Visitante Gols” (O nome dos times e
// quantidade de gols não tem o caractere de espaço, pois é ele que divide uma coisa da outra)
// (Nota-se que deve-se tratar os erros de formatação dessas Strings). Com isso, calcula-se se cada
// time teve uma vitória (que gera 3 pontos), derrota (que não gera pontos) ou empate (que gera 1
// ponto), e qual foi seu saldo de gols no jogo. Obtendo essas informações para todos os jogos e
// compilando-as, deve-se criar e devolver para o usuário uma tabela (formatada como uma lista de
// Strings) com as colunas "Nome do time", "Número de pontos", "Número de Vitórias" e "Saldo de
// Gols, ordenando-a a partir do "Número de Pontos" e, em caso de empates, usando os critérios
// "Número de Vitórias", "Saldo de Gols" e "Ordem Alfabética".



//   Projeto dos tipos de dados: Para solucionar o problema, é conveniente criar tipos de dados que
// adequem-se aos requisitos que são apresentados. Dito isso, dois deles serão criados - um para
// representar cada resultado de jogo e outro para representar cada linha da tabela de classificação:

// O resultado de um jogo do Brasileirão. 
pub type Jogo {
    // anf é o nome do time anfitrião que participou do jogo
    // golsAnf é a quantidade de gols que o anfitrião fez
    // vis é o nome do time visitante que participou do jogo
    // golsVis é a quantidade de gols que o visitante fez
    Jogo(anf: String, gols_anf: Int, vis: String, gols_vis: Int)
}

// Uma linha da tabela de classificação do Brasileirão
pub type Linha {
    // time é o nome de um clube esportivo participante do campeonato
    // pts é o número de pontos obtido pelo time
    // vit é o número de vitórias obtidas pelo time
    // sg é o saldo de gols do time (diferença entre gols pró e gols contra)
    Linha(time: String, pts: Int, vit: Int, sg: Int)
}



// Projeto de funções principais e auxiliares para resolução do problema:

// Gera a tabela de classificação do Brasileirão. Tomando como base os resultados dos jogos, coloca
// os times (primeira coluna) em ordem decerescente de "Número de Pontos" (segunda coluna) e, em
// caso de empates, usando os critérios "Número de Vitórias" (terceira coluna), "Saldo de Gols"
// (quarta coluna) "Ordem Alfabética". Caso o valor de algum jogo da entrada esteja errado,
// retorna-se um erro.
pub fn tabela_class(jogos: List(String)) -> Result(List(String), String){
    let tabela_jogos = tabela_jogos(jogos, Ok([]))
    case tabela_jogos {
        Error(inf) -> Error inf(inf)
        Ok(tabela_jogos_ok) -> todo // temos uma tabela com jogos todos certinhos, não precisa mais de Result
    }
}

// pub fn tabela_class_examples(){
//     check.eq(gera_tabela(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1",
//     "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"], Ok(["Flamengo 6 2 2",
//     "Atletico-MG 3 1 0", "Palmeiras 1 0 -1", "Sao-Paulo 1 0 -1"])))
//     check.eq(gera_tabela(["Sao-Paulo -1 Atletico-MG 2", "Flamengo 2 Palmeiras 1",
//     "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"], Error(Nil)))
//     check.eq(gera_tabela(["Sao-Paulo a Atletico-MG 2", "Flamengo 2 Palmeiras 1",
//     "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"], Error(Nil)))
//     check.eq(gera_tabela(["Sao Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1",
//     "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"], Error(Nil)))
//     check.eq(gera_tabela(["Sao-Paulo Atletico-MG 2", "Flamengo 2 Palmeiras 1",
//     "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"], Error(Nil)))
// }

// Gera uma lista com todos os jogos da entrada convertidos para o tipo de dados Jogo. Caso o valor
// de algum jogo da entrada esteja errado, retorna-se um erro. Para chamar a função de fora da
// recursão, tabela deve ser Ok([]).
pub fn tabela_jogos(jogos: List(String), tabela: Result(List(Jogo), String)) -> Result(List(Jogo), String){
    case jogos {
        [] -> case tabela {
            Ok(tabela_ok) -> Ok(list.reverse(tabela_ok))
            Error(inf) -> Error(inf) // Não é para acontecer jamais, mas eu quero acessar o valor dentro do Ok
        }
        [primeiro, ..resto] -> case converte_jogo(primeiro) {
            Ok(jogo_convertido) -> case tabela {
                Ok(tabela_ok) -> tabela_jogos(resto, Ok([jogo_convertido, ..tabela_ok]))
                Error(inf) -> Error(inf) // Não é para acontecer jamais, mas eu quero acessar o valor dentro do Ok
            }
            Error(inf) -> Error(inf)
        }
    }
}

pub fn tabela_jogos_examples(){
    check.eq(tabela_jogos(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0"],
    Ok([])), Ok([Jogo("Sao-Paulo", 1, "Atletico-MG", 2), Jogo("Flamengo", 2, "Palmeiras", 1), Jogo("Palmeiras", 0,
    "Sao-Paulo", 0)]))
    check.eq(tabela_jogos(["Sao-Paulo 1 Atletico-MG", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0"],
    Ok([])), Error("Erro #01: A formatação do jogo Sao-Paulo 1 Atletico-MG está incorreta. Há menos que 4 campos de informações"))
    check.eq(tabela_jogos(["Sao-Paulo 1 Atletico-MG 2", "Flamengo -2 Palmeiras -1", "Palmeiras 0 Sao-Paulo 0"],
    Ok([])), Error("Erro #08: Os valores do jogo Flamengo -2 Palmeiras -1 estão incoerentes. Tanto o segundo quanto o quarto campo, "
    <> "que deveriam representar inteiros positivos, aqui não o fazem."))
}

// Converte um resultado de jogo na forma de String para a formatação no tipo Jogo, caso a String
// tenha a representação correta. Caso contrário, retorna-se o erro que impediu a resposta certa.
pub fn converte_jogo(jogo_str: String) -> Result(Jogo, String){
    let jogo_separado: List(String) = separa_jogo(jogo_str, [])
    case jogo_separado{
        [] | [_] |[_, _] | [_, _, _] -> Error("Erro #01: A formatação do jogo " <> jogo_str <> " está"
        <> " incorreta. Há menos que 4 campos de informações")
        [primeiro, segundo, terceiro, quarto] -> case int.parse(segundo), int.parse(quarto) {
            Error(_), Error(_) -> Error("Erro #05: Os valores do jogo " <> jogo_str <> " estão incoerentes. Tanto"
            <> " o segundo quanto o quarto campo, que deveriam representar valores numéricos, aqui não o fazem.")
            Error(_), _ -> Error("Erro #03: Valores do jogo " <> jogo_str <> " estão incoerentes." <>
            " O segundo campo, que deveria representar um valor numérico, aqui não o faz.")
            _, Error(_) -> Error("Erro #04: Valores do jogo " <> jogo_str <> " estão incoerentes." <>
            " O quarto campo, que deveria representar um valor numérico, aqui não o faz.")
            Ok(segundo_int), Ok(quarto_int) -> case segundo_int, quarto_int {
                _, _ if segundo_int < 0 && quarto_int < 0 -> Error("Erro #08: Os valores do jogo " <>
                jogo_str <> " estão incoerentes. Tanto o segundo quanto o quarto campo, que deveriam" 
                <> " representar inteiros positivos, aqui não o fazem.")
                _, _ if segundo_int < 0 -> Error("Erro #06: Valores do jogo " <> jogo_str <> " estão" <>
                " incoerentes. O segundo campo, que deveria representar um inteiro positivo, aqui não o faz.")
                _, _ if quarto_int < 0 -> Error("Erro #07: Valores do jogo " <> jogo_str <> " estão" <>
                " incoerentes. O quarto campo, que deveria representar um inteiro positivo, aqui não o faz.")
                _, _ -> Ok(Jogo(primeiro, segundo_int, terceiro, quarto_int))
            }
        }
        _ -> Error("Erro #02: A formatação do jogo " <> jogo_str <> " está incorreta. Há mais que 4 campos"
        <> " de informações")
    }
}

pub fn converte_jogo_examples(){
    check.eq(converte_jogo("Sao-Paulo 1 Atletico-MG 2"), Ok(Jogo("Sao-Paulo", 1, "Atletico-MG", 2)))
    check.eq(converte_jogo("Sao-Paulo 1 Atletico-MG"), Error("Erro #01: A formatação do jogo" <>
    " Sao-Paulo 1 Atletico-MG está incorreta. Há menos que 4 campos de informações"))
    check.eq(converte_jogo("Sao-Paulo 1 Atle tico MG"),  Error("Erro #02: A formatação do jogo" 
    <> " Sao-Paulo 1 Atle tico MG está incorreta. Há mais que 4 campos de informações"))
    check.eq(converte_jogo("Sao-Paulo a Atletico-MG 2"),  Error("Erro #03: Valores do jogo Sao-Paulo a Atletico-MG 2"
    <> " estão incoerentes. O segundo campo, que deveria representar um valor numérico, aqui não o faz."))
    check.eq(converte_jogo("Sao-Paulo 1 Atletico-MG a"),  Error("Erro #04: Valores do jogo Sao-Paulo 1 Atletico-MG a"
    <> " estão incoerentes. O quarto campo, que deveria representar um valor numérico, aqui não o faz."))
    check.eq(converte_jogo("Sao-Paulo a Atletico-MG a"),  Error("Erro #05: Os valores do jogo Sao-Paulo a Atletico-MG" 
    <> " a estão incoerentes. Tanto o segundo quanto o quarto campo, que deveriam representar valores numéricos, aqui não o fazem."))
    check.eq(converte_jogo("Sao-Paulo -2 Atletico-MG 2"),  Error("Erro #06: Valores do jogo Sao-Paulo -2 Atletico-MG 2 estão" <>
    " incoerentes. O segundo campo, que deveria representar um inteiro positivo, aqui não o faz."))
    check.eq(converte_jogo("Sao-Paulo 2 Atletico-MG -2"),  Error("Erro #07: Valores do jogo Sao-Paulo 2 Atletico-MG -2 estão" <>
    " incoerentes. O quarto campo, que deveria representar um inteiro positivo, aqui não o faz."))
    check.eq(converte_jogo("Sao-Paulo -1 Atletico-MG -2"),  Error("Erro #08: Os valores do jogo Sao-Paulo -1 Atletico-MG -2 estão"
    <> " incoerentes. Tanto o segundo quanto o quarto campo, que deveriam representar inteiros positivos, aqui não o fazem."))
}


// Produz uma lista com os elementos da String de entrada separados pelos caracteres de espaço. É
// como se os caracteres de espaço na String se tornassem vírgulas na lista. Para chamar a função
// de fora da recursão, jogo_separado deve ser [].
pub fn separa_jogo(jogo_str: String, jogo_separado: List(String)) -> List(String){
    case string.first(jogo_str) {
        // Esse é o  fim da recursão, com a String estando vazia. Nesse caso, como a Lista estava
        // sendo feita colocando novos elementos no começo, ela deve ser invertida no final.
        Error(_) -> list.reverse(jogo_separado)
        // Demais casos em que há ao menos um caractere na String. Casos em que a lista ainda está
        // vazia ou o caractere de espaço aparece devem ser tratados de forma especial.
        Ok(inicial_str) -> case jogo_separado, inicial_str {
            [], " " -> separa_jogo(string.drop_left(jogo_str, 1), ["", "", ..jogo_separado])
            [], _ -> separa_jogo(string.drop_left(jogo_str, 1), [inicial_str, ..jogo_separado])
            _, " " -> separa_jogo(string.drop_left(jogo_str, 1), ["", ..jogo_separado])
            [primeiro, ..resto], _ -> separa_jogo(string.drop_left(jogo_str, 1), [primeiro <> inicial_str, ..resto])
        }
    }
}

pub fn separa_jogo_examples(){
    check.eq(separa_jogo("Sao-Paulo 1 Atletico-MG 2", []),["Sao-Paulo", "1", "Atletico-MG", "2"])
    check.eq(separa_jogo("", []),[])
    check.eq(separa_jogo(" Sao-Paulo 1 Atletico-MG 2", []),["", "Sao-Paulo", "1", "Atletico-MG", "2"])
    check.eq(separa_jogo("Sao Paulo", []),["Sao", "Paulo"])
    check.eq(separa_jogo("   ", []),["", "", "", ""])
}