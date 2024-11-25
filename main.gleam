import gleam/string
import gleam/list
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
// pub fn tabela_class(jogos: List(String)) -> Result(List(String), Nil){
//     todo
// }

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
// de algum jogo da entrada esteja errado, retorna-se um erro.
// pub fn tabela_jogos(jogos: List(String), tabela: Result(List(Jogo), Nil)) -> Result(List(Jogo), Nil){
//     todo
// }

// pub fn converte_jogo(jogo_separado: List(String), contador: Int) -> Result(Jogo, Nil){
//     todo
// }

// Vou fazer a lista invertida porque vai ficar mais fácil de ir modificando, quanquer coisa da
// para inverter a hora de retornar
pub fn separa_jogo(jogo_str: String, jogo_separado: List(String)) -> List(String){
    case string.first(jogo_str) {
        Error(_) -> list.reverse(jogo_separado)
        Ok(inicial_str) -> case jogo_separado, inicial_str {
            [], " " -> separa_jogo(string.drop_left(jogo_str, 1), ["", "", ..jogo_separado])
            [], _ -> separa_jogo(string.drop_left(jogo_str, 1), [inicial_str, ..jogo_separado])
            _, " " -> separa_jogo(string.drop_left(jogo_str, 1), ["", ..jogo_separado])
            [primeiro, ..resto], _ -> separa_jogo(string.drop_left(jogo_str, 1), [primeiro <> inicial_str, ..resto])
        }
    }
}

pub fn tabela_class_examples(){
    check.eq(separa_jogo("Sao-Paulo 1 Atletico-MG 2", []),["Sao-Paulo", "1", "Atletico-MG", "2"])
    check.eq(separa_jogo("", []),[])
    check.eq(separa_jogo(" Sao-Paulo 1 Atletico-MG 2", []),["", "Sao-Paulo", "1", "Atletico-MG", "2"])
    check.eq(separa_jogo("Sao Paulo", []),["Sao", "Paulo"])
    check.eq(separa_jogo("   ", []),["", "", "", ""])
}
