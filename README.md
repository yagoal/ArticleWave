# ArticleWave

ArticleWave é um aplicativo iOS desenvolvido para exibir notícias de várias fontes, utilizando a API [NewsAPI](https://newsapi.org). O aplicativo foi criado com base em uma série de requisitos e práticas recomendadas de desenvolvimento para garantir um código limpo, modular e testável.

## Requisitos Atendidos

- **Duas Telas**: O aplicativo possui duas telas principais.
  - **Tela Principal**: Exibe imagens, autores, títulos e descrições dos artigos utilizando `UITableView`.
  - **Tela de Detalhes**: Exibe a imagem, data de publicação e o conteúdo completo do artigo selecionado.
- **Auto Layout com View Code**: Todo o layout foi construído programaticamente utilizando Auto Layout.
- **Design Patterns**: Utiliza padrões de design como MVVM (Model-View-ViewModel) e Coordinator.
- **Frameworks Nativos**: Utiliza frameworks nativos do iOS como UIKit e Combine.
- **Protocol Oriented Programming**: Implementação baseada em protocolos para garantir flexibilidade e reutilização de código.
- **Princípios SOLID**: Segue os princípios SOLID para garantir um código mais robusto e fácil de manter.
- **Criatividade no Layout**: Layouts personalizados e uma interface intuitiva.
- **Testes com XCTest**: Testes unitários e de UI foram implementados utilizando XCTest.
- **Guia de Design da Apple**: Seguiu as Apple Human Interface Guidelines para garantir uma interface de usuário consistente e intuitiva.
- **Suporte a Tema Escuro**: O aplicativo oferece suporte a tema claro e escuro, ajustando automaticamente as cores da interface do usuário com base na configuração do sistema.

## Arquitetura

### MVVM (Model-View-ViewModel)
ArticleWave adota a arquitetura MVVM para separar a lógica de negócios da interface do usuário, facilitando a manutenção do código e permitindo a reutilização dos componentes.

- **Model**: Contém as estruturas de dados utilizadas pela aplicação, como `Article` e `ArticlesResponse`.
- **View**: Composta pelas views e view controllers que são responsáveis pela interface do usuário.
- **ViewModel**: Contém a lógica de apresentação e manipula a comunicação entre a View e o Model.

### Coordinator
O padrão Coordinator é utilizado para gerenciar a navegação entre diferentes telas, mantendo as view controllers simples e focadas em suas responsabilidades principais.

### Princípios de SOLID
O projeto procurou seguir princípios de design SOLID para garantir um código mais robusto, modular e fácil de manter, levando em consideração as particularidades do desafio e style Swift:

- **S**ingle Responsibility Principle: Cada classe tem uma única responsabilidade.
- **O**pen/Closed Principle: As classes são abertas para extensão, mas fechadas para modificação.
- **L**iskov Substitution Principle: As subclasses devem ser substituíveis por suas classes base.
- **I**nterface Segregation Principle: Muitas interfaces específicas são melhores do que uma interface geral.
- **D**ependency Inversion Principle: Dependa de abstrações, não de concretizações.

### Guias de Design da Apple
O desenvolvimento do ArticleWave seguiu as Apple Human Interface Guidelines para garantir uma interface de usuário intuitiva e uma experiência consistente com o ecossistema iOS.

## API

O aplicativo utiliza a [NewsAPI](https://newsapi.org) para buscar notícias em tempo real. A API fornece artigos de várias fontes e permite filtragem por país.

- **Endpoint**: `https://newsapi.org/v2/top-headlines`
- **Parâmetros**:
  - `country`: O código do país para filtrar as notícias (por exemplo, "br" para Brasil).
  - `apiKey`: A chave de API para autenticação.

# Funcionalidades


<details>
<summary>Video Demonstrativo</summary>
<br>
<div align="center">
  <a href="https://github.com/yagoal/ArticleWave/assets/85469576/067e2f79-373e-426e-a360-10608c3bdb0a">
    <video src="https://github.com/yagoal/ArticleWave/assets/85469576/067e2f79-373e-426e-a360-10608c3bdb0a" alt="Video Demonstrativo" />
  </a>
</div>

</details>

## Tela Principal
Na tela principal, os usuários podem selecionar diferentes bandeiras para buscar as últimas notícias de cada país. Os artigos são exibidos em uma lista, mostrando imagens, autores, títulos e descrições. A interface foi projetada para ser clara e intuitiva, permitindo que os usuários naveguem facilmente entre as notícias.

<details>
<summary>Imagens da Tela Principal</summary>
<br>
<p float="left">
  <img src="https://github.com/yagoal/ArticleWave/assets/85469576/47f58ef3-2ba3-4560-bec3-80403d884f6e" width="30%" />
  <img src="https://github.com/yagoal/ArticleWave/assets/85469576/ecaa4a59-193a-4fcb-88d8-fd39d635ef6d" width="30%" />
</p>

</details>

## Tela de Detalhes
Ao selecionar um artigo na tela principal, os usuários são levados para a tela de detalhes, onde podem ver uma imagem maior, a data de publicação e o conteúdo completo do artigo. Além disso, há um botão "Saiba Mais" que leva os usuários ao link original do artigo, permitindo acesso a informações adicionais sem sobrecarregar a interface do aplicativo.

<details>
<summary>Imagens da Tela de Detalhes</summary>
<br>
<p float="left">
  <img src="https://github.com/yagoal/ArticleWave/assets/85469576/f3cd8ad6-fd03-4c51-affe-e66655afa816" width="30%" />
  <img src="https://github.com/yagoal/ArticleWave/assets/85469576/037939b4-2c14-4ae4-a83a-c3d66463c8e2" width="30%" />
</p>

</details>


## Testes

### Testes Unitários
Os testes unitários garantem que as unidades individuais do código (como view models e serviços) funcionem conforme o esperado. O projeto utiliza o framework XCTest para testes unitários.

### Testes de UI
Os testes de interface do usuário (UI) verificam a interação do usuário com o aplicativo. Utilizamos o framework XCTest para automatizar os testes de UI.

#### Importância dos Testes
Os testes são fundamentais para garantir a qualidade e a confiabilidade do software. Eles ajudam a identificar e corrigir bugs, além de garantir que novas funcionalidades não quebrem o comportamento existente.

#### Como Executar os Testes

1. **Clone o Repositório**
   ```sh
   git clone https://github.com/yagoal/ArticleWave.git
   cd ArticleWave
   ```

2. **Abrir o Projeto no Xcode**
   Abra o arquivo `ArticleWave.xcodeproj` ou `ArticleWave.xcworkspace` no Xcode.

3. **Executar os Testes**
   No Xcode, selecione o esquema `ArticleWave` e pressione `Command + U` para executar todos os testes.

### Nota sobre a API Key
Idealmente, a `apiKey` deveria ser armazenada em uma variável de ambiente para evitar a exposição de informações sensíveis no código-fonte. No entanto, para facilitar a execução e os testes deste desafio, a `apiKey` está exposta diretamente no código.
